//
//  MYBoxView.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/8.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYBoxView : UIView

/// Set debug mode. Default is NO.
@property (nonatomic, assign) BOOL debug;

/// The color of box's border
@property (nonatomic, strong) UIColor *boxColor;

/// Reset box.
- (void)resetBoxFrame;

@end
