#import "lua/lauxlib.h"
#import "KOWindowController.h"

static NSColor* SDColorFromHex(const char* hex) {
    static NSMutableDictionary* colors;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colors = [NSMutableDictionary dictionary];
    });
    
    NSString* hexString = [[NSString stringWithUTF8String: hex] uppercaseString];
    NSColor* color = [colors objectForKey:hexString];
    
    if (!color) {
        NSScanner* scanner = [NSScanner scannerWithString: hexString];
        unsigned colorCode = 0;
        [scanner scanHexInt:&colorCode];
        color = [NSColor colorWithCalibratedRed:(CGFloat)(unsigned char)(colorCode >> 16) / 0xff
                                          green:(CGFloat)(unsigned char)(colorCode >> 8) / 0xff
                                           blue:(CGFloat)(unsigned char)(colorCode) / 0xff
                                          alpha: 1.0];
        [colors setObject:color forKey:hexString];
    }
    
    return color;
}

// args: [win, fn]
static int win_resized(lua_State *L) {
    KOWindowController* wc = (__bridge KOWindowController*)*(void**)lua_touserdata(L, lua_upvalueindex(1));
    
    int i = luaL_ref(L, LUA_REGISTRYINDEX);
    
    wc.windowResizedHandler = ^{
        lua_rawgeti(L, LUA_REGISTRYINDEX, i);
        lua_pcall(L, 0, 0, 0);
    };
    
    return 0;
}

// args: [win, fn(t)]
static int win_keydown(lua_State *L) {
    KOWindowController* wc = (__bridge KOWindowController*)*(void**)lua_touserdata(L, lua_upvalueindex(1));
    
    int i = luaL_ref(L, LUA_REGISTRYINDEX);
    
    [wc useKeyDownHandler:^(BOOL ctrl, BOOL alt, BOOL cmd, NSString *str) {
        lua_rawgeti(L, LUA_REGISTRYINDEX, i);
        
        lua_newtable(L);
        lua_pushboolean(L, ctrl);
        lua_setfield(L, -2, "ctrl");
        lua_pushboolean(L, alt);
        lua_setfield(L, -2, "alt");
        lua_pushboolean(L, cmd);
        lua_setfield(L, -2, "cmd");
        lua_pushstring(L, [str UTF8String]);
        lua_setfield(L, -2, "key");
        
        lua_pcall(L, 1, 0, 0);
    }];
    
    return 0;
}

// args: [win]
static int win_getsize(lua_State *L) {
    KOWindowController* wc = (__bridge KOWindowController*)*(void**)lua_touserdata(L, lua_upvalueindex(1));
    lua_pushnumber(L, [wc cols]);
    lua_pushnumber(L, [wc rows]);
    return 2;
}

// args: [win, char, x, y, fg, bg]
static int win_set(lua_State *L) {
    KOWindowController* wc = (__bridge KOWindowController*)*(void**)lua_touserdata(L, lua_upvalueindex(1));
    
    unsigned short c = lua_tonumber(L, 2);
    int x = lua_tonumber(L, 3) - 1;
    int y = lua_tonumber(L, 4) - 1;
    NSColor* fg = SDColorFromHex(lua_tostring(L, 5));
    NSColor* bg = SDColorFromHex(lua_tostring(L, 6));
    
    [wc setChar:c x:x y:y fg:fg bg:bg];
    
    return 0;
}

// args: [win, bg]
static int win_clear(lua_State *L) {
    KOWindowController* wc = (__bridge KOWindowController*)*(void**)lua_touserdata(L, lua_upvalueindex(1));
    
    NSColor* bg = SDColorFromHex(lua_tostring(L, 2));
    [wc clear:bg];
    
    return 0;
}

// args: [win, w, h]
static int win_resize(lua_State *L) {
    KOWindowController* wc = (__bridge KOWindowController*)*(void**)lua_touserdata(L, lua_upvalueindex(1));
    
    int w = lua_tonumber(L, 2);
    int h = lua_tonumber(L, 3);
    [wc useGridSize:NSMakeSize(w, h)];
    
    return 0;
}

// args: [win, name, size]
static int win_usefont(lua_State *L) {
    KOWindowController* wc = (__bridge KOWindowController*)*(void**)lua_touserdata(L, lua_upvalueindex(1));
    
    NSString* name = [NSString stringWithUTF8String: lua_tostring(L, 2)];
    double size = lua_tonumber(L, 3);
    
    NSFont* font = [NSFont fontWithName:name size:size];
    [wc useFont:font];
    
    return 0;
}

// args: [win]
// returns: [name, size]
static int win_getfont(lua_State *L) {
    KOWindowController* wc = (__bridge KOWindowController*)*(void**)lua_touserdata(L, lua_upvalueindex(1));
    
    NSFont* font = [wc font];
    
    lua_pushstring(L, [[font fontName] UTF8String]);
    lua_pushnumber(L, [font pointSize]);
    
    return 2;
}

// args: [win, title]
static int win_settitle(lua_State *L) {
    KOWindowController* wc = (__bridge KOWindowController*)*(void**)lua_touserdata(L, lua_upvalueindex(1));
    
    NSString* title = [NSString stringWithUTF8String: lua_tostring(L, 2)];
    [[wc window] setTitle:title];
    
    return 0;
}

// args: [win]
static int win_close(lua_State *L) {
    KOWindowController* wc = (__bridge KOWindowController*)*(void**)lua_touserdata(L, lua_upvalueindex(1));
    
    [wc close];
    
    return 0;
}

static const luaL_Reg winlib_instance[] = {
    // event handlers
    {"resized", win_resized},
    {"keydown", win_keydown},
    
    // methods
    {"close", win_close},
    
    {"getsize", win_getsize},
    {"resize", win_resize},
    
    {"clear", win_clear},
    {"set", win_set},
    
    {"usefont", win_usefont},
    {"getfont", win_getfont},
    
    {"settitle", win_settitle},
    
    {NULL, NULL}
};

static int win_gc(lua_State *L) {
    KOWindowController* wc = (__bridge_transfer KOWindowController*)*(void**)lua_touserdata(L, 1);
    [wc close];
    return 0;
}

// args: []
// returns: [win]
static int win_new(lua_State *L) {
    KOWindowController* wc = [[KOWindowController alloc] init];
    [wc showWindow: nil];
    void* ud = (__bridge_retained void*)wc;
    
    /*
     - the __gc method /automatically/ gets the userdata as its arg
     - predefined methods will share the userdata as an upvalue
     */
    
    lua_newtable(L);                                  // [win]
    lua_newtable(L);                                  // [win, {}]
    luaL_newlibtable(L, winlib_instance);             // [win, {}, methods]
    
    *(void**)lua_newuserdata(L, sizeof(void*)) = ud;  // [win, {}, methods, ud]
    lua_newtable(L);                                  // [win, {}, methods, ud, {}]
    lua_pushcfunction(L, win_gc);                     // [win, {}, methods, ud, {}, gc]
    lua_setfield(L, -2, "__gc");                      // [win, {}, methods, ud, {...}]
    lua_setmetatable(L, -2);                          // [win, {}, methods, ud]
    
    luaL_setfuncs(L, winlib_instance, 1);             // [win, {}, methods]
    
    lua_setfield(L, -2, "__index");                   // [win, {...}]
    lua_setmetatable(L, -2);                          // [win]
    
    return 1;
}

static const luaL_Reg winlib[] = {
    {"new", win_new},
    {NULL, NULL}
};

int luaopen_window(lua_State* L) {
    luaL_newlib(L, winlib);
    return 1;
}
