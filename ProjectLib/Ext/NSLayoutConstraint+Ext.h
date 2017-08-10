
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (Ext)

// Center
+ (NSLayoutConstraint *)centerX:(id)view1 toCenterX:(id)view2;
+ (NSLayoutConstraint *)centerY:(id)view1 toCenterY:(id)view2;
+ (NSLayoutConstraint *)centerY:(id)view1 toCenterY:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
+ (NSLayoutConstraint *)centerX:(id)view1 toCenterX:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant;

// Layout align
+ (NSLayoutConstraint *)top:(id)view1 toTop:(id)view2;
+ (NSLayoutConstraint *)bottom:(id)view1 toBottom:(id)view2;
+ (NSLayoutConstraint *)left:(id)view1 toLeft:(id)view2;
+ (NSLayoutConstraint *)right:(id)view1 toRight:(id)view2;
+ (NSLayoutConstraint *)width:(id)view1 toWidth:(id)view2;
+ (NSLayoutConstraint *)height:(id)view1 toHeight:(id)view2;
+ (NSLayoutConstraint *)top:(id)view1 toTop:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
+ (NSLayoutConstraint *)bottom:(id)view1 toBottom:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
+ (NSLayoutConstraint *)left:(id)view1 toLeft:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
+ (NSLayoutConstraint *)right:(id)view1 toRight:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
+ (NSLayoutConstraint *)width:(id)view1 toWidth:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
+ (NSLayoutConstraint *)height:(id)view1 toHeight:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant;

// Layout fix width/height
+ (NSLayoutConstraint *)height:(id)view1 toConstant:(CGFloat)constant;
+ (NSLayoutConstraint *)width:(id)view1 toConstant:(CGFloat)constant;

// Layout opposite
+ (NSLayoutConstraint *)left:(id)view1 toRight:(id)view2;
+ (NSLayoutConstraint *)right:(id)view1 toLeft:(id)view2;
+ (NSLayoutConstraint *)top:(id)view1 toBottom:(id)view2;
+ (NSLayoutConstraint *)bottom:(id)view1 toTop:(id)view2;
+ (NSLayoutConstraint *)height:(id)view1 toWidth:(id)view2;
+ (NSLayoutConstraint *)width:(id)view1 toHeight:(id)view2;
+ (NSLayoutConstraint *)top:(id)view1 toBottom:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
+ (NSLayoutConstraint *)bottom:(id)view1 toTop:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
+ (NSLayoutConstraint *)left:(id)view1 toRight:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
+ (NSLayoutConstraint *)right:(id)view1 toLeft:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
+ (NSLayoutConstraint *)height:(id)view1 toWidth:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
+ (NSLayoutConstraint *)width:(id)view1 toHeight:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant;

// All edge layout
+ (NSArray *)fullLayout:(id)view1 toView:(id)view2;
+ (NSArray *)fullLayout:(id)view1 toView:(id)view2 padding:(CGFloat)padding;
+ (NSArray *)fullLayout:(id)view1 toView:(id)view2 paddingTop:(CGFloat)padding;
+ (NSArray *)fullLayout:(id)view1 toView:(id)view2 paddingRight:(CGFloat)padding;
+ (NSArray *)fullLayout:(id)view1 toView:(id)view2 paddingBottom:(CGFloat)padding;
+ (NSArray *)fullLayout:(id)view1 toView:(id)view2 paddingLeft:(CGFloat)padding;
+ (NSArray *)fullLayout:(id)view1 toView:(id)view2 paddingLeftRight:(CGFloat)paddingLeftRight;
+ (NSArray *)fullLayout:(id)view1 toView:(id)view2 paddingTopBottom:(CGFloat)paddingTopBottom;

// Center
+ (NSArray *)center:(id)view1 toView:(id)view2 width:(CGFloat)width height:(CGFloat)height;
+ (NSArray *)center:(id)view1 toView:(id)view2 height:(CGFloat)height;
+ (NSArray *)center:(id)view1 toView:(id)view2 width:(CGFloat)width;

// Edge
+ (NSArray *)top:(id)view1 toView:(id)view2 height:(CGFloat)height;
+ (NSArray *)bottom:(id)view1 toView:(id)view2 height:(CGFloat)height;
+ (NSArray *)left:(id)view1 toView:(id)view2 width:(CGFloat)width;
+ (NSArray *)right:(id)view1 toView:(id)view2 width:(CGFloat)width;
+ (NSArray *)top:(id)view1 toView:(id)view2 paddingTop:(CGFloat)paddingTop height:(CGFloat)height;
+ (NSArray *)bottom:(id)view1 toView:(id)view2 paddingBottom:(CGFloat)paddingBottom height:(CGFloat)height;
+ (NSArray *)left:(id)view1 toView:(id)view2 paddingLeft:(CGFloat)paddingLeft width:(CGFloat)width;
+ (NSArray *)right:(id)view1 toView:(id)view2 paddingLRight:(CGFloat)paddingLRight width:(CGFloat)width;

@end

