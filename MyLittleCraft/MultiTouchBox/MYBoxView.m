//
//  MYBoxView.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/8.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYBoxView.h"
#import "MYBoxExt.h"

@interface MYBoxView ()

@property (nonatomic, strong) CAShapeLayer *borderLayer;

// internal
// ----------------------------------------------------------------
@property (nonatomic, strong) NSMutableArray <UITouch *> *allTouches;
@property (nonatomic, assign) CGRect storedBoxFrame;
@property (nonatomic, assign) BOOL rejectNewTouch;
// ----------------------------------------------------------------

// debug
// ----------------------------------------------------------------
@property (nonatomic, strong) CAShapeLayer *topEdgeLayer;
@property (nonatomic, strong) CAShapeLayer *leftEdgeLayer;
@property (nonatomic, strong) CAShapeLayer *rightEdgeLayer;
@property (nonatomic, strong) CAShapeLayer *bottomEdgeLayer;

@property (nonatomic, strong) CAShapeLayer *topLeftCornerLayer;
@property (nonatomic, strong) CAShapeLayer *topRightCornerLayer;
@property (nonatomic, strong) CAShapeLayer *bottomLeftCornerLayer;
@property (nonatomic, strong) CAShapeLayer *bottomRightCornerLayer;

@property (nonatomic, strong) CAShapeLayer *centralRegionLayer;
// ----------------------------------------------------------------

@end


@implementation MYBoxView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.multipleTouchEnabled = YES;
        self.boxColor = UIColor.grayColor;
        
        _allTouches = [NSMutableArray new];
        
        _borderLayer = [CAShapeLayer layer];
        _borderLayer.strokeColor = self.boxColor.CGColor;
        _borderLayer.fillColor = UIColor.clearColor.CGColor;
        _borderLayer.lineWidth = 2;
        _borderLayer.lineCap = kCALineCapButt;
        _borderLayer.lineJoin = kCALineJoinRound;
        _borderLayer.lineDashPattern = @[ @6, @6 ];
        
        [self.layer addSublayer:_borderLayer];

        _topEdgeLayer = [self debugLayerForTouchArea:MYTouchAreaTopEdge];
        _leftEdgeLayer = [self debugLayerForTouchArea:MYTouchAreaLeftEdge];
        _rightEdgeLayer = [self debugLayerForTouchArea:MYTouchAreaRightEdge];
        _bottomEdgeLayer = [self debugLayerForTouchArea:MYTouchAreaBottomEdge];

        _topLeftCornerLayer = [self debugLayerForTouchArea:MYTouchAreaTopLeftCorner];
        _topRightCornerLayer = [self debugLayerForTouchArea:MYTouchAreaTopRightCorner];
        _bottomLeftCornerLayer = [self debugLayerForTouchArea:MYTouchAreaBottomLeftCorner];
        _bottomRightCornerLayer = [self debugLayerForTouchArea:MYTouchAreaBottomRightCorner];
        
        _centralRegionLayer = [self debugLayerForTouchArea:MYTouchAreaCentralRegion];
        
        self.debug = NO;
    }
    return self;
}

- (void)resetBoxFrame {
    CGRect frame = self.frame;
    _borderLayer.frame = frame;

    _storedBoxFrame.size.width = 100;
    _storedBoxFrame.size.height = 100;
    _storedBoxFrame.origin.x = frame.size.width / 2 - _storedBoxFrame.size.width / 2;
    _storedBoxFrame.origin.y = frame.size.height / 2 - _storedBoxFrame.size.height / 2;
    
    [self updateLayerBlock:^{
        [self updateBoxFrame:_storedBoxFrame];
        [self debugUpdateLayersWithBox:my_boxFromFrame(_storedBoxFrame)];
    }];
}

- (void)setBoxColor:(UIColor *)boxColor {
    _boxColor = boxColor;
    _borderLayer.strokeColor = _boxColor.CGColor;
    
    [self setNeedsDisplay];
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_rejectNewTouch)
        return;
    
    for (UITouch *touch in touches) {
        // Get a new touch
        if (touch.my_trackingTouchArea == MYTouchAreaNone) {
            MYTouchArea touchArea = my_touchAreaForBoxFrame(_storedBoxFrame, touch.my_currentLocation);
            
            // Prepare a new touch
            if (touchArea != MYTouchAreaNone) {
                touch.my_trackingTouchArea = touchArea;
                touch.my_active = YES;
                [_allTouches addObject:touch];
                
                // Reject new touches if this is a central region touch, because two of them can easily make conflicts. Make sure central region touch will take priority and be exclusive.
                if (touchArea == MYTouchAreaCentralRegion) {
                    _rejectNewTouch = YES;
                }
            }
        }
    }
    
    // Disactive exist touches if any new central region touch came.
    if (_rejectNewTouch) {
        for (UITouch *touch in _allTouches) {
            if (touch.my_trackingTouchArea != MYTouchAreaCentralRegion) {
                touch.my_active = NO;
            }
        }
    }
    
    // Reduce double speed if multiple touches on same area.
    [self preventIncrementalTranslation];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch.my_active) {
            CGPoint previousLocation = touch.my_previousLocation;
            CGPoint currentLocation = touch.my_currentLocation;
            
            CGPoint delta;
            delta.x = currentLocation.x - previousLocation.x;
            delta.y = currentLocation.y - previousLocation.y;
            
            _storedBoxFrame = my_updatedBoxFrameFrom(_storedBoxFrame, delta, touch.my_trackingTouchArea);
            
            [self updateLayerBlock:^{
                [self updateBoxFrame:_storedBoxFrame];
                [self debugUpdateLayersWithBox:my_boxFromFrame(_storedBoxFrame)];
            }];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self handleTouchesFinished:touches];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self handleTouchesFinished:touches];
}

