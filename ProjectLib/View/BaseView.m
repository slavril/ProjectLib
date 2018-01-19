//
//  BaseView.m
//  Zippie
//
//  Created by Manh Nguyen on 5/13/14.
//  Copyright (c) 2014 Lunex Telecom. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

+ (UINib *)baseNib{
    NSString *key = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:key bundle:nil];
    return nib;
}

- (void)dealloc
{
    [_contentView removeFromSuperview];
    _contentView = nil;
}

- (void)addConstraintForContent{
    if (self.contentView) {
        [self addSubview:self.contentView];
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraint:[self constraintToItem:self.contentView attribute:NSLayoutAttributeTop]];
        [self addConstraint:[self constraintToItem:self.contentView attribute:NSLayoutAttributeLeft]];
        [self addConstraint:[self constraintToItem:self.contentView attribute:NSLayoutAttributeBottom]];
        [self addConstraint:[self constraintToItem:self.contentView attribute:NSLayoutAttributeRight]];
    }
}

- (void)setupView {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *key = NSStringFromClass([self class]);
    if ([mainBundle pathForResource:key ofType:@"nib"] != nil) {
        if (self.contentView == nil) {
            UINib *nib = [[self class] baseNib];
            if (nib) {
                self.contentView = [nib instantiateWithOwner:self options:nil].lastObject;
            }
        }
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
        [self addConstraintForContent];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self addConstraintForContent];
    }
    return self;
}

- (instancetype)initWithFrameForPopup:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


- (void)reloadView {
    // TODO on childs
}

- (void)closeKeyboard {
    // TODO on childs
}

- (void)makeEmpty {
    // TODO on childs
}

- (void)loadView {
    // TODO on childs
}

- (void)hideView:(BOOL)isHide {
    // TODO on childs
}

- (NSLayoutConstraint *)constraintToItem:(id)item attribute:(NSLayoutAttribute)attribute {
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:item
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}

@end
