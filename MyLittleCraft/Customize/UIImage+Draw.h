//
//  UIImage+Draw.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/19.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Draw)

+ (UIImage *)drawInSize:(CGSize)size context:(void(^)(CGContextRef context))block;

@end
