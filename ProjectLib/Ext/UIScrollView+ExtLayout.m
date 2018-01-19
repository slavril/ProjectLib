//
//  UIScrollView+ExtLayout.m
//  ProjectLib
//
//  Created by Son Dang on 1/19/18.
//  Copyright © 2018 Son Dang. All rights reserved.
//

#import "UIScrollView+ExtLayout.h"
#import "Constants.h"
#import "Util.h"

@implementation UIScrollView (ExtLayout)

- (void)scrollViewToRectOriginal:(CGRect)toRect ofView:(UIView *)view {
    [self scrollViewToRectOriginal:toRect ofView:view withKeyboardHeight:kHeightKeyboardIphone animation:YES];
}

- (void)scrollViewToRectOriginal:(CGRect)toRect ofView:(UIView *)view withKeyboardHeight:(float)height animation:(BOOL)animation {
    float y = toRect.origin.y;
    float size = toRect.size.height;
    self.contentInset = UIEdgeInsetsMake(0, 0, height + 10, 0);
    
    BlockWeakSelf weakSelf = self;
    [self performSelectorWithBlock:^{
        if (toRect.origin.y + toRect.size.height + 25 > view.frame.size.height - height) {
            [weakSelf setContentOffset:CGPointMake(0, y + size - view.frame.size.height + height + 25) animated:animation];
        }
    } afterDelay:0.0];
}

- (void)scrollViewToRect:(CGRect)toRect ofView:(UIView *)view {
    self.contentInset = UIEdgeInsetsMake(0, 0, kHeightKeyboardIphone + 10, 0);
    if (toRect.origin.y + toRect.size.height + 60 > view.frame.size.height - kHeightKeyboardIphone) {
        [self setContentOffset:CGPointMake(0,  toRect.origin.y + toRect.size.height - view.frame.size.height + kHeightKeyboardIphone + 60) animated:YES];
    }
}

- (void)resetScroll {    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentInset = UIEdgeInsetsZero;
    }];
}


@end
