//
//  MYCameraPreviewLayer.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/11.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYCameraPreviewLayer.h"
#import <UIKit/UIBezierPath.h>
#import <UIKit/UIColor.h>

@interface MYCameraPreviewLayer()
@end

@implementation MYCameraPreviewLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.strokeColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:1].CGColor;
        self.lineWidth = 5;
        self.fillColor = nil;
        [self animate];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self drawCorners];
    [self setNeedsDisplay];
}

- (void)drawCorners {
    
    CGFloat (^my_radiansInDegrees)(CGFloat) = ^CGFloat(CGFloat degrees){
        return degrees * M_PI / 180;
    };
    
    CGRect boxRect = CGRectInset(self.bounds, 10, 10);
    CGFloat radius = 6;
    CGFloat length = MIN(boxRect.size.width, boxRect.size.height) / 6 - radius;

    CGFloat minX = CGRectGetMinX(boxRect);
    CGFloat minY = CGRectGetMinY(boxRect);
    CGFloat maxX = CGRectGetMaxX(boxRect);
    CGFloat maxY = CGRectGetMaxY(boxRect);
    
    CGPoint topLeftCenter = CGPointMake(minX + radius, minY + radius);
    CGPoint topRightCenter = CGPointMake(maxX - radius, minY + radius);
    CGPoint bottomLeftCenter = CGPointMake(minX + radius, maxY - radius);
    CGPoint bottomRightCenter = CGPointMake(maxX - radius, maxY - radius);
    
    // top left corner
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:(CGPoint){ minX, minY + radius + length }];
    [path addLineToPoint:(CGPoint){ minX, minY + radius }];
    [path addArcWithCenter:topLeftCenter
                    radius:radius
                startAngle:my_radiansInDegrees(180.0f)
                  endAngle:my_radiansInDegrees(270.0f)
                 clockwise:YES];
    [path moveToPoint:(CGPoint){ minX + radius, minY }];
    [path addLineToPoint:(CGPoint){ minX + radius + length, minY }];
    
    // top right corner
    [path moveToPoint:(CGPoint){ maxX - radius - length, minY }];
    [path addLineToPoint:(CGPoint){ maxX - radius, minY }];
    [path addArcWithCenter:topRightCenter
                    radius:radius
                startAngle:my_radiansInDegrees(270.0f)
                  endAngle:my_radiansInDegrees(360.0f)
                 clockwise:YES];
    [path moveToPoint:(CGPoint){ maxX, minY + radius }];
    [path addLineToPoint:(CGPoint){ maxX, minY + radius + length }];
    
    // bottom right corner
    [path moveToPoint:(CGPoint){ maxX, maxY - radius - length }];
    [path addLineToPoint:(CGPoint){ maxX, maxY - radius }];
    [path addArcWithCenter:bottomRightCenter
                    radius:radius
                startAngle:my_radiansInDegrees(0.0f)
                  endAngle:my_radiansInDegrees(90.0f)
                 clockwise:YES];
    [path moveToPoint:(CGPoint){ maxX - radius, maxY }];
    [path addLineToPoint:(CGPoint){ maxX - radius - length, maxY }];
    
    // bottom left corner
    [path moveToPoint:(CGPoint){ minX + radius + length, maxY }];
    [path addLineToPoint:(CGPoint){ minX + radius, maxY }];
    [path addArcWithCenter:bottomLeftCenter
                    radius:radius
                startAngle:my_radiansInDegrees(90.0f)
                  endAngle:my_radiansInDegrees(180.0f)
                 clockwise:YES];
    [path moveToPoint:(CGPoint){ minX, maxY - radius }];
    [path addLineToPoint:(CGPoint){ minX, maxY - radius - length }];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    self.path = path.CGPath;
    
    [CATransaction commit];
}

- (void)animate {
    [self removeAllAnimations];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = @1.0;
    scale.toValue = @0.9;
    scale.duration = 0.5;
    scale.beginTime = 0.0;
    scale.autoreverses = YES;
    scale.repeatCount = MAXFLOAT;
    
    [self addAnimation:scale forKey:@"MYCameraPreviewLayerAnimation"];
}

@end
