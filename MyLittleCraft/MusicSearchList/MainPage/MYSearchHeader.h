//
//  MYSearchHeader.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const kMYSearchHeaderHeight;

@class MYSearchBar;

@interface MYSearchHeader : UIView

@property (nonatomic, readonly, strong) MYSearchBar *searchBar;
@property (nonatomic, readonly, strong) UILabel *titleLabel;

- (void)adjustPositionByContentOffset:(CGPoint)contentOffset;

@end
