//
//  MYSearchHeader.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYSearchHeader.h"
#import "MYSearchBar.h"
#import "UIView+Pin.h"
#import "MYMusicSearchConsts.h"

CGFloat const kMYSearchHeaderHeight = 177;
CGFloat const kMYSearchTitleBottomSpace = 12;

@interface MYSearchHeader()
@property (nonatomic, assign) CGFloat scrollingThreshold;
@property (nonatomic, assign) CGRect storedTitleFrame;
@property (nonatomic, assign) BOOL shouldChangeTitleFrame;
@end

@implementation MYSearchHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self buildInterface];
    }
    return self;
}

- (void)buildInterface {
    _titleLabel = [UILabel new];
    _titleLabel.numberOfLines = 1;
    _titleLabel.text = @"Search";
    _titleLabel.font = [UIFont boldSystemFontOfSize:33];
    [_titleLabel sizeToFit];
    [self addSubview:_titleLabel];
    
    _searchBar = [MYSearchBar new];
    [self addSubview:_searchBar];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = kMYSearchBarMargin;
    
    CGRect searchBarFrame;
    searchBarFrame.size.height = kMYSearchBarHeight;
    searchBarFrame.origin.x = margin;
    searchBarFrame.origin.y = self.bounds.size.height - margin - kMYSearchBarHeight;
    searchBarFrame.size.width = self.bounds.size.width - margin * 2;
    _searchBar.frame = searchBarFrame;
    
    CGRect titleLabelFrame = _titleLabel.frame;
    titleLabelFrame.origin.x = margin;
    titleLabelFrame.origin.y = searchBarFrame.origin.y - margin / 2 - titleLabelFrame.size.height;
    
    // When its superview is applied new transform value,
    // -[UIView layoutSubviews] will be called again.
    // The title frame should not be reset during transform.
    if (!_shouldChangeTitleFrame) {
        _titleLabel.frame = titleLabelFrame;
    }
    
    _storedTitleFrame = titleLabelFrame;
    _scrollingThreshold = searchBarFrame.origin.y - MY_SEARCH_BAR_TOP_INSET;
}

- (void)adjustPositionByContentOffset:(CGPoint)contentOffset {
    
    CGFloat offsetY = contentOffset.y;
    CGFloat threshold = _scrollingThreshold;
    
    // Adjust search bar position to stick on top
    CGRect frame = self.frame;
    
    if (offsetY < threshold) {
        frame.origin.y = -offsetY;
    } else {
        frame.origin.y = -threshold;
    }
    
    if (self.frame.origin.y != frame.origin.y) {
        self.frame = frame;
    }
    
    // Adjust title position to scroll alongside with scrollView
    CGRect titleFrame = _storedTitleFrame;
    CGFloat increment = offsetY - _scrollingThreshold;
    
    if (increment > 0) {
        titleFrame.origin.y -= increment;
        _shouldChangeTitleFrame = YES;
    } else {
        _shouldChangeTitleFrame = NO;
    }

    if (_titleLabel.frame.origin.y != titleFrame.origin.y) {
        _titleLabel.frame = titleFrame;
    }
    
    // Scale title if possible
    if (offsetY < 0) {
        CGFloat scale = 1 + ABS(offsetY / 600);
        
        if (scale < 1) {
            scale = 1;
        }
        if (scale > 1.2) {
            scale = 1.2;
        }
        
        CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
        
        if (!CGAffineTransformEqualToTransform(_titleLabel.transform, transform)) {
            _titleLabel.transform = transform;
        }
    }
}

@end
