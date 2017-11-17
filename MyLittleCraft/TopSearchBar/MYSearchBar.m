//
//  MYSearchBar.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYSearchBar.h"

CGFloat const kMYSearchBarHeight = 44;
CGFloat const kMYSearchBarMargin = 16;

@implementation MYSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat c1 = 113 / 255.0;
        CGFloat c2 = 241 / 255.0;
        
        // Magnifying Class Icon
        UIImage *searchIcon = [UIImage imageNamed:@"search"];
        UIImage *renderedIcon = [searchIcon imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *searchIconView = [[UIImageView alloc] initWithImage:renderedIcon];
        searchIconView.tintColor = [UIColor colorWithRed:c1 green:c1 blue:c1 alpha:1];
        
        self.backgroundColor = [UIColor colorWithRed:c2 green:c2 blue:c2 alpha:1];
        self.font = [UIFont systemFontOfSize:22.0];
        self.layer.cornerRadius = 6;
        self.clipsToBounds = YES;
        self.leftView = searchIconView;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.keyboardType = UIKeyboardTypeWebSearch;
    }
    return self;
}

@end
