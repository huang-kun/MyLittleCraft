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
        self.clipsToBounds = NO;
        
        self.layer.shadowOffset = (CGSize){ 0, 6 };
        self.layer.shadowRadius = 8;
        self.layer.shadowOpacity = 0.2;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    self.layer.shadowRadius = width / 6;
}

- (void)setRandomImage {
    CGSize size = self.bounds.size;
    UIColor *color = [UIColor randomColor];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:kMYArtworkCardCornerRadius];
    
    UIImage *image = [UIImage drawInSize:size context:^(CGContextRef context) {
        [color setFill];
        CGContextAddPath(context, path.CGPath);
        CGContextFillPath(context);
    }];
    
    self.image = image;
}

@end
