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
@property (nonatomic, strong) UIStackView *stackView;
@end

@implementation MYSearchContainer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self buildInterface];
        [self layoutInterface];
    }
    return self;
}

- (void)buildInterface {
    _searchBar = [MYSearchBar new];
    _searchBar.placeholder = @"Hello World";
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:20];
    _cancelButton.tintColor = MY_SEARCH_TINT_COLOR;
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    _stackView = [UIStackView new];
    _stackView.axis = UILayoutConstraintAxisHorizontal;
    _stackView.spacing = kMYSearchBarMargin;
    _stackView.alignment = UIStackViewAlignmentCenter;
    
    [_stackView addArrangedSubview:_searchBar];
    [_stackView addArrangedSubview:_cancelButton];
    [self addSubview:_stackView];
}

- (void)layoutInterface {
    [_searchBar pinSize:(CGSize){ INFINITY, kMYSearchBarHeight }];
    
    // Make sure when searchBar stretched, it will not compress cancelButton.
    [_cancelButton setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                   forAxis:UILayoutConstraintAxisHorizontal];
    
    UIEdgeInsets insets;
    insets.top = kMYSearchBarMargin * 2;
    insets.left = kMYSearchBarMargin;
    insets.bottom = kMYSearchBarMargin;
    insets.right = kMYSearchBarMargin;
    
    [_stackView pinEdgesToSuperviewWithInsets:insets];
}

@end
