
#import <Foundation/Foundation.h>

#define D_MINUTE 60
#define D_HOUR 3600
#define D_DAY 86400
#define D_WEEK 604800
#define D_YEAR 31556926

@interface NSDate (Ext)

// Relative dates from the current date
+ (NSDate *)dateTomorrow;
+ (NSDate *)dateYesterday;
+ (NSDate *)dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *)dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *)dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *)dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *)dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *)dateWithMinutesBeforeNow: (NSInteger) dMinutes;

+ (NSCalendar *)gregorianCalendar;
+ (NSCalendarUnit)calendarUnitEra;
+ (NSCalendarUnit)calendarUnitYear;
+ (NSCalendarUnit)calendarUnitMonth;
+ (NSCalendarUnit)calendarUnitDay;
+ (NSCalendarUnit)calendarUnitWeekOfMonth;
+ (NSCalendarUnit)calendarUnitHour;
+ (NSCalendarUnit)calendarUnitMinute;
+ (NSCalendarUnit)calendarUnitSecond;
+ (NSCalendarUnit)calendarUnitWeekday;
+ (NSCalendarUnit)calendarUnitWeekdayOrdinal;

// Comparing dates
- (BOOL)isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL)isToday;
- (BOOL)isTomorrow;
- (BOOL)isYesterday;
- (BOOL)isBirthdayToday;
- (BOOL)isBirthdayTomorrow;
- (BOOL)isSameWeekAsDate: (NSDate *) aDate;
- (BOOL)isThisWeek;
- (BOOL)isNextWeek;
- (BOOL)isLastWeek;
- (BOOL)isSameMonthAsDate: (NSDate *) aDate;
- (BOOL)isThisMonth;
- (BOOL)isSameYearAsDate: (NSDate *) aDate;
- (BOOL)isThisYear;
- (BOOL)isNextYear;
- (BOOL)isLastYear;
- (BOOL)isEarlierThanDate: (NSDate *) aDate;
- (BOOL)isLaterThanDate: (NSDate *) aDate;
- (BOOL)isInFuture;
- (BOOL)isInPast;

// Date roles
- (BOOL)isTypicallyWorkday;
- (BOOL)isTypicallyWeekend;

// Adjusting dates
- (NSDate *) dateByAddingMonths: (NSInteger) dMonths;
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateByAddingSeconds: (NSInteger) dSeconds;
- (NSDate *) dateBySubtractingSeconds: (NSInteger) dSeconds;
- (NSDate *) dateAtStartOfDay;

// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;

// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger nthWeekdayARIS; // e.g. 2nd Tuesday of the month == 2 by aris calculate
@property (readonly) NSInteger year;

//// Convert TimeZone
- (NSDate *)toLocalTime;
- (NSDate *)toGlobalTime;

// Detect 24 hour mode on sytem
+ (BOOL)systemIs12hTime;

// Date subtract second : mean second always is zero
- (NSDate *)dateWithZeroSecond;

@end

@interface NSDate (TimeAgo)

- (NSString *) timeAgoSimple;
- (NSString *) timeAgo;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormat:(NSDateFormatterStyle)dFormatter andTimeFormat:(NSDateFormatterStyle)tFormatter;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormatter:(NSDateFormatter *)formatter;
- (NSString *)onlineTimeAgo;

// this method only returns "{value} {unit} ago" strings and no "yesterday"/"last month" strings
- (NSString *)dateTimeAgo;

// this method gives when possible the date compared to the current calendar date: "this morning"/"yesterday"/"last week"/..
// when more precision is needed (= less than 6 hours ago) it returns the same output as dateTimeAgo
- (NSString *)dateTimeUntilNow;

@end

