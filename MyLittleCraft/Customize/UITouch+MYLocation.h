//
//  UITouch+MYLocation.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/17.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UITouch.h>

@interface UITouch (MYLocation)

/// Get current location
@property (nonatomic, readonly) CGPoint my_currentLocation;

/// Get previous location
@property (nonatomic, readonly) CGPoint my_previousLocation;


@end
