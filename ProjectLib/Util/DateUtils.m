
#import "DateUtils.h"
#import "NSDate+Ext.h"

@implementation DateUtils

static NSMutableArray *listTimezone = nil;
static NSMutableArray *listTimezoneTitle = nil;
static NSMutableArray *listTimezoneHour = nil;
static NSMutableArray *gmtOffset = nil;
static NSDateFormatter *tzFormatter = nil;

+ (NSString *)currentTimestamp {
    NSDate *currentDate = [NSDate date];
    return [NSString stringWithFormat:@"%@", @(currentDate.timeIntervalSince1970)];
}

#pragma mark - timeformat

+ (NSDate *)getDateFromString:(NSString *)date timezone:(NSTimeZone *)timezone format:(NSString *)format {
    NSDateFormatter *dateFormater = [DateUtils dateFormatterForTimezoneFromFormatString:format];
    [dateFormater setTimeZone:timezone];
    
    return [dateFormater dateFromString:date];
}

+ (NSDate *)getDateFromString:(NSString *)date timezoneString:(NSString *)timezone  format:(NSString *)format {
    NSTimeZone *destinationTimezone = [DateUtils getTimezoneWithHour:timezone];
    
    return [[self class] getDateFromString:date timezone:destinationTimezone format:format];
}

+ (NSString *)timezoneFromString:(NSString *)dateString {
    //format server standard
    if (dateString.length) {
        return [dateString substringWithRange:NSMakeRange(dateString.length-5, 5)];
    }
    
    return nil;
}

+ (NSString *)getDateStringFromDate:(NSDate *)date timezone:(NSString *)timezone format:(NSString *)format {
    NSDateFormatter *formatter = [self dateFormatterForTimezoneFromFormatString:format];
    [formatter setTimeZone:[DateUtils getTimezoneWithHour:timezone]];
    
    return [formatter stringFromDate:date];
}

+ (NSDateFormatter *)formatterForSpecifyTimezone {
    if (tzFormatter == nil) {
        tzFormatter = [[NSDateFormatter alloc] init];
    }
    
    return tzFormatter;
}

+ (NSDateFormatter *)dateFormatterForTimezoneFromFormatString:(NSString *)formatString {
    NSDateFormatter *formatter = [DateUtils formatterForSpecifyTimezone];
    formatter.dateFormat = formatString;
    
    return formatter;
}

#pragma mark - timezone

+ (NSMutableArray *)getListTimezone {
    if (!listTimezone.count) {
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        NSDate *myDate = [NSDate date];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
        [dateFormatter setDateFormat:@"ZZZ"];
        listTimezone = [NSMutableArray new];
        listTimezoneTitle = [NSMutableArray new];
        listTimezoneHour = [NSMutableArray new];
        gmtOffset = [NSMutableArray new];
        [[NSTimeZone knownTimeZoneNames] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:obj];
            [dateFormatter setTimeZone:timeZone];
            NSString *dateString = [dateFormatter stringFromDate: myDate];
            NSString *strResult = [NSString stringWithFormat:@"(%@) %@",[DateUtils timezoneFormat:timeZone],obj];
            
            [listTimezone addObject:timeZone];
            [listTimezoneTitle addObject:strResult];
            [listTimezoneHour addObject:dateString];
            [gmtOffset addObject:@(timeZone.secondsFromGMT)];
        }];
    }
    return listTimezone;
}

+ (NSString *)timezoneFormat:(NSTimeZone *)timezone {
    NSDate *myDate = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeZone:timezone];
    [dateFormatter setDateFormat:@"ZZZZ"];
    NSString *dateString = [dateFormatter stringFromDate: myDate];
    return dateString;
}

+ (NSMutableArray *)getListGMTOffset {
    if ([[self class] getListTimezone].count) {
        return gmtOffset;
    }
    return nil;
}

+ (NSMutableArray *)getListHourOffset {
    if ([[self class] getListTimezone].count) {
        return listTimezoneHour;
    }
    return nil;
}

+ (NSMutableArray *)getListTimezoneTitle {
    if ([[self class] getListTimezone].count) {
        return listTimezoneTitle;
    }
    return nil;
}

+ (NSTimeZone *)getTimezoneWithHour:(NSString *)hour {
    if ([[self class] getListTimezone].count) {
        NSInteger index = [listTimezoneHour indexOfObject:hour];
        if (index < listTimezone.count) {
            return listTimezone[index];
        }
    }
    return [NSTimeZone systemTimeZone];
}

@end
