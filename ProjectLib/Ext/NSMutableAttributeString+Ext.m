//
//  NSMutableAttributeString+Ext.m
//  ProjectLib
//
//  Created by Son Dang on 1/17/18.
//  Copyright © 2018 Son Dang. All rights reserved.
//

#import "NSMutableAttributeString+Ext.h"

@implementation NSMutableAttributedString (Ext)

- (void)addAttribute:(NSDictionary *)dict text:(NSString *)text {
    if (!text.length)
        return;
    
    NSRange range = [self.string rangeOfString:text];
    if (range.location != NSNotFound) {
        [self addAttributes:dict range:range];
    }
}

- (void)highlightText:(NSString *)text withColor:(UIColor *)color {
    [self addAttribute:@{NSForegroundColorAttributeName:color} text:text];
}

- (void)underlineText:(NSString *)text withColor:(UIColor *)color {
    [self addAttribute:@{NSUnderlineStyleAttributeName:@(1)} text:text];
    [self addAttribute:@{NSUnderlineColorAttributeName:color} text:text];
}

- (void)setFontText:(NSString *)text font:(UIFont *)font {
    [self addAttribute:@{NSFontAttributeName:font} text:text];
}

@end
