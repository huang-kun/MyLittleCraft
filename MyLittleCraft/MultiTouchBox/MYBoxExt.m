//
//  MYBoxExt.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/10.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYBoxExt.h"
#import <objc/runtime.h>

MYBox my_boxFromFrame(CGRect frame) {
    CGFloat const offset = 22.0;
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    CGFloat minX = CGRectGetMinX(frame);
    CGFloat maxX = CGRectGetMaxX(frame);
    CGFloat minY = CGRectGetMinY(frame);
    CGFloat maxY = CGRectGetMaxY(frame);
    
    // ------------------
    //   Size category
    // ------------------
    
    BOOL isWidthNarrow = NO, isWidthCompact = NO, isWidthRegular = NO;
    BOOL isHeightNarrow = NO, isHeightCompact = NO, isHeightRegular = NO;
    
    if (width <= offset * 2) {
        isWidthNarrow = YES;
    } else if (width <= offset * 4) {
        isWidthCompact = YES;
    } else {
        isWidthRegular = YES;
    }
    
    if (height <= offset * 2) {
        isHeightNarrow = YES;
    } else if (height <= offset * 4) {
        isHeightCompact = YES;
    } else {
        isHeightRegular = YES;
    }
    
    BOOL extendCorner = (!isWidthNarrow && !isHeightNarrow);
    CGFloat extra = offset;
    
    // ---------
    //  Corners
    // ---------
    
    CGSize cornerSize;
    cornerSize.width = offset * 2;
    cornerSize.height = offset * 2;
    
    // Top left
    CGRect topLeftCorner;
    topLeftCorner.origin.x = minX - cornerSize.width;
    topLeftCorner.origin.y = minY - cornerSize.height;
    topLeftCorner.size = cornerSize;
    
    if (extendCorner) {
        topLeftCorner.size.width += extra;
        topLeftCorner.size.height += extra;
    }
    
    // Top right
    CGRect topRightCorner;
    topRightCorner.origin.x = maxX;
    topRightCorner.origin.y = minY - cornerSize.height;
    topRightCorner.size = cornerSize;
    
    if (extendCorner) {
        topRightCorner.origin.x -= extra;
        topRightCorner.size.width += extra;
        topRightCorner.size.height += extra;
    }
    
    // Bottom left
    CGRect bottomLeftCorner;
    bottomLeftCorner.origin.x = minX - cornerSize.width;
    bottomLeftCorner.origin.y = maxY;
    bottomLeftCorner.size = cornerSize;
    
    if (extendCorner) {
        bottomLeftCorner.origin.y -= extra;
        bottomLeftCorner.size.width += extra;
        bottomLeftCorner.size.height += extra;
    }
    
    // Bottom right
    CGRect bottomRightCorner;
    bottomRightCorner.origin.x = maxX;
    bottomRightCorner.origin.y = maxY;
    bottomRightCorner.size = cornerSize;
    
    if (extendCorner) {
        bottomRightCorner.origin.x -= extra;
        bottomRightCorner.origin.y -= extra;
        bottomRightCorner.size.width += extra;
        bottomRightCorner.size.height += extra;
    }
    
    // ---------
    //   Edges
    // ---------
    
    CGFloat edgeSpace = offset * 2;
    
    // top
    CGRect topEdge;
    topEdge.origin.x = minX;
    topEdge.origin.y = minY - edgeSpace;
    topEdge.size.width = width;
    topEdge.size.height = edgeSpace;
    
    if (isHeightRegular) {
        topEdge.size.height += extra;
    }
    
    // left
    CGRect leftEdge;
    leftEdge.origin.x = minX - edgeSpace;
    leftEdge.origin.y = minY;
    leftEdge.size.width = edgeSpace;
    leftEdge.size.height = height;
    
    if (isWidthRegular) {
        leftEdge.size.width += extra;
    }
    
    // bottom
    CGRect bottomEdge;
    bottomEdge.origin.x = minX;
    bottomEdge.origin.y = maxY;
    bottomEdge.size.width = width;
    bottomEdge.size.height = edgeSpace;
    
    if (isHeightRegular) {
        bottomEdge.origin.y -= extra;
        bottomEdge.size.height += extra;
    }
    
    // right
    CGRect rightEdge;
    rightEdge.origin.x = maxX;
    rightEdge.origin.y = minY;
    rightEdge.size.width = edgeSpace;
    rightEdge.size.height = height;
    
    if (isWidthRegular) {
        rightEdge.origin.x -= extra;
        rightEdge.size.width += extra;
    }
    
    // ---------
    //  Center
    // ---------
    
    CGRect centralRegion;
    centralRegion.origin.x = MIN(CGRectGetMaxX(topLeftCorner), CGRectGetMaxX(leftEdge));
    centralRegion.origin.y = MIN(CGRectGetMaxY(topLeftCorner), CGRectGetMaxY(topEdge));
    centralRegion.size.width = MAX(topRightCorner.origin.x, rightEdge.origin.x) - centralRegion.origin.x;
    centralRegion.size.height = MAX(bottomLeftCorner.origin.y, bottomEdge.origin.y) - centralRegion.origin.y;
    
    return (MYBox) {
        topEdge,
        leftEdge,
        rightEdge,
        bottomEdge,
        
        topLeftCorner,
        topRightCorner,
        bottomLeftCorner,
        bottomRightCorner,
        
        centralRegion
    };
}

