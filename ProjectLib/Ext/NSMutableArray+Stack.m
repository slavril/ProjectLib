
#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (ZippieStack)

- (void)push:(id)object{
    if (object) {
        [self addObject:object];
    }
}

- (id)pop{
    id currentItem = [self currentItem];
    if (currentItem != nil) {
        [self removeObjectAtIndex:0];
    }
    return currentItem;
}

- (BOOL)isEmpty{
    return self.count == 0;
}

- (id)currentItem{
    if(![self isEmpty]){
        id item = self[0] ;
        return item;
    }
    return nil;
}

@end
