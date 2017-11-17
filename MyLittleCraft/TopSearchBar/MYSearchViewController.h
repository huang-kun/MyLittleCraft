//
//  MYSearchViewController.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYSearchContainer;

@interface MYSearchViewController : UIViewController

@property (nonatomic, readonly, strong) MYSearchContainer *searchContainer;
@property (nonatomic, readonly, strong) UILabel *tipLabel;

@end
