//
//  MYFullScreenPanGestureRecognizer.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/11/17.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "MYFullScreenPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

CGFloat const MYFullScreenInteractiveDistanceDefault = 88;

@implementation MYFullScreenPanGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    self = [super initWithTarget:target action:action];
    if (self) {
        _interactiveDistanceFromEdge = MYFullScreenInteractiveDistanceDefault;
        
        static UILabel *aLabel = nil;
        if (!aLabel) {
            aLabel = [UILabel new];
        }
        
        UIUserInterfaceLayoutDirection direction =
        [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:aLabel.semanticContentAttribute];
        
        switch (direction) {
            case UIUserInterfaceLayoutDirectionLeftToRight: _fromEdge = UIRectEdgeLeft; break;
            case UIUserInterfaceLayoutDirectionRightToLeft: _fromEdge = UIRectEdgeRight; break;
        }
        
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // Only handle the left and right edges
    if (!(_fromEdge == UIRectEdgeLeft || _fromEdge == UIRectEdgeRight))
        return;
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:touch.view];
        CGRect fullRect = touch.view.bounds;
        
        CGRect availableRect = CGRectZero;
        availableRect.size.width = MIN(_interactiveDistanceFromEdge, fullRect.size.width);
        availableRect.size.height = fullRect.size.height;
        
        if (_fromEdge == UIRectEdgeRight) {
            availableRect.origin.x = fullRect.size.width - availableRect.size.width;
        }
        
        if (!CGRectContainsPoint(availableRect, location)) {
            return;
        }
    }
    
    [super touchesBegan:touches withEvent:event];
}

@end
