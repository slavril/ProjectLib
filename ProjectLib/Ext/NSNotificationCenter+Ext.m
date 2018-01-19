//
//  NSNotificationCenter+Ext.m
//  Zippie
//
//  Created by Anh Quan on 6/22/15.
//  Copyright (c) 2015 Lunex. All rights reserved.
//

#import "NSNotificationCenter+Ext.h"

@implementation NSNotificationCenter (ZippieExt)

+ (void)addObserverForName:(NSString *)name object:(id)object usingBlock:(void (^)(NSNotification *note))block {
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:name object:object queue:mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        block(note);
    }];
}

+ (void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:object];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:object];
}

+ (void)addObserver:(id<NSNotificationCenterEventDelegate>)observer name:(NSString *)name object:(id)object{
    [[NSNotificationCenter defaultCenter] addObserver:observer name:name object:object];
}

- (void)addObserver:(id<NSNotificationCenterEventDelegate>)observer name:(NSString *)name object:(id)object{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:object];
    [self addObserver:observer selector:@selector(notificationCenterDidReceiveEventNotification:) name:name object:object];
}

+ (void)postNotification:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

+ (void)postNotificationName:(NSString *)name {
    [self postNotificationName:name object:nil];
}

+ (void)postNotificationName:(NSString *)name object:(id)object {
    [self postNotificationName:name object:object userInfo:nil];
}

+ (void)postNotificationName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:userInfo];
}

+ (void)removeObserver:(id)observer{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

+ (void)removeObserver:(id)observer name:(NSString *)name object:(id)object{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:object];
}

@end
