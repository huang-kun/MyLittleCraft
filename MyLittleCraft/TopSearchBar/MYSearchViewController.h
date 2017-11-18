//
//  MYSearchViewController.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSearchBar.h"

@class MYSearchContainer;

@interface MYSearchViewController : UIViewController <MYSearchBarOwnerable>

@property (nonatomic, readonly, strong) MYSearchContainer *searchContainer;
@property (nonatomic, readonly, strong) UILabel *tipLabel;

@end
