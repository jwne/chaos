#import "KOAppDelegate.h"

@interface KOAppDelegate ()

@property NSSize charsize;

@end

@implementation KOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object:self.window];
    
    NSDictionary* attrs = @{NSForegroundColorAttributeName: [NSColor blueColor],
                            NSBackgroundColorAttributeName: [NSColor yellowColor],
                            NSFontAttributeName: [NSFont fontWithName:@"Menlo" size:12]};
    
    NSString* str = @"\n"
    "(sdegutis) [woo] (16:41:46) ~/projects\n"
    "$ ls\n"
    "billow                     cleancoders_infrastructure myed2\n"
    "chaos                      datomic                    myeditor\n"
    "chaos2                     dotfiles\n"
    "cleancoders.com            hydra\n"
    ;
    
    self.tv.str = [[NSMutableAttributedString alloc] initWithString:str attributes:attrs];
    
    NSSize s = [@"x" sizeWithAttributes:attrs];
    self.charsize = s;
    s.width = ceil(s.width);
    s.height = ceil(s.height);
    
    NSRect f = [self.window frame];
    f.size.width = s.width * 50;
    f.size.height = s.height * 10 - 14;
    [self.window setFrame:f display:YES];
    
    [self.window setResizeIncrements:s];
}

- (void) windowDidResize:(NSNotification *)notification {
    NSSize s = [[self.window contentView] frame].size;
    
    CGFloat w = floor(s.width / self.charsize.width);
    CGFloat h = floor(s.height / self.charsize.height);
    
    [self.tv.str deleteCharactersInRange:NSMakeRange(0, self.tv.str.length)];
    
    NSDictionary* attrs = @{NSForegroundColorAttributeName: [NSColor whiteColor],
                            NSBackgroundColorAttributeName: [NSColor blackColor],
                            NSFontAttributeName: [NSFont fontWithName:@"Menlo" size:12]};
    
    int c = 'a';
    
    NSMutableString* ms = [NSMutableString string];
    for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
            [ms appendFormat:@"%c", c++];
            if (c == 'z' + 1) c = 'a';
        }
        [ms appendString:@"\n"];
    }
    
    NSAttributedString* astr = [[NSAttributedString alloc] initWithString:ms
                                                               attributes:attrs];
    
    [self.tv.str appendAttributedString:astr];
    
//    [self.tv.str enumerateAttribute:NSBackgroundColorAttributeName
//                            inRange:NSMakeRange(0, self.tv.str.length)
//                            options:0
//                         usingBlock:^(id value, NSRange range, BOOL *stop) {
//                             <#code#>
//                         }];
    
//    NSLog(@"resized %f, %f", w, h);
}

@end