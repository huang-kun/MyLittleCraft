//
//  MYSearchContainer.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYSearchContainer.h"
#import "MYSearchConsts.h"
#import "MYSearchBar.h"
#import "UIView+Pin.h"

@interface MYSearchContainer()
@end

@implementation MYSearchContainer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildInterface];
    }
    return self;
}

- (void)buildInterface {
    _searchBar = [MYSearchBar new];
    _searchBar.placeholder = @"Hello World";
    [self addSubview:_searchBar];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:20];
    _cancelButton.tintColor = MY_SEARCH_TINT_COLOR;
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancelButton sizeToFit];
    [self addSubview:_cancelButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = kMYSearchBarMargin;
    
    CGRect cancelButtonFrame = _cancelButton.frame;
    cancelButtonFrame.size.height = kMYSearchBarHeight;
    cancelButtonFrame.origin.x = self.bounds.size.width - cancelButtonFrame.size.width - margin;
    cancelButtonFrame.origin.y = self.bounds.size.height - margin - cancelButtonFrame.size.height;
    
    _cancelButton.frame = cancelButtonFrame;
    
    CGRect searchBarFrame;
    searchBarFrame.origin.x = margin;
    searchBarFrame.origin.y = margin * 2;
    searchBarFrame.size.width = self.bounds.size.width - cancelButtonFrame.size.width - margin * 3;
    searchBarFrame.size.height = kMYSearchBarHeight;
    
    _searchBar.frame = searchBarFrame;
}

- (CGSize)intrinsicContentSize {
    return (CGSize){ UIScreen.mainScreen.bounds.size.width, kMYSearchBarHeight + kMYSearchBarMargin * 3 };
}

@end
