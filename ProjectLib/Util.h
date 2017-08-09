//
//  ZPUtil.h
//  Zippie
//
//  Created by Minh Tran on 5/14/15.
//  Copyright (c) 2015 Lunex. All rights reserved.
//

#import <Foundation/Foundation.h>

// For when you need a weak reference of an object, example: `BlockWeakObject(obj) wobj = obj;`
#define BlockWeakObject(o) __typeof__(o) __weak
#define BlockStrongObject(o) __typeof(o) __strong

#define BlockWeakSelf BlockWeakObject(self)
#define BlockStrongSelf BlockStrongObject(self)

extern void da_main(dispatch_block_t block);
extern void da_syncMain(dispatch_block_t block);
extern void da_default(dispatch_block_t block);
extern void da_background(dispatch_block_t block);
extern void da_high(dispatch_block_t block);
extern void da_low(dispatch_block_t block);
extern void delayOnMain(int64_t time, dispatch_block_t block);
extern void delayOnQueue(dispatch_queue_t queue, int64_t time, dispatch_block_t block);
extern void da_mainSafeWithBlock(dispatch_block_t block);
extern void da_syncMainSafeWithBlock(dispatch_block_t block);
extern void dp_performBlockOnMainThreadAndWait(dispatch_block_t block, BOOL waitUntilDone);

@interface NSObject (Blocks)

- (void)safeThreadWithBlock:(void (^)())block;
- (void)performSelectorWithBlock:(void (^)())block;
- (void)performSelectorWithBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;

@end

@interface ZPUtil : NSObject

@end
