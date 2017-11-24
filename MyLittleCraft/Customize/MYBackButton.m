//
//  MYBackButton.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/24.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYBackButton.h"
#import "UIView+Pin.h"

@implementation MYBackButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self buildInterface];
        [self layoutInterface];
    }
    return self;
}

- (void)buildInterface {
    UIImage *chevron = [UIImage imageNamed:@"Chevron"];
    UIImage *icon = [chevron imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    _imageView = [[UIImageView alloc] initWithImage:icon];
    [self addSubview:_imageView];
    
    _titleLabel = [MYTintLabel new];
    _titleLabel.numberOfLines = 1;
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.tintColor = [UIColor colorWithRed:0 green:122/255.0 blue:1 alpha:1];
    [self addSubview:_titleLabel];
}

- (void)layoutInterface {
    [_imageView pinEdgesWithInsets:(UIEdgeInsets){ 11, 0, 11, INFINITY }];
    
    [_titleLabel alignCenterToEdge:UIRectEdgeLeft constant:19];
    [_titleLabel pinEdgesWithInsets:(UIEdgeInsets){ INFINITY, INFINITY, INFINITY, 8 }];
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    
    self.imageView.tintColor = tintColor;
    self.titleLabel.tintColor = tintColor;
}

@end
