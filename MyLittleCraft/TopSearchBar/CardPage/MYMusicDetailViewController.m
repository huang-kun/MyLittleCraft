//
//  MYMusicDetailViewController.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/18.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYMusicDetailViewController.h"
#import "MYArtworkCardView.h"
#import "MYSearchConsts.h"
#import "MYTintLabel.h"
#import "UIView+Pin.h"

static CGFloat const kMYMusicDetailPullDownThreshold = 83;

@interface MYMusicDetailViewController () <UIScrollViewDelegate, MYArtworkCardOwnerable>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MYArtworkCardView *artworkCardView;
@property (nonatomic, strong) MYTintLabel *contentLabel;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@end

@implementation MYMusicDetailViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildInterface];
    [self layoutInterface];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Because view's transform has been modified, when disappearing, the view's transform must reset back to the default value, so no visually jump happened duraing the dismissal transition.
    //
    // 1. Capture the view's frame in window coordinate
    // 2. Reset all changed transform to defaults
    // 3. Adjust view's frame to make it's position identical with the frame before resetting transform

    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    CGRect capturedViewFrame = [window convertRect:self.view.frame fromView:nil];
    
    self.view.transform = CGAffineTransformIdentity;
    _scrollView.transform = CGAffineTransformIdentity;
    
    self.view.frame = capturedViewFrame;
    
    // There is scroll view jump here, reset it's frame can fix this bug, why?
    CGRect scrollViewFrame = _scrollView.frame;
    _scrollView.frame = scrollViewFrame;

    [self.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        // It seems transform animations are not suitable here
    } completion:nil];
}

#pragma mark - init

- (void)buildInterface {
    self.view.backgroundColor = UIColor.whiteColor;
    
    // Later for clipping the transformed subview whoever out of bounds.
    self.view.clipsToBounds = YES;

    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = UIColor.clearColor;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    if (iPhoneX) {
        UIEdgeInsets contentInset = _scrollView.contentInset;
        contentInset.bottom = 34;
        _scrollView.contentInset = contentInset;
    }
    
    [self.view addSubview:_scrollView];
    
    _artworkCardView = [MYArtworkCardView new];
    _artworkCardView.image = _artworkImage;
    [_scrollView addSubview:_artworkCardView];
    
    _contentLabel = [MYTintLabel new];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = [UIFont systemFontOfSize:19];
    _contentLabel.tintColor = MY_SEARCH_TINT_COLOR;
    _contentLabel.text = [self demoContent];
    [_scrollView addSubview:_contentLabel];
}

- (void)layoutInterface {
    CGFloat margin = 57.5;
    CGFloat maxCardWidth = self.view.bounds.size.width - margin * 2;
    if (maxCardWidth > 400) {
        maxCardWidth = 400;
    }
    
    [_scrollView pinAllEdges];
    
    [_artworkCardView pinSize:(CGSize){ maxCardWidth, maxCardWidth }];
    [_artworkCardView alignCenterToEdge:UIRectEdgeTop constant:margin];
    
    _contentLabel.preferredMaxLayoutWidth = maxCardWidth;
    _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentLabel.topAnchor constraintEqualToAnchor:_artworkCardView.bottomAnchor constant:margin].active = YES;
    [_contentLabel.centerXAnchor constraintEqualToAnchor:_scrollView.centerXAnchor].active = YES;
    
    [_contentLabel layoutIfNeeded];
    
    _scrollView.contentSize = (CGSize){
        self.view.bounds.size.width,
        margin + maxCardWidth + margin + _contentLabel.bounds.size.height + margin
    };
    
    UIEdgeInsets contentInset = _scrollView.contentInset;
    contentInset.bottom = kMYMusicDetailPullDownThreshold;
    _scrollView.contentInset = contentInset;
}

- (void)setArtworkImage:(UIImage *)artworkImage {
    _artworkImage = artworkImage;
    _artworkCardView.image = artworkImage;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    if (offset.y < 0) {
        
        // Pull down entire presented view visually
        CGFloat translation = ABS(offset.y);
        self.view.transform = CGAffineTransformMakeTranslation(0, translation);
        scrollView.transform = CGAffineTransformMakeTranslation(0, -translation);
        
        // dismiss self if possible
        if (translation > kMYMusicDetailPullDownThreshold) {
            [self dismiss];
        }
        
    } else {
        if (!CGAffineTransformIsIdentity(self.view.transform)) {
            self.view.transform = CGAffineTransformIdentity;
        }
        if (!CGAffineTransformIsIdentity(scrollView.transform)) {
            scrollView.transform = CGAffineTransformIdentity;
        }
    }
}

#pragma mark -

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)demoContent {
    return @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
}

@end
