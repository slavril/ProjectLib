
#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

+ (NSString *)currentTimestamp;

#pragma mark - time format

+ (NSDate *)getDateFromString:(NSString *)date timezone:(NSTimeZone *)timezone format:(NSString *)format;
+ (NSDate *)getDateFromString:(NSString *)date timezoneString:(NSString *)timezone format:(NSString *)format;
+ (NSString *)timezoneFromString:(NSString *)dateString;
+ (NSString *)getDateStringFromDate:(NSDate *)date timezone:(NSString *)timezone format:(NSString *)format;
+ (NSDateFormatter *)dateFormatterForTimezoneFromFormatString:(NSString *)formatString;

#pragma mark - timezone

+ (NSMutableArray *)getListTimezone;
+ (NSTimeZone *)getTimezoneWithHour:(NSString *)hour;
+ (NSMutableArray *)getListTimezoneTitle;
+ (NSMutableArray *)getListGMTOffset;
+ (NSMutableArray *)getListHourOffset;

@end
