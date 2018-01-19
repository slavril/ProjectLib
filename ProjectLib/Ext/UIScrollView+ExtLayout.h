//
//  UIScrollView+ExtLayout.h
//  ProjectLib
//
//  Created by Son Dang on 1/19/18.
//  Copyright © 2018 Son Dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ExtLayout)

- (void)scrollViewToRectOriginal:(CGRect)toRect ofView:(UIView *)view;
- (void)scrollViewToRectOriginal:(CGRect)toRect ofView:(UIView *)view withKeyboardHeight:(float)height animation:(BOOL)animation;
- (void)scrollViewToRect:(CGRect)toRect ofView:(UIView *)view;
- (void)resetScroll;

@end
