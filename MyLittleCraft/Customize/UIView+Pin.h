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

/// Add surrounding constraints from self to superview as you specified.
- (void)pinEdges:(UIRectEdge)edges;

/// Add top, leading, bottom and trailing constraints from self to superview.
- (void)pinAllEdges;

/// Add top, leading, bottom and trailing constraints from self to superview with insets. Use INFINITY for skipping.
/// The insets.left is for leading space and insets.right is for trailing space.
- (void)pinEdgesWithInsets:(UIEdgeInsets)insets;

/// Add centerX and centerY constraints from self to superview.
- (void)pinCenter;

/// Add centerX and centerY constraints from self to superview with offset.
- (void)pinCenterWithOffset:(UIOffset)offset;

/// Add specified edge and center constraints from self to superview.
- (void)alignCenterToEdge:(UIRectEdge)edge constant:(CGFloat)constant;


@end
