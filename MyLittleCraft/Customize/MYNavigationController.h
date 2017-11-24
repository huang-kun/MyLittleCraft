//
//  MYNavigationController.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/17.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYFullScreenPanGestureRecognizer.h"

@interface MYNavigationController : UINavigationController

@property (nonatomic, readonly, strong) MYFullScreenPanGestureRecognizer *my_interactivePopGestureRecognizer;

/// Replace default target and action of pop gesture.
- (void)replacePopGestureTarget:(id)target action:(SEL)action;

/// Reset default target and action of pop gesture.
- (void)resetPopGestureDefaultTargetWithAction;

@end
