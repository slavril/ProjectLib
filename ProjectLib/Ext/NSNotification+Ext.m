//
//  NSNotification+Ext.m
//  Zippie
//
//  Created by Anh Quan on 6/17/15.
//  Copyright (c) 2015 Lunex. All rights reserved.
//

#import "NSNotification+Ext.h"
#import <objc/runtime.h>

@implementation NSNotification (EventExt)

- (void)setEventStatus:(NSNumber *)eventStatus{
    objc_setAssociatedObject(self, @selector(eventStatus), eventStatus, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)eventStatus{
    return objc_getAssociatedObject(self, @selector(eventStatus));
}

- (void)setEventType:(NSNumber *)eventType{
    objc_setAssociatedObject(self, @selector(eventType), eventType, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)eventType{
    return objc_getAssociatedObject(self, @selector(eventType));
}

- (void)setChannel:(NSNumber *)channel{
    objc_setAssociatedObject(self, @selector(channel), channel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)channel{
    return objc_getAssociatedObject(self, @selector(channel));
}

+ (NSNotification *)eventWithType:(EventType)type channel:(ChannelPipe)channel object:(id)object{
    NSNotification *event = [NSNotification notificationWithName:[[self class] stringFromChannelPipe:channel] object:object];
    event.eventType = @(type);
    event.channel = @(channel);
    event.eventStatus = @(kEventStatusOk);
    return event;
}

+ (NSNotification *)eventWithType:(EventType)type channel:(ChannelPipe)channel{
    return [[self class] eventWithType:type channel:channel object:nil];
}

+ (NSString *)stringFromChannelPipe:(ChannelPipe)channel {
    return @"";
}

@end