MYTouchArea my_touchAreaForBoxFrame(CGRect frame, CGPoint location) {
    MYBox box = my_boxFromFrame(frame);
    
    // When touch areas overlap, make priority as Central > Corners > Edges
    // Exception: If only edges and central region overlap, make Edges > Central
    if (CGRectIntersectsRect(box.centralRegion, box.topEdge) || CGRectIntersectsRect(box.centralRegion, box.leftEdge)) {
        goto my_skipFirstCentralRegionChecking;
    }
    
    // Check central region
    
    if (CGRectContainsPoint(box.centralRegion, location)) {
        return MYTouchAreaCentralRegion;
    }
    
my_skipFirstCentralRegionChecking:
    
    // Check corner regions
    
    if (CGRectContainsPoint(box.topLeftCorner, location)) {
        return MYTouchAreaTopLeftCorner;
    }
    if (CGRectContainsPoint(box.topRightCorner, location)) {
        return MYTouchAreaTopRightCorner;
    }
    if (CGRectContainsPoint(box.bottomLeftCorner, location)) {
        return MYTouchAreaBottomLeftCorner;
    }
    if (CGRectContainsPoint(box.bottomRightCorner, location)) {
        return MYTouchAreaBottomRightCorner;
    }
    
    // Check edge regions
    
    if (CGRectContainsPoint(box.topEdge, location)) {
        return MYTouchAreaTopEdge;
    }
    if (CGRectContainsPoint(box.leftEdge, location)) {
        return MYTouchAreaLeftEdge;
    }
    if (CGRectContainsPoint(box.bottomEdge, location)) {
        return MYTouchAreaBottomEdge;
    }
    if (CGRectContainsPoint(box.rightEdge, location)) {
        return MYTouchAreaRightEdge;
    }
    
    // Check central region again!
    
    if (CGRectContainsPoint(box.centralRegion, location)) {
        return MYTouchAreaCentralRegion;
    }
    
    // No matched region
    
    return MYTouchAreaNone;
};

CGRect my_updatedBoxFrameFrom(CGRect fromFrame, CGPoint delta, MYTouchArea touchArea) {
    CGRect newFrame = fromFrame;
    CGSize minSize = (CGSize){ 22, 22 };
    
    switch (touchArea) {
        case MYTouchAreaNone:
            break;
        case MYTouchAreaTopEdge:
            newFrame.origin.y = fromFrame.origin.y + delta.y;
            newFrame.size.height = fromFrame.size.height - delta.y;
            break;
        case MYTouchAreaLeftEdge:
            newFrame.origin.x = fromFrame.origin.x + delta.x;
            newFrame.size.width = fromFrame.size.width - delta.x;
            break;
        case MYTouchAreaRightEdge:
            newFrame.size.width = fromFrame.size.width + delta.x;
            break;
        case MYTouchAreaBottomEdge:
            newFrame.size.height = fromFrame.size.height + delta.y;
            break;
        case MYTouchAreaTopLeftCorner:
            newFrame.origin.x = fromFrame.origin.x + delta.x;
            newFrame.origin.y = fromFrame.origin.y + delta.y;
            newFrame.size.width = fromFrame.size.width - delta.x;
            newFrame.size.height = fromFrame.size.height - delta.y;
            break;
        case MYTouchAreaTopRightCorner:
            newFrame.origin.y = fromFrame.origin.y + delta.y;
            newFrame.size.width = fromFrame.size.width + delta.x;
            newFrame.size.height = fromFrame.size.height - delta.y;
            break;
        case MYTouchAreaBottomLeftCorner:
            newFrame.origin.x = fromFrame.origin.x + delta.x;
            newFrame.size.width = fromFrame.size.width - delta.x;
            newFrame.size.height = fromFrame.size.height + delta.y;
            break;
        case MYTouchAreaBottomRightCorner:
            newFrame.size.width = fromFrame.size.width + delta.x;
            newFrame.size.height = fromFrame.size.height + delta.y;
            break;
        case MYTouchAreaCentralRegion:
            newFrame.origin.x = fromFrame.origin.x + delta.x;
            newFrame.origin.y = fromFrame.origin.y + delta.y;
            break;
    }
    
    if (newFrame.size.width < minSize.width) {
        newFrame.size.width = minSize.width;
        newFrame.origin = fromFrame.origin;
    }
    if (newFrame.size.height < minSize.height) {
        newFrame.size.height = minSize.height;
        newFrame.origin = fromFrame.origin;
    }
    
    return newFrame;
}


@implementation UITouch (MYTouchTracking)

- (CGPoint)my_currentLocation {
    CGPoint location;
    
    if (@available(iOS 9.1, *)) {
        location = [self preciseLocationInView:self.view];
    } else {
        location = [self locationInView:self.view];
    }
    
    return location;
}

- (CGPoint)my_previousLocation {
    CGPoint location;
    
    if (@available(iOS 9.1, *)) {
        location = [self precisePreviousLocationInView:self.view];
    } else {
        location = [self previousLocationInView:self.view];
    }
    
    return location;
}

- (void)setMy_trackingTouchArea:(MYTouchArea)my_trackingTouchArea {
    objc_setAssociatedObject(self, @selector(my_trackingTouchArea), @(my_trackingTouchArea), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MYTouchArea)my_trackingTouchArea {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setMy_active:(BOOL)my_active {
    objc_setAssociatedObject(self, @selector(my_active), @(my_active), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)my_active {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end

