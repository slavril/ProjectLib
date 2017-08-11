
#import <Foundation/Foundation.h>

@interface NSMutableArray (ZippieStack)

- (void)push:(id)object;
- (id)pop;
- (BOOL)isEmpty;

@end
