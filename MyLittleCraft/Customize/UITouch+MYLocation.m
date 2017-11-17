//
//  UITouch+MYLocation.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/17.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "UITouch+MYLocation.h"

@implementation UITouch (MYLocation)

- (CGPoint)my_currentLocation {
    CGPoint location;
    
    if (@available(iOS 9.1, *)) {
        location = [self preciseLocationInView:self.view];
    } else {
        location = [self locationInView:self.view];
    }
    
    return location;
}

- (CGPoint)my_previousLocation {
    CGPoint location;
    
    if (@available(iOS 9.1, *)) {
        location = [self precisePreviousLocationInView:self.view];
    } else {
        location = [self previousLocationInView:self.view];
    }
    
    return location;
}

@end
