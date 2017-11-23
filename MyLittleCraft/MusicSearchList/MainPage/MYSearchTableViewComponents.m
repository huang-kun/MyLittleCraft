//
//  MYSearchTableViewComponents.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/16.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYSearchTableViewComponents.h"
#import "MYSearchConsts.h"
#import "UIView+Pin.h"

CGFloat const kMYSearchTableSectionCellHeight = 62;
CGFloat const kMYSearchTableItemCellHeight = 51;


@implementation MYTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end


@implementation MYSearchTableSectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildInterface];
        [self layoutInterface];
    }
    return self;
}

- (void)buildInterface {
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 1;
    _titleLabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_titleLabel];
    
    _cleanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _cleanButton.titleLabel.font = [UIFont systemFontOfSize:17];
    _cleanButton.tintColor = MY_SEARCH_TINT_COLOR;
    _cleanButton.titleEdgeInsets = UIEdgeInsetsZero;
    [_cleanButton setTitle:@"Clean" forState:UIControlStateNormal];
    [_cleanButton addTarget:self action:@selector(handleCleanButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cleanButton];
}

- (void)layoutInterface {
    [_titleLabel pinEdgesWithInsets:(UIEdgeInsets){ INFINITY, 16, 8, INFINITY }];
    [_cleanButton pinEdgesWithInsets:(UIEdgeInsets){ INFINITY, INFINITY, 8, 16 }];
}

- (void)handleCleanButtonTap:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(searchTableSectionCell:didTapCleanButton:)]) {
        [self.delegate searchTableSectionCell:self didTapCleanButton:sender];
    }
}

@end


@implementation MYSearchTableItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildInterface];
        [self layoutInterface];
    }
    return self;
}

- (void)buildInterface {
    _titleLabel = [MYTintLabel new];
    _titleLabel.numberOfLines = 1;
    _titleLabel.font = [UIFont systemFontOfSize:20];
    _titleLabel.tintColor = MY_SEARCH_TINT_COLOR;
    [self.contentView addSubview:_titleLabel];
    
    _bottomSeparator = [UIView new];
    _bottomSeparator.backgroundColor = UIColor.lightGrayColor;
    [self.contentView addSubview:_bottomSeparator];
}

- (void)layoutInterface {
    [_titleLabel alignCenterToEdge:UIRectEdgeLeft constant:16];
    
    CGFloat onePixel = 1 / UIScreen.mainScreen.scale;
    [_bottomSeparator pinSize:(CGSize){ INFINITY, onePixel }];
    [_bottomSeparator pinEdgesWithInsets:(UIEdgeInsets){ INFINITY, 16, 0, 16 }];
}

@end
