//
//  UIView+Pin.m
//  MyWebDemo
//
//  Created by huangkun on 2017/7/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "UIView+Pin.h"

@implementation UIView (Pin)

- (void)pinEdgesToSuperview {
    NSAssert(self.superview, @"%@ - Can not pin without having a superview!", self);
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (@available(iOS 9.0, *)) {
        UILayoutGuide *margin = self.superview.layoutMarginsGuide;
        [self.topAnchor constraintEqualToAnchor:margin.topAnchor].active = YES;
        [self.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor].active = YES;
        [self.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor].active = YES;
        [self.bottomAnchor constraintEqualToAnchor:margin.bottomAnchor].active = YES;
    } else {
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        [self.superview addConstraints:@[top, left, bottom, right]];
    }
}

@end
