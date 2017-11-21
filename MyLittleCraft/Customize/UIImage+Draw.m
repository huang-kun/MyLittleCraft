//
//  UIImage+Draw.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/19.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "UIImage+Draw.h"
#import <UIKit/UIScreen.h>

@implementation UIImage (Draw)

+ (UIImage *)drawInSize:(CGSize)size context:(void(^)(CGContextRef context))block {
    UIImage *image = nil;
    
    if (@available(iOS 10, *)) {
        UIGraphicsImageRendererFormat *format = nil;
        
        if (@available(iOS 11, *)) {
            format = [UIGraphicsImageRendererFormat preferredFormat];
        } else {
            format = [UIGraphicsImageRendererFormat defaultFormat];
        }
        
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size format:format];
        image = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            if (block) {
                block(rendererContext.CGContext);
            }
        }];
        
    } else {
        UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (block) {
            block(context);
        }
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return image;
}

@end
