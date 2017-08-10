
#import "NSLayoutConstraint+Ext.h"

@implementation NSLayoutConstraint (Ext)

// MARK: Center
+ (NSLayoutConstraint *)centerX:(id)view1 toCenterX:(id)view2{
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
}

+ (NSLayoutConstraint *)centerX:(id)view1 toCenterX:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeCenterX multiplier:multiplier constant:constant];
}

+ (NSLayoutConstraint *)centerY:(id)view1 toCenterY:(id)view2{
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
}

+ (NSLayoutConstraint *)centerY:(id)view1 toCenterY:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeCenterY multiplier:multiplier constant:constant];
}

// MARK: Layout align
+ (NSLayoutConstraint *)top:(id)view1 toTop:(id)view2{
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
}

+ (NSLayoutConstraint *)bottom:(id)view1 toBottom:(id)view2 {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
}

+ (NSLayoutConstraint *)left:(id)view1 toLeft:(id)view2 {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
}

+ (NSLayoutConstraint *)right:(id)view1 toRight:(id)view2 {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
}

+ (NSLayoutConstraint *)height:(id)view1 toHeight:(id)view2 {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
}

+ (NSLayoutConstraint *)height:(id)view1 toWidth:(id)view2 {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
}

+ (NSLayoutConstraint *)top:(id)view1 toTop:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeTop multiplier:multiplier constant:constant];
}

+ (NSLayoutConstraint *)bottom:(id)view1 toBottom:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeBottom multiplier:multiplier constant:constant];
}

+ (NSLayoutConstraint *)left:(id)view1 toLeft:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeLeft multiplier:multiplier constant:constant];
}

+ (NSLayoutConstraint *)right:(id)view1 toRight:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeRight multiplier:multiplier constant:constant];
}

// MARK: Layout fix width/height
+ (NSLayoutConstraint *)height:(id)view1 toConstant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:constant];
}

+ (NSLayoutConstraint *)width:(id)view1 toConstant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:constant];
}

// MARK: Layout opposite

+ (NSLayoutConstraint *)left:(id)view1 toRight:(id)view2 {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
}

+ (NSLayoutConstraint *)right:(id)view1 toLeft:(id)view2 {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
}

+ (NSLayoutConstraint *)top:(id)view1 toBottom:(id)view2{
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
}

+ (NSLayoutConstraint *)bottom:(id)view1 toTop:(id)view2 {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
}

+ (NSLayoutConstraint *)width:(id)view1 toWidth:(id)view2 {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
}

+ (NSLayoutConstraint *)width:(id)view1 toHeight:(id)view2 {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
}

+ (NSLayoutConstraint *)top:(id)view1 toBottom:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeBottom multiplier:multiplier constant:constant];
}

+ (NSLayoutConstraint *)bottom:(id)view1 toTop:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeTop multiplier:multiplier constant:constant];
}

+ (NSLayoutConstraint *)left:(id)view1 toRight:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeRight multiplier:multiplier constant:constant];
}

+ (NSLayoutConstraint *)right:(id)view1 toLeft:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeLeft multiplier:multiplier constant:constant];
}

+ (NSLayoutConstraint *)width:(id)view1 toWidth:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeWidth multiplier:multiplier constant:constant];
}

+ (NSLayoutConstraint *)width:(id)view1 toHeight:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeHeight multiplier:multiplier constant:constant];
}

+ (NSLayoutConstraint *)height:(id)view1 toHeight:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeHeight multiplier:multiplier constant:constant];
}

+ (NSLayoutConstraint *)height:(id)view1 toWidth:(id)view2 multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view2 attribute:NSLayoutAttributeWidth multiplier:multiplier constant:constant];
}


// MARK: Full layout
// Full layout
+ (NSArray *)fullLayout:(id)view1 toView:(id)view2 {
    return [self fullLayout:view1 toView:view2 padding:0];
}

// Full padding
+ (NSArray *)fullLayout:(id)view1 toView:(id)view2 padding:(CGFloat)padding {
    return @[[NSLayoutConstraint top:view1 toTop:view2 multiplier:1.0 constant:padding],
             [NSLayoutConstraint left:view1 toLeft:view2 multiplier:1.0 constant:padding],
             [NSLayoutConstraint bottom:view1 toBottom:view2 multiplier:1.0 constant:padding],
             [NSLayoutConstraint right:view1 toRight:view2 multiplier:1.0 constant:padding]];
}

+ (NSArray *)fullLayout:(id)view1 toView:(id)view2 paddingTop:(CGFloat)padding {
    return @[[NSLayoutConstraint top:view1 toTop:view2 multiplier:1.0 constant:padding],
             [NSLayoutConstraint left:view1 toLeft:view2],
             [NSLayoutConstraint bottom:view1 toBottom:view2],
             [NSLayoutConstraint right:view1 toRight:view2]];
}

+ (NSArray *)fullLayout:(id)view1 toView:(id)view2 paddingRight:(CGFloat)padding {
    return @[[NSLayoutConstraint right:view1 toRight:view2 multiplier:1.0 constant:padding],
             [NSLayoutConstraint left:view1 toLeft:view2],
             [NSLayoutConstraint bottom:view1 toBottom:view2],
             [NSLayoutConstraint top:view1 toTop:view2]];
}

+ (NSArray *)fullLayout:(id)view1 toView:(id)view2 paddingBottom:(CGFloat)padding {
    return @[[NSLayoutConstraint bottom:view1 toBottom:view2 multiplier:1.0 constant:padding],
             [NSLayoutConstraint left:view1 toLeft:view2],
             [NSLayoutConstraint right:view1 toLeft:view2],
             [NSLayoutConstraint top:view1 toTop:view2]];
}

