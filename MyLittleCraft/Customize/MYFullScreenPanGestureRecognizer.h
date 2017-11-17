//
//  MYFullScreenPanGestureRecognizer.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/17.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const MYFullScreenInteractiveDistanceDefault;


@interface MYFullScreenPanGestureRecognizer : UIPanGestureRecognizer

/// Which screen edge will response this pan gesture. Only left and right is available. Default is left.
@property (nonatomic, assign) UIRectEdge fromEdge;

/// The extended touchable distance from edge to inside of screen.
@property (nonatomic, assign) CGFloat interactiveDistanceFromEdge;


@end
