//
//  MYBoxExt.h
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/10.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import <UIKit/UIGeometry.h>
#import <UIKit/UITouch.h>

typedef NS_ENUM(NSInteger, MYTouchArea) {
    MYTouchAreaNone                     = 0,
    
    MYTouchAreaTopEdge                  = 1 << 0,
    MYTouchAreaLeftEdge                 = 1 << 1,
    MYTouchAreaRightEdge                = 1 << 2,
    MYTouchAreaBottomEdge               = 1 << 3,
    
    MYTouchAreaTopLeftCorner            = MYTouchAreaTopEdge | MYTouchAreaLeftEdge,
    MYTouchAreaTopRightCorner           = MYTouchAreaTopEdge | MYTouchAreaRightEdge,
    MYTouchAreaBottomLeftCorner         = MYTouchAreaBottomEdge | MYTouchAreaLeftEdge,
    MYTouchAreaBottomRightCorner        = MYTouchAreaBottomEdge | MYTouchAreaRightEdge,
    
    MYTouchAreaCentralRegion            = 1 << 4,
};

struct MYBox {
    CGRect topEdge;
    CGRect leftEdge;
    CGRect rightEdge;
    CGRect bottomEdge;
    
    CGRect topLeftCorner;
    CGRect topRightCorner;
    CGRect bottomLeftCorner;
    CGRect bottomRightCorner;
    
    CGRect centralRegion;
};

typedef struct MYBox MYBox;

/// Get box touchable component frames.
MYBox my_boxFromFrame(CGRect frame);

/// Get a touch area of the box when you touch it.
MYTouchArea my_touchAreaForBoxFrame(CGRect frame, CGPoint location);

/// Get a new frame of box after touch
CGRect my_updatedBoxFrameFrom(CGRect fromFrame, CGPoint delta, MYTouchArea touchArea);


@interface UITouch (MYTouchTracking)

/// Store MYTouchArea value at touchesBegan state, so it will not change during touchesMoved because MYTouchArea may change depending on box size.
@property (nonatomic, assign) MYTouchArea my_trackingTouchArea;

/// The UITouch object can only work with box when it's active. Because only one touch is allowed to drag box from box's central region. Multiple touches will make conflicts for dragging box's central region.
@property (nonatomic, assign) BOOL my_active;


@end

