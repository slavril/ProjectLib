//
//  BaseScrollViewController.h
//  ProjectLib
//
//  Created by Son Dang on 1/19/18.
//  Copyright © 2018 Son Dang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseScrollViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *contentView;

- (void)scrollViewToRectOriginal:(CGRect)toRect;
- (void)scrollViewToRectOriginal:(CGRect)toRect withKeyboardHeight:(float)height animation:(BOOL)animation;
- (void)scrollViewToRect:(CGRect)toRect;

@end
