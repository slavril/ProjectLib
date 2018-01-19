//
//  BaseViewController.h
//  ProjectLib
//
//  Created by Son Dang on 1/19/18.
//  Copyright © 2018 Son Dang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, assign) BOOL enablePopGesture; // default is YES, allow to swipe to back action

- (void)showLoadingView;
- (void)showLoadingViewWithText:(NSString *)text;
- (void)showLoadingViewInWindow:(UIView *)view;
- (void)showLoadingViewWithText:(NSString *)text inWindow:(UIView *)view;
- (void)hideLoadingView;

@end
