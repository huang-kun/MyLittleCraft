//
//  UIColor+Random.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/19.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)

+ (UIColor *)randomColor {
    
    uint32_t red = arc4random_uniform(255);
    uint32_t green = arc4random_uniform(255);
    uint32_t blue = arc4random_uniform(255);
    
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
}

@end
