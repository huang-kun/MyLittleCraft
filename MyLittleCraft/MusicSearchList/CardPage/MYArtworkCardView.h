//
//  MYArtworkCardView.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/19.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYArtworkCardView : UIImageView

- (void)setRandomImage;

@end


@protocol MYArtworkCardOwnerable <NSObject>

- (MYArtworkCardView *)artworkCardView;
- (UIView *)view;

@end
