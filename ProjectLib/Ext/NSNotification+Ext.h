//
//  NSNotification+Ext.h
//  Zippie
//
//  Created by Anh Quan on 6/17/15.
//  Copyright (c) 2015 Lunex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSNotificationCenterEnum.h"

@interface NSNotification (EventExt)

@property (nonatomic, retain) NSNumber *eventStatus;
@property (nonatomic, retain) NSNumber *eventType;
@property (nonatomic, retain) NSNumber *channel;

+ (NSNotification *)eventWithType:(EventType)type channel:(ChannelPipe)channel object:(id)object;
+ (NSNotification *)eventWithType:(EventType)type channel:(ChannelPipe)channel;

@end
