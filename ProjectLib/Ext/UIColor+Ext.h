
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor(Ext)

+ (UIColor *)colorWith256Red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithR:(int)red G:(int)green B:(int)blue;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorContrastBlackWhiteWithColor:(UIColor *)color;
+ (UIColor *)colorWithHexa:(long)hex;

@end

@interface NSString(UIColorARIS)

+ (NSString *)stringFromColor:(UIColor *)color;

@end