- (void)handleTouchesFinished:(NSSet<UITouch *> *)touches {
    for (UITouch *touch in touches) {
        [_allTouches removeObject:touch];
    }
    
    // Check if any exist touch is central region touch. If exist, still reject new touches.
    _rejectNewTouch = NO;
    for (UITouch *touch in _allTouches) {
        if (touch.my_trackingTouchArea == MYTouchAreaCentralRegion) {
            _rejectNewTouch = YES;
            break;
        }
    }
}

#pragma mark - Helper

- (void)updateLayerBlock:(void(^)(void))block {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if (block) {
        block();
    }
    
    [CATransaction commit];
}

#pragma mark - Calculation

/// If two touches change the box simultaneously, for example, one touched on the bottom-left corner and another touched on the bottom-right corner. So the bottom edge is being owning for twice and it will cause the incremental translation on bottom edge (Visually double speed). Call this method to reduce extra speed in touchesBegan after the new touch is added to self.allTouches property.
- (void)preventIncrementalTranslation {
    if (_allTouches.count < 2)
        return;
    
    UITouch *lastTouch = _allTouches.lastObject;
    MYTouchArea lastArea = lastTouch.my_trackingTouchArea;
    
    for (UITouch *touch in _allTouches) {
        if (touch != lastTouch) {
            MYTouchArea area = touch.my_trackingTouchArea;
            
            // Check if previous touch and last touch have owned same area.
            // If does, then get rid of same area from previous touch.
            MYTouchArea onSameArea = area & lastArea;
            if (onSameArea) {
                touch.my_trackingTouchArea = onSameArea ^ area;
            }
        }
    }
}

- (void)updateBoxFrame:(CGRect)frame {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    self.borderLayer.path = path.CGPath;
}

#pragma mark - Debug

- (void)setDebug:(BOOL)debug {
    _debug = debug;
    
    [self updateLayerBlock:^{
        _topEdgeLayer.hidden = !_debug;
        _leftEdgeLayer.hidden = !_debug;
        _rightEdgeLayer.hidden = !_debug;
        _bottomEdgeLayer.hidden = !_debug;
        
        _topLeftCornerLayer.hidden = !_debug;
        _topRightCornerLayer.hidden = !_debug;
        _bottomLeftCornerLayer.hidden = !_debug;
        _bottomRightCornerLayer.hidden = !_debug;
        
        _centralRegionLayer.hidden = !_debug;
    }];
}

- (CAShapeLayer *)debugLayerForTouchArea:(MYTouchArea)touchArea {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    CGColorRef bgColor;
    
    switch (touchArea) {
        case MYTouchAreaTopEdge:
        case MYTouchAreaLeftEdge:
        case MYTouchAreaRightEdge:
        case MYTouchAreaBottomEdge:
            bgColor = UIColor.orangeColor.CGColor;
            break;
        case MYTouchAreaTopLeftCorner:
        case MYTouchAreaTopRightCorner:
        case MYTouchAreaBottomLeftCorner:
        case MYTouchAreaBottomRightCorner:
            bgColor = UIColor.redColor.CGColor;
            break;
        case MYTouchAreaCentralRegion:
            bgColor = UIColor.greenColor.CGColor;
            break;
        default:
            bgColor = UIColor.clearColor.CGColor;
            break;
    }
    
    layer.backgroundColor = bgColor;
    layer.opacity = 0.1;
    [self.layer addSublayer:layer];
    
    return layer;
}

- (void)debugUpdateLayersWithBox:(MYBox)box {
    
    _topEdgeLayer.frame = box.topEdge;
    _leftEdgeLayer.frame = box.leftEdge;
    _rightEdgeLayer.frame = box.rightEdge;
    _bottomEdgeLayer.frame = box.bottomEdge;
    
    _topLeftCornerLayer.frame = box.topLeftCorner;
    _topRightCornerLayer.frame = box.topRightCorner;
    _bottomLeftCornerLayer.frame = box.bottomLeftCorner;
    _bottomRightCornerLayer.frame = box.bottomRightCorner;
    
    _centralRegionLayer.frame = box.centralRegion;
}

@end
