//
//  MYTitleLabelOwnerable.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/23.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MYTintLabel;

@protocol MYTitleLabelOwnerable <NSObject>

- (MYTintLabel *)titleLabel;
- (UIView *)view;

@end
