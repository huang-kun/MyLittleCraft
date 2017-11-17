//
//  UIView+Pin.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/7/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Pin)

/// Add width and height constraints to self. Use INFINITY for skipping.
- (void)pinSize:(CGSize)size;

/// Add top, leading, bottom and trailing constraints to self with it's superview.
- (void)pinEdgesToSuperview;

/// Add top, leading, bottom and trailing constraints to self with superview. Use INFINITY for skipping.
/// The insets.left is for leading space and insets.right is for trailing space.
- (void)pinEdgesToSuperviewWithInsets:(UIEdgeInsets)insets;

/// Add centerX and centerY constraints to self with superview.
- (void)pinCenterToSuperview;

/// Add specified edge and center constraints to self with superview.
- (void)alignCenterToEdge:(UIRectEdge)edge constant:(CGFloat)constant;


@end
