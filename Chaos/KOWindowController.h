#import <Cocoa/Cocoa.h>
#import "KOTextView.h"

@interface KOWindowController : NSWindowController <NSWindowDelegate>

- (void) useGridSize:(NSSize)size;

- (int) cols;
- (int) rows;

- (void) setChar:(NSString*)c x:(int)x y:(int)y fg:(NSColor*)fg bg:(NSColor*)bg;
- (void) setStr:(NSString*)str x:(int)x y:(int)y fg:(NSColor*)fg bg:(NSColor*)bg;

@property (copy) dispatch_block_t windowResizedHandler;

- (void) useKeyDownHandler:(KOKeyDownHandler)handler;

@end
