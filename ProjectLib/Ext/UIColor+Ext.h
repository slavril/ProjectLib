
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor(Ext)

+ (UIColor *)colorWith256Red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+ (UIColor *)colorFromString:(NSString *)string;
+ (UIColor *)colorWithRedInt:(int)red greenInt:(int)green blueInt:(int)blue;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)getContrastBlackWhiteWithColor:(UIColor *)color;

@end


@interface NSString(UIColorARIS)

+ (NSString *)stringFromColor:(UIColor *)color;

@end
