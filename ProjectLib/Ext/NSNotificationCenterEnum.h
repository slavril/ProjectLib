//
//  NSNotificationCenterEnum.h
//  ProjectLib
//
//  Created by Son Dang on 1/19/18.
//  Copyright © 2018 Son Dang. All rights reserved.
//

typedef NS_ENUM(unsigned int, EventType)
{
    kEventType
};

/* Declare channel types */
typedef NS_ENUM(unsigned int, ChannelPipe)
{
    kChannelPipe
};

/* Declare event status */
typedef NS_ENUM(unsigned int, EventStatus)
{
    kEventStatusOk,
    kEventStatusWarning,
    kEventStatusError,
    kEventStatusUnknown
};
