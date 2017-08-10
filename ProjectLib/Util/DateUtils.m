
#import "DateUtils.h"
#import "NSDate+Ext.h"

@implementation DateUtils

+ (NSString *)currentTimestamp {
    NSDate *currentDate = [NSDate date];
    return [NSString stringWithFormat:@"%@", @(currentDate.timeIntervalSince1970)];
}

@end
