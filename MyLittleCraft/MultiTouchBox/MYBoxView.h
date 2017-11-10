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

/// Reset box.
- (void)resetBoxFrame;

@end
