//
//  MYArtworkCardView.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/19.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYArtworkCardView.h"
#import "UIColor+Random.h"
#import "UIImage+Draw.h"

static CGFloat const kMYArtworkCardCornerRadius = 4;

@implementation MYArtworkCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.layer.cornerRadius = kMYArtworkCardCornerRadius;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setRandomImage {
    CGSize size = self.bounds.size;
    UIColor *color = [UIColor randomColor];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    
    UIImage *image = [UIImage drawInSize:size context:^(CGContextRef context) {
        [color setFill];
        CGContextAddPath(context, path.CGPath);
        CGContextFillPath(context);
    }];
    
    self.image = image;
}

@end