+ (NSArray *)fullLayout:(id)view1 toView:(id)view2 paddingLeft:(CGFloat)padding {
    return @[[NSLayoutConstraint left:view1 toLeft:view2 multiplier:1.0 constant:padding],
             [NSLayoutConstraint right:view1 toLeft:view2],
             [NSLayoutConstraint bottom:view1 toBottom:view2],
             [NSLayoutConstraint top:view1 toTop:view2]];
}

+ (NSArray *)fullLayout:(id)view1 toView:(id)view2 paddingLeftRight:(CGFloat)paddingLeftRight {
    return @[[NSLayoutConstraint left:view1 toLeft:view2 multiplier:1.0 constant:paddingLeftRight],
             [NSLayoutConstraint right:view1 toLeft:view2 multiplier:1.0f constant:paddingLeftRight],
             [NSLayoutConstraint bottom:view1 toBottom:view2],
             [NSLayoutConstraint top:view1 toTop:view2]];
}

+ (NSArray *)fullLayout:(id)view1 toView:(id)view2 paddingTopBottom:(CGFloat)paddingTopBottom {
    return @[[NSLayoutConstraint left:view1 toLeft:view2],
             [NSLayoutConstraint right:view1 toLeft:view2],
             [NSLayoutConstraint bottom:view1 toBottom:view2 multiplier:1.0f constant:paddingTopBottom],
             [NSLayoutConstraint top:view1 toTop:view2 multiplier:1.0f constant:paddingTopBottom]];
}

// MARK: Center
// Center, fix width and height
+ (NSArray *)center:(id)view1 toView:(id)view2 width:(CGFloat)width height:(CGFloat)height {
    return @[[NSLayoutConstraint centerX:view1 toCenterX:view2],
             [NSLayoutConstraint centerY:view1 toCenterY:view2],
             [NSLayoutConstraint height:view1 toConstant:height],
             [NSLayoutConstraint width:view1 toConstant:width]];
}

// Fix height, center y
+ (NSArray *)center:(id)view1 toView:(id)view2 height:(CGFloat)height {
    return @[[NSLayoutConstraint centerY:view1 toCenterY:view2],
             [NSLayoutConstraint height:view1 toConstant:height],
             [NSLayoutConstraint left:view1 toLeft:view2],
             [NSLayoutConstraint right:view1 toLeft:view2]];
}

// Fix width, center x
+ (NSArray *)center:(id)view1 toView:(id)view2 width:(CGFloat)width {
    return @[[NSLayoutConstraint centerX:view1 toCenterX:view2],
             [NSLayoutConstraint width:view1 toConstant:width],
             [NSLayoutConstraint top:view1 toTop:view2],
             [NSLayoutConstraint bottom:view1 toBottom:view2]];
}

// MARK: Fix width, height
// Top fix height
+ (NSArray *)top:(id)view1 toView:(id)view2 height:(CGFloat)height {
    return [NSLayoutConstraint top:view1 toView:view2 paddingTop:0 height:height];
}

+ (NSArray *)top:(id)view1 toView:(id)view2 paddingTop:(CGFloat)paddingTop height:(CGFloat)height {
    return @[[NSLayoutConstraint left:view1 toLeft:view2],
             [NSLayoutConstraint right:view1 toLeft:view2],
             [NSLayoutConstraint top:view1 toTop:view2 multiplier:1.0f constant:paddingTop],
             [NSLayoutConstraint height:view1 toConstant:height]];
}

// Bottom fix height
+ (NSArray *)bottom:(id)view1 toView:(id)view2 height:(CGFloat)height {
    return [NSLayoutConstraint bottom:view1 toView:view2 paddingBottom:0 height:height];
}

+ (NSArray *)bottom:(id)view1 toView:(id)view2 paddingBottom:(CGFloat)paddingBottom height:(CGFloat)height {
    return @[[NSLayoutConstraint left:view1 toLeft:view2],
             [NSLayoutConstraint right:view1 toLeft:view2],
             [NSLayoutConstraint bottom:view1 toBottom:view2 multiplier:1.0f constant:paddingBottom],
             [NSLayoutConstraint height:view1 toConstant:height]];
}

// Left fix width
+ (NSArray *)left:(id)view1 toView:(id)view2 width:(CGFloat)width {
    return [NSLayoutConstraint left:view1 toView:view2 paddingLeft:0 width:width];
}

+ (NSArray *)left:(id)view1 toView:(id)view2 paddingLeft:(CGFloat)paddingLeft width:(CGFloat)width {
    return @[[NSLayoutConstraint left:view1 toLeft:view2 multiplier:1.0f constant:paddingLeft],
             [NSLayoutConstraint right:view1 toRight:view2],
             [NSLayoutConstraint bottom:view1 toBottom:view2],
             [NSLayoutConstraint width:view1 toConstant:width]];
}


// Right fix width
+ (NSArray *)right:(id)view1 toView:(id)view2 width:(CGFloat)width {
    return [NSLayoutConstraint right:view1 toView:view2 paddingLRight:0 width:width];
}

+ (NSArray *)right:(id)view1 toView:(id)view2 paddingLRight:(CGFloat)paddingLRight width:(CGFloat)width {
    return @[[NSLayoutConstraint right:view1 toRight:view2 multiplier:1.0f constant:paddingLRight],
             [NSLayoutConstraint left:view1 toLeft:view2],
             [NSLayoutConstraint bottom:view1 toBottom:view2],
             [NSLayoutConstraint width:view1 toConstant:width]];
}

@end
