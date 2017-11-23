//
//  MYMusicBar.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/19.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYMusicBar.h"
#import "UIView+Pin.h"
#import "MYArtworkCardView.h"

static CGFloat const kMYMusicBarHeightStandard = 64;
static CGFloat const kMYMusicBarHeightExtended = 64 + 34;

@interface MYMusicBar()
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@end

@implementation MYMusicBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildInterface];
        [self layoutInterface];
        [self setupTapGesture];
    }
    return self;
}

- (void)buildInterface {
    self.backgroundColor = UIColor.clearColor;
    
    _blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    [self addSubview:_blurView];
    
    _artworkCardView = [MYArtworkCardView new];
    [_blurView.contentView addSubview:_artworkCardView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.numberOfLines = 1;
    [_blurView.contentView addSubview:_titleLabel];
}

- (void)layoutInterface {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    _heightConstraint = [self.heightAnchor constraintEqualToConstant:kMYMusicBarHeightStandard];
    _heightConstraint.active = YES;
    
    [_blurView pinAllEdges];
    
    [_artworkCardView pinSize:(CGSize){ 48, 48 }];
    [_artworkCardView pinEdgesWithInsets:(UIEdgeInsets){ 8, 20, INFINITY, INFINITY }];
    
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_titleLabel.leadingAnchor constraintEqualToAnchor:_artworkCardView.trailingAnchor constant:17].active = YES;
    [_titleLabel.centerYAnchor constraintEqualToAnchor:_artworkCardView.centerYAnchor].active = YES;
}

- (void)extendBarHeight {
    _heightConstraint.constant = kMYMusicBarHeightExtended;
}

- (void)setupTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(musicBarDidTap:)]) {
        [self.delegate musicBarDidTap:self];
    }
}

@end
