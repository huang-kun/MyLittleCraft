//
//  MYSearchContainer.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYSearchBar;

@interface MYSearchContainer : UIView

@property (nonatomic, readonly, strong) MYSearchBar *searchBar;
@property (nonatomic, readonly, strong) UIButton *cancelButton;

@end
