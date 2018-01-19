//
//  BaseViewController.m
//  ProjectLib
//
//  Created by Son Dang on 1/19/18.
//  Copyright © 2018 Son Dang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // allow to swipe to back action
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.enablePopGesture = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoadingView{
    [self showLoadingViewWithText:nil];
}

- (void)showLoadingViewWithText:(NSString *)text{}
- (void)showLoadingViewInWindow:(UIView *)view{}
- (void)showLoadingViewWithText:(NSString *)text inWindow:(UIView *)view{}
- (void)hideLoadingView{}

#pragma mark - white overlay view

static NSInteger kOverlayViewTag = 1999;

- (void)addOverlay {
    UIView *overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
    overlayView.backgroundColor = [UIColor whiteColor];
    overlayView.tag = kOverlayViewTag;
    [self.view addSubview:overlayView];
}

- (void)removeOverlay {
    UIView *overlay = [self.view viewWithTag:kOverlayViewTag];
    if (overlay) {
        [overlay removeFromSuperview];
    }
}

@end
