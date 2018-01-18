//
//  NSMutableAttributeString+Ext.h
//  ProjectLib
//
//  Created by Son Dang on 1/17/18.
//  Copyright © 2018 Son Dang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (Ext)

- (void)highlightText:(NSString *)text withColor:(UIColor *)color;
- (void)underlineText:(NSString *)text withColor:(UIColor *)color;
- (void)setFontText:(NSString *)text font:(UIFont *)font;

@end
