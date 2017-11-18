//
//  MYSearchTableViewComponents.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/16.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const kMYSearchTableSectionCellHeight;
UIKIT_EXTERN CGFloat const kMYSearchTableItemCellHeight;


@interface MYTintLabel : UILabel

@end


@interface MYTableViewCell : UITableViewCell

@property (nonatomic, copy) NSIndexPath *currentIndexPath;

@end


#pragma mark - Table Section


@class MYSearchTableSectionCell;

@protocol MYSearchTableSectionCellDelegate <NSObject>
@optional
- (void)searchTableSectionCell:(MYSearchTableSectionCell *)searchTableSectionCell
             didTapCleanButton:(UIButton *)cleanButton;
@end

@interface MYSearchTableSectionCell : MYTableViewCell

@property (nonatomic, readonly, strong) UILabel *titleLabel;
@property (nonatomic, readonly, strong) UIButton *cleanButton;
@property (nonatomic, weak) id <MYSearchTableSectionCellDelegate> delegate;

@end


#pragma mark - Table Cell


@interface MYSearchTableItemCell : MYTableViewCell

@property (nonatomic, readonly, strong) MYTintLabel *titleLabel;
@property (nonatomic, readonly, strong) UIView *bottomSeparator;

@end
