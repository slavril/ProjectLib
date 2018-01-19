//
//  NSNotificationCenter+Ext.h
//  Zippie
//
//  Created by Anh Quan on 6/22/15.
//  Copyright (c) 2015 Lunex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NSNotificationCenterEventDelegate <NSObject>

- (void)notificationCenterDidReceiveEventNotification:(NSNotification *)notification;

@end

@interface NSNotificationCenter (NSNotificationCenterEventExt)

+ (void)addObserverForName:(NSString *)name object:(id)object usingBlock:(void (^)(NSNotification *note))block;
+ (void)addObserver:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object;
+ (void)addObserver:(id<NSNotificationCenterEventDelegate>)observer name:(NSString *)name object:(id)object;
- (void)addObserver:(id<NSNotificationCenterEventDelegate>)observer name:(NSString *)name object:(id)object;

+ (void)postNotification:(NSNotification *)notification;
+ (void)postNotificationName:(NSString *)name;
+ (void)postNotificationName:(NSString *)name object:(id)object;
+ (void)postNotificationName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo;

+ (void)removeObserver:(id)observer;
+ (void)removeObserver:(id)observer name:(NSString *)name object:(id)object;

@end
