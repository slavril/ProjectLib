//
//  BaseView.h
//  Zippie
//
//  Created by Manh Nguyen on 5/13/14.
//  Copyright (c) 2014 Lunex Telecom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "UIView+ExtLayout.h"

@interface BaseView : UIView

@property (nonatomic, weak) IBOutlet UIView *contentView;

+ (UINib *)baseNib;

- (void)setupView;
- (void)loadView;
- (void)reloadView;
- (void)closeKeyboard;
- (void)makeEmpty;
- (void)hideView:(BOOL)isHide;
- (instancetype)initWithFrameForPopup:(CGRect)frame;

@end
