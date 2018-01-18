//
//  UIView+Font.h
//  Zippie
//
//  Created by Duc Nguyen on 10/1/14.
//  Copyright (c) 2014 Lunex Telecom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

#define DEFAULT_FONT            @"HelveticaNeue"
#define DEFAULT_FONT_STYLES     @[@"-Bold", @"-BoldItalic", @"-Medium", @"-MediumItalic", @"-Regular", @"-Light", @"-LightItalic", @"-Heavy", @"-HeavyItalic", @"-Italic", @"-Semibold", @"-SemiboldItalic"]

typedef NS_ENUM(NSInteger, FontStyle) {
    kFontStyleBold              =   0,
    kFontStyleBoldItalic        =   1,
    kFontStyleMedium            =   2,
    kFontStyleMediumItalic      =   3,
    kFontStyleRegular           =   4,
    kFontStyleLight             =   5,
    kFontStyleLightItalic       =   6,
    kFontStyleHeavy             =   7,
    kFontStyleHeavyItalic       =   8,
    kFontStyleItalic            =   9,
    kFontStyleSemibold          =   10,
    kFontStyleSemiboldItalic    =   11
};

@interface UIView (Font)

/*
UIFontTextStyleHeadline     The font used for headings.
UIFontTextStyleSubheadline  The font used for subheads.
UIFontTextStyleBody         The font used for body text.
UIFontTextStyleFootnote     The font used for footnotes.
UIFontTextStyleCaption1     The font used for standard captions.
UIFontTextStyleCaption2     The font used for alternate captions.
 
Support only iOS 9.x:
 
UIFontTextStyleTitle1
UIFontTextStyleTitle2
UIFontTextStyleTitle3
UIFontTextStyleCallout
 
*/
- (void)setDefaultFontForTextStyle:(NSString *)style;
- (void)setDefaultFontStyle:(FontStyle)fontStyle forTextStyle:(NSString *)textStyle;
+ (UIFont *)fontStyle:(FontStyle)fontStyle forTextStyle:(NSString *)textStyle;
+ (CGFloat)pointSizeForTextStyle:(NSString *)style;

- (void)setDefaultFont;
- (void)setDefaultFontWithSize:(float)fontSize;
- (void)setDefaultFontWithStyle:(FontStyle)style;
- (void)setDefaultFontWithStyle:(FontStyle)style andFontSize:(float)fontSize;
- (UIFont *)getDefaultFontWithStyle:(FontStyle)style;

+ (UIFont *)getDefaultFontWithSize:(float)fontSize;
+ (UIFont *)getDefaultFontWithStyle:(FontStyle)style andFontSize:(float)fontSize;
+ (NSString *)getFontNameWithStyle:(FontStyle)style;
+ (float)getFontSizeFromOriginalSize:(float)originalSize;

- (void)setCustomFontName:(NSString *)fontName fontStyle:(FontStyle)style andFontSize:(float)fontSize;

@end
