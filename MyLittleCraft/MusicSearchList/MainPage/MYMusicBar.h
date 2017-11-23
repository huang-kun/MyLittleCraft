//
//  MYMusicBar.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/19.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYMusicBar, MYArtworkCardView;

@protocol MYMusicBarDelegate <NSObject>
@optional
- (void)musicBarDidTap:(MYMusicBar *)musicBar;
@end


@interface MYMusicBar : UIView

@property (nonatomic, readonly, strong) UILabel *titleLabel;
@property (nonatomic, readonly, strong) MYArtworkCardView *artworkCardView;
@property (nonatomic, readonly, strong) UIVisualEffectView *blurView;

@property (nonatomic, weak) id <MYMusicBarDelegate> delegate;

- (void)extendBarHeight;

@end


@protocol MYMusicBarOwnerable <NSObject>

- (MYMusicBar *)musicBar;
- (UIView *)view;

@end
