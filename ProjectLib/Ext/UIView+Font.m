//
//  UIView+Font.m
//  Zippie
//
//  Created by Duc Nguyen on 10/1/14.
//  Copyright (c) 2014 Lunex Telecom. All rights reserved.
//

#import "UIView+Font.h"

@implementation UIView (Font)

- (void)setDefaultFontForTextStyle:(NSString *)style{
    [self setDefaultFontStyle:kFontStyleRegular forTextStyle:style];
}

- (void)setDefaultFontStyle:(FontStyle)fontStyle forTextStyle:(NSString *)textStyle{
    UIFont *font = [UIFont preferredFontForTextStyle:textStyle];
    CGFloat size = font.pointSize;
    UIFont *newFont = [UIFont fontWithName:[UIView getFontNameWithStyle:fontStyle] size:size];
    
    if ([[self class] isSubclassOfClass:[UIButton class]]) {
        ((UIButton *)self).titleLabel.font = newFont;
    }
    else if ([[self class] isSubclassOfClass:[UILabel class]]
             || [[self class] isSubclassOfClass:[UITextField class]]
             || [[self class] isSubclassOfClass:[UITextView class]]) {
        id view = self;
        [view setFont:newFont];
    }
}

+ (UIFont *)fontStyle:(FontStyle)fontStyle forTextStyle:(NSString *)textStyle{
    UIFont *font = [UIFont preferredFontForTextStyle:textStyle];
    CGFloat size = font.pointSize;
    UIFont *newFont = [UIFont fontWithName:[UIView getFontNameWithStyle:fontStyle] size:size];
    return newFont;
}

+ (CGFloat)pointSizeForTextStyle:(NSString *)style{
    UIFont *font = [UIFont preferredFontForTextStyle:style];
    return font.pointSize;
}

- (void)setDefaultFont {
    if ([[self class] isSubclassOfClass:[UIButton class]]) {
        ((UIButton *)self).titleLabel.font = [UIFont fontWithName:[UIView getFontNameWithStyle:kFontStyleRegular] size:((UIButton *)self).titleLabel.font.pointSize];
    } else if ([[self class] isSubclassOfClass:[UILabel class]]) {
        ((UILabel *)self).font = [UIFont fontWithName:[UIView getFontNameWithStyle:kFontStyleRegular] size:((UILabel *)self).font.pointSize];
    } else if ([[self class] isSubclassOfClass:[UITextField class]]) {
        ((UITextField *)self).font = [UIFont fontWithName:[UIView getFontNameWithStyle:kFontStyleRegular] size:((UITextField *)self).font.pointSize];
    } else if ([[self class] isSubclassOfClass:[UITextView class]]) {
        ((UITextView *)self).font = [UIFont fontWithName:[UIView getFontNameWithStyle:kFontStyleRegular] size:((UITextView *)self).font.pointSize];
    }
}

- (void)setDefaultFontWithSize:(float)fontSize {
    if ([[self class] isSubclassOfClass:[UIButton class]]) {
        ((UIButton *)self).titleLabel.font = [UIFont fontWithName:[UIView getFontNameWithStyle:kFontStyleRegular] size:fontSize];
    } else if ([[self class] isSubclassOfClass:[UILabel class]]) {
        ((UILabel *)self).font = [UIFont fontWithName:[UIView getFontNameWithStyle:kFontStyleRegular] size:fontSize];
    } else if ([[self class] isSubclassOfClass:[UITextField class]]) {
        ((UITextField *)self).font = [UIFont fontWithName:[UIView getFontNameWithStyle:kFontStyleRegular] size:fontSize];
    } else if ([[self class] isSubclassOfClass:[UITextView class]]) {
        ((UITextView *)self).font = [UIFont fontWithName:[UIView getFontNameWithStyle:kFontStyleRegular] size:fontSize];
    }
}

- (void)setDefaultFontWithStyle:(FontStyle)style {
    if ([[self class] isSubclassOfClass:[UIButton class]]) {
        ((UIButton *)self).titleLabel.font = [UIFont fontWithName:[UIView getFontNameWithStyle:style] size:((UIButton *)self).titleLabel.font.pointSize];
    } else if ([[self class] isSubclassOfClass:[UILabel class]]) {
        ((UILabel *)self).font = [UIFont fontWithName:[UIView getFontNameWithStyle:style] size:((UILabel *)self).font.pointSize];
    } else if ([[self class] isSubclassOfClass:[UITextField class]]) {
        ((UITextField *)self).font = [UIFont fontWithName:[UIView getFontNameWithStyle:style] size:((UITextField *)self).font.pointSize];
    } else if ([[self class] isSubclassOfClass:[UITextView class]]) {
        ((UITextView *)self).font = [UIFont fontWithName:[UIView getFontNameWithStyle:style] size:((UITextView *)self).font.pointSize];
    }
}

