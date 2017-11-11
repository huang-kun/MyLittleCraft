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

    UILayoutGuide *margin = self.superview.layoutMarginsGuide;
    [self.topAnchor constraintEqualToAnchor:margin.topAnchor].active = YES;
    [self.leadingAnchor constraintEqualToAnchor:margin.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:margin.trailingAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:margin.bottomAnchor].active = YES;
}

@end
