//
//  UIView+Pin.m
//  MyLittleCraft
//
//  Created by huangkun on 2017/7/13.
//  Copyright © 2017年 huangkun. All rights reserved.
//

#import "UIView+Pin.h"

@implementation UIView (Pin)

- (void)pinSize:(CGSize)size {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self my_setConstraintForAttribute:NSLayoutAttributeWidth constant:size.width];
    [self my_setConstraintForAttribute:NSLayoutAttributeHeight constant:size.height];
}

- (void)alignCenterToEdge:(UIRectEdge)edge constant:(CGFloat)constant {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    switch (edge) {
        case UIRectEdgeTop:
            [self my_setRelationshipConstraintForAttribute:NSLayoutAttributeTop constant:constant];
            [self my_setRelationshipConstraintForAttribute:NSLayoutAttributeCenterX constant:0];
            break;
        case UIRectEdgeLeft:
            [self my_setRelationshipConstraintForAttribute:NSLayoutAttributeLeading constant:constant];
            [self my_setRelationshipConstraintForAttribute:NSLayoutAttributeCenterY constant:0];
            break;
        case UIRectEdgeBottom:
            [self my_setRelationshipConstraintForAttribute:NSLayoutAttributeBottom constant:constant];
            [self my_setRelationshipConstraintForAttribute:NSLayoutAttributeCenterX constant:0];
            break;
        case UIRectEdgeRight:
            [self my_setRelationshipConstraintForAttribute:NSLayoutAttributeTrailing constant:constant];
            [self my_setRelationshipConstraintForAttribute:NSLayoutAttributeCenterY constant:0];
            break;
        default:
            NSAssert(false, @"[%@] Call %@ with invalid edge parameter %@", self, NSStringFromSelector(_cmd), @(edge));
            break;
    }
}

- (void)pinEdges:(UIRectEdge)edges {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (edges == UIRectEdgeAll) {
        [self pinAllEdges];
        return;
    }
    
    if (edges & UIRectEdgeTop) {
        [self my_setRelationshipConstraintForAttribute:NSLayoutAttributeTop constant:0];
    }
    if (edges & UIRectEdgeLeft) {
        [self my_setRelationshipConstraintForAttribute:NSLayoutAttributeLeading constant:0];
    }
    if (edges & UIRectEdgeBottom) {
        [self my_setRelationshipConstraintForAttribute:NSLayoutAttributeBottom constant:0];
    }
    if (edges & UIRectEdgeRight) {
        [self my_setRelationshipConstraintForAttribute:NSLayoutAttributeTrailing constant:0];
    }
}

- (void)pinAllEdges {
    [self pinEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)pinEdgesWithInsets:(UIEdgeInsets)insets {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self my_setRelationshipConstraintForAttribute:NSLayoutAttributeTop constant:insets.top];
    [self my_setRelationshipConstraintForAttribute:NSLayoutAttributeLeading constant:insets.left];
    [self my_setRelationshipConstraintForAttribute:NSLayoutAttributeBottom constant:-insets.bottom];
    [self my_setRelationshipConstraintForAttribute:NSLayoutAttributeTrailing constant:-insets.right];
}

- (void)pinCenter {
    [self pinCenterWithOffset:UIOffsetZero];
}

- (void)pinCenterWithOffset:(UIOffset)offset {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self my_setRelationshipConstraintForAttribute:NSLayoutAttributeCenterX constant:offset.horizontal];
    [self my_setRelationshipConstraintForAttribute:NSLayoutAttributeCenterY constant:offset.vertical];
}

- (void)my_setConstraintForAttribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant {
    if (isfinite(constant)) {
        if (@available(iOS 9.0, *)) {
            NSLayoutDimension *anchor = [self my_dimensionForAttribute:attribute];
            [anchor constraintEqualToConstant:constant].active = YES;
        } else {
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:nil attribute:attribute multiplier:1 constant:constant];
            [self addConstraint:constraint];
        }
    }
}

- (void)my_setRelationshipConstraintForAttribute:(NSLayoutAttribute)attribute constant:(CGFloat)constant {
    UIView *superview = self.superview;
    NSAssert(superview, @"%@ - Can not pin edges to superview without a superview!", self);
    
    if (isfinite(constant)) {
        if (@available(iOS 9.0, *)) {
            NSLayoutAnchor *anchor1 = [self my_anchorForAttribute:attribute];
            NSLayoutAnchor *anchor2 = [superview my_anchorForAttribute:attribute];
            [anchor1 constraintEqualToAnchor:anchor2 constant:constant].active = YES;
        } else {
            NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:superview attribute:attribute multiplier:1 constant:constant];
            [superview addConstraint:constraint];
        }
    }
}

- (NSLayoutAnchor *)my_anchorForAttribute:(NSLayoutAttribute)attribute {
    switch (attribute) {
        case NSLayoutAttributeTop: return self.topAnchor;
        case NSLayoutAttributeLeft: return self.leftAnchor;
        case NSLayoutAttributeBottom: return self.bottomAnchor;
        case NSLayoutAttributeRight: return self.rightAnchor;
        case NSLayoutAttributeLeading: return self.leadingAnchor;
        case NSLayoutAttributeTrailing: return self.trailingAnchor;
        case NSLayoutAttributeCenterX: return self.centerXAnchor;
        case NSLayoutAttributeCenterY: return self.centerYAnchor;
        case NSLayoutAttributeWidth: return self.widthAnchor;
        case NSLayoutAttributeHeight: return self.heightAnchor;
        default: return nil;
    }
}

- (NSLayoutDimension *)my_dimensionForAttribute:(NSLayoutAttribute)attribute {
    switch (attribute) {
        case NSLayoutAttributeWidth: return self.widthAnchor;
        case NSLayoutAttributeHeight: return self.heightAnchor;
        default: return nil;
    }
}

@end
