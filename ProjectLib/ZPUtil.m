//
//  ZPUtil.m
//  Zippie
//
//  Created by Minh Tran on 5/14/15.
//  Copyright (c) 2015 Lunex. All rights reserved.
//

#import "ZPUtil.h"

void da_main(dispatch_block_t block) {
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

void da_syncMain(dispatch_block_t block) {
    dispatch_sync(dispatch_get_main_queue(), ^{
        block();
    });
}

void da_default(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        block();
    });
}

void da_background(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0), ^{
        block();
    });
}

void da_high(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
        block();
    });
}

void da_low(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,0), ^{
        block();
    });
}

void delayOnMain(int64_t time, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

void delayOnQueue(dispatch_queue_t queue, int64_t time, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), queue, ^{
        block();
    });
}

void da_mainSafeWithBlock(dispatch_block_t block){
    if ([NSThread isMainThread]) {
        block();
    }
    else{
        da_main(block);
    }
}

void da_syncMainSafeWithBlock(dispatch_block_t block){
    if ([NSThread isMainThread]) {
        block();
    }
    else{
        da_syncMain(block);
    }
}

void dp_performBlockOnMainThreadAndWait(dispatch_block_t block, BOOL waitUntilDone){
    if (waitUntilDone) {
        if ([NSThread isMainThread]) {
            block();
        }
        else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                block();
            });
        }
    }
    else{
        da_main(block);
    }
}

@implementation NSObject (Blocks)

- (void)safeThreadWithBlock:(void (^)())block {
    da_mainSafeWithBlock(block);
}

- (void)performSelectorWithBlock:(void(^)())block{
    [self performSelectorWithBlock:block afterDelay:0];
}

- (void)performSelectorWithBlock:(void(^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        block();
    });
}

@end

@implementation ZPUtil

@end
