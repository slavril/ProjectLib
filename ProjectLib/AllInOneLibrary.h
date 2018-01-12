//
//  AllInOneLibrary.h
//  ProjectLib
//
//  Created by Son Dang on 1/12/18.
//  Copyright © 2018 Son Dang. All rights reserved.
//

#import "DateUtils.h"
#import "Util.h"

#ifndef AllInOneLibrary_h
#define AllInOneLibrary_h

#endif /* AllInOneLibrary_h */

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBWithAlpha(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.9];

#define Rgb2UIColor(r, g, b)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define Rgba2UIColor(r, g, b, a)  [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:a]

#define UIColorFromHexa(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// customize colors
#define kGreenColor         [UIColor colorWithRed:22.0/255 green:117.0/255 blue:41.0/255 alpha:1.0]
#define kDarkGreenColor     [UIColor colorWithRed:0.0/255 green:139.0/255 blue:0.0/255 alpha:1.0]
#define kBrightGreenColor   [UIColor colorWithRed:14.0/255 green:207.0/255 blue:120.0/255 alpha:1.0]
#define kDarkCallColor      [UIColor colorWithRed:44.0/255 green:44.0/255 blue:44.0/255 alpha:1.0]
#define kGreenCallColor     [UIColor colorWithRed:1.0/255 green:200.0/255 blue:83.0/255 alpha:1.0]
#define kRedCallColor       [UIColor colorWithRed:244.0/255 green:67.0/255 blue:54.0/255 alpha:1.0]
#define kBlueCallColor      [UIColor colorWithRed:0.0/255 green:140.0/255 blue:235.0/255 alpha:1.0]
#define kDarkTextColor      [UIColor darkTextColor]
#define kLighterGrayColor   [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0]
#define kLightGrayColor     [UIColor colorWithRed:178.0/255 green:178.0/255 blue:178.0/255 alpha:1.0]
#define kDarkGrayColor      [UIColor darkGrayColor]
#define kBlueColor          [UIColor colorWithRed:45.0/255 green:140.0/255 blue:214.0/255 alpha:1.0]
#define kRedFlatUIColor     [UIColor colorWithRed:244.0/255 green:67.0/255 blue:54.0/255 alpha:1.0]
#define kDarkBlueColor      [UIColor colorWithRed:32.0/255 green:89.0/255 blue:131.0/255 alpha:1.0]
#define kLightBlueColor     [UIColor colorWithRed:215.0/255 green:233.0/255 blue:255.0/255 alpha:1.0]
#define kLightGreenColor    [UIColor colorWithRed:79.0/255 green:168.0/255 blue:2.0/255 alpha:1.0]
#define kDarkBrownColor     [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0]
#define kLighterOrangeColor [UIColor colorWithRed:255/255.0 green:241/255.0 blue:224/255.0 alpha:1.0]
#define kLighterYellowColor [UIColor colorWithRed:241.0/255 green:236.0/255 blue:202.0/255 alpha:1.0]
#define kLightYellowColor [UIColor colorWithRed:254.0/255 green:250.0/255 blue:223.0/255 alpha:1.0]
#define kDarkYellowColor [UIColor colorWithRed:203.0/255 green:194.0/255 blue:144.0/255 alpha:1.0]
#define kBlueLineColor [UIColor colorWithRed:170.0/255 green:211.0/255 blue:233.0/255 alpha:1.0]
#define kBlueFacebookColor [UIColor colorWithRed:63.0/255.0 green:87.0/255.0 blue:153.0/255.0 alpha:1.0]
#define kFailColor Rgba2UIColor(245, 67, 55, 1)
#define kSuccessColor Rgba2UIColor(1, 200, 83, 1)
#define kGrayColorContact [UIColor colorWithRed:77.0/255 green:77.0/255 blue:77.0/255 alpha:1.0]

#define kMidGreyTextColor [UIColor colorWithRed:88.0/255.0 green:88.0/255.0 blue:88.0/255.0 alpha:1.0]
#define kLightGreyTextColor [UIColor colorWithRed:141.0/255.0 green:141.0/255.0 blue:141.0/255.0 alpha:1.0]

#define kSSelectContactViewColor    [UIColor colorWithRed:44.0/255 green:188.0/255 blue:156.0/255 alpha:1.0]
#define kSExpressColor              [UIColor colorWithRed:52.0/255 green:72.0/255 blue:94.0/255 alpha:1.0]
#define kSEnterPhoneColor            [UIColor colorWithRed:237.0/255 green:240./255 blue:244.0/255 alpha:1.0]
#define kBackGroundColor  [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0]
#define kTableBackGroundColor  [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1.0]
#define kDarkBlueBackGround [UIColor colorWithRed:0.0/255 green:140.0/255 blue:203.0/255 alpha:1.0]
#define kLightBlueBackGround [UIColor colorWithRed:187.0/255 green:219.0/255 blue:236.0/255 alpha:1.0]
#define kBlueBackGround [UIColor colorWithRed:119.0/255 green:190.0/255 blue:228.0/255 alpha:1.0]

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IOS_8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8 && [[[UIDevice currentDevice] systemVersion] floatValue] < 9)
#define IS_IOS_8_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define IS_IOS_9_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9)
#define IS_IOS_9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9 && [[[UIDevice currentDevice] systemVersion] floatValue] < 10)
#define IS_IOS_10_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10)
#define IS_IOS_11_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11)

#define DATE_FORMAT_DATE                 @"MM/dd/yyyy"
#define DATE_FORMAT_DATETIME             @"MM/dd/yyyy HH:mm:ss"
#define DATE_FORMAT_DATETIME_TIMEZONE    @"MM/dd/yyyy HH:mm:ss Z"
#define DATE_FORMAT_DATETIME_TIMEZONE_STANDARD @"yyyy-MM-dd'T'HH:mm:ssZ"
#define DATE_FORMAT_SHORT_TERM_MM_YYYY @"MMM yyyy"