- (void)setDefaultFontWithStyle:(FontStyle)style andFontSize:(float)fontSize {
    if ([[self class] isSubclassOfClass:[UIButton class]]) {
        ((UIButton *)self).titleLabel.font = [UIFont fontWithName:[UIView getFontNameWithStyle:style] size:fontSize];
    } else if ([[self class] isSubclassOfClass:[UILabel class]]) {
        ((UILabel *)self).font = [UIFont fontWithName:[UIView getFontNameWithStyle:style] size:fontSize];
    } else if ([[self class] isSubclassOfClass:[UITextField class]]) {
        ((UITextField *)self).font = [UIFont fontWithName:[UIView getFontNameWithStyle:style] size:fontSize];
    } else if ([[self class] isSubclassOfClass:[UITextView class]]) {
        ((UITextView *)self).font = [UIFont fontWithName:[UIView getFontNameWithStyle:style] size:fontSize];
    }
}

- (UIFont *)getDefaultFontWithStyle:(FontStyle)style {
    if ([[self class] isSubclassOfClass:[UIButton class]]) {
        return [UIFont fontWithName:[UIView getFontNameWithStyle:style] size:((UIButton *)self).titleLabel.font.pointSize];
    } else if ([[self class] isSubclassOfClass:[UILabel class]]) {
        return [UIFont fontWithName:[UIView getFontNameWithStyle:style] size:((UILabel *)self).font.pointSize];
    } else if ([[self class] isSubclassOfClass:[UITextField class]]) {
        return [UIFont fontWithName:[UIView getFontNameWithStyle:style] size:((UITextField *)self).font.pointSize];
    } else if ([[self class] isSubclassOfClass:[UITextView class]]) {
        return [UIFont fontWithName:[UIView getFontNameWithStyle:style] size:((UITextView *)self).font.pointSize];
    }
    return nil;
}

- (void)setCustomFontName:(NSString *)fontName fontStyle:(FontStyle)style andFontSize:(float)fontSize {
    if ([[self class] isSubclassOfClass:[UIButton class]]) {
        ((UIButton *)self).titleLabel.font = [UIFont fontWithName:[UIView getFontName:fontName andStyle:style] size:fontSize];
    } else if ([[self class] isSubclassOfClass:[UILabel class]]) {
        ((UILabel *)self).font = [UIFont fontWithName:[UIView getFontName:fontName andStyle:style] size:fontSize];
    } else if ([[self class] isSubclassOfClass:[UITextField class]]) {
        ((UITextField *)self).font = [UIFont fontWithName:[UIView getFontName:fontName andStyle:style] size:fontSize];
    } else if ([[self class] isSubclassOfClass:[UITextView class]]) {
        ((UITextView *)self).font = [UIFont fontWithName:[UIView getFontName:fontName andStyle:style] size:fontSize];
    }
}

+ (UIFont *)getDefaultFontWithSize:(float)fontSize {
    return [UIFont fontWithName:[self getFontNameWithStyle:kFontStyleRegular] size:fontSize];
}

+ (UIFont *)getDefaultFontWithStyle:(FontStyle)style andFontSize:(float)fontSize {
    UIFont *font = [UIFont fontWithName:[self getFontNameWithStyle:style] size:fontSize];
    if (font == nil) {
        NSString *defaultFontName = [self getFontName:DEFAULT_FONT andStyle:style];
        return [UIFont fontWithName:defaultFontName size:fontSize];
    }
    return font;
}

+ (NSString *)getFontName:(NSString *)fontName andStyle:(FontStyle)style {
    NSArray *fontStyles = DEFAULT_FONT_STYLES;
    NSString *fontStyle = fontStyles[style];
    NSString *fontFamilyName = @"";
    
    if (style != kFontStyleRegular) {
        NSArray *components = [fontName componentsSeparatedByString:@"-"];
        fontFamilyName = [NSString stringWithFormat:@"%@%@", components.firstObject, fontStyle];
    }
    else {
        fontFamilyName = fontName;
    }

    return fontFamilyName;
}

+ (NSString *)getFontNameWithStyle:(FontStyle)style {
    if (IS_IOS_9_LATER) {
        UIFont *systemFont = [UIFont systemFontOfSize:17];
        NSString *fontName = [self getFontName:systemFont.fontName andStyle:style];
        return fontName;
    }
    return [self getFontName:DEFAULT_FONT andStyle:style];
}

+ (float)getFontSizeFromOriginalSize:(float)originalSize {
    if (IS_IPHONE_4 || IS_IPHONE_5) {
        return originalSize;
    }
    else if (IS_IPHONE_6) {
        return originalSize+1;
    }
    else if (IS_IPHONE_6_PLUS) {
        return originalSize+2;
    }
    return originalSize;
}

@end
