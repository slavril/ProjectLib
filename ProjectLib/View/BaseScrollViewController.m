//
//  BaseScrollViewController.m
//  ProjectLib
//
//  Created by Son Dang on 1/19/18.
//  Copyright © 2018 Son Dang. All rights reserved.
//

#import "BaseScrollViewController.h"
#import "AllInOneLibrary.h"

@interface BaseScrollViewController ()

@property (nonatomic, assign) BOOL isShowKeyboard;
@property (nonatomic, assign) CGSize currenSizeScrollView;
@property (nonatomic, assign) CGPoint originalScrollOffset;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation BaseScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.originalScrollOffset = self.scrollView.contentOffset;
    self.tapGesture.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:self.tapGesture];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.currenSizeScrollView = self.scrollView.contentSize;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleScrollTouched:)];
    }
    return _tapGesture;
}

- (void)setCancelsTouchesInView:(BOOL)isCancelsTouches {
    self.tapGesture.cancelsTouchesInView = isCancelsTouches;
}

- (void)handleScrollTouched:(id)gesture {
    BlockWeakSelf weakSelf = self;
    [self performSelectorWithBlock:^{
        [weakSelf.view endEditing:YES];
        weakSelf.isShowKeyboard = NO;
        [weakSelf.scrollView resetScroll];
        [weakSelf.view layoutIfNeeded];
    } afterDelay:0.0];
}

#pragma mark - scroll handle

- (void)scrollViewToRectOriginal:(CGRect)toRect {
    [self.scrollView scrollViewToRectOriginal:toRect ofView:self.contentView];
}

- (void)scrollViewToRectOriginal:(CGRect)toRect withKeyboardHeight:(float)height animation:(BOOL)animation{
    [self.scrollView scrollViewToRectOriginal:toRect ofView:self.contentView withKeyboardHeight:height animation:animation];
}

- (void)scrollViewToRect:(CGRect)toRect {
    [self.scrollView scrollViewToRect:toRect ofView:self.contentView];
}

@end
