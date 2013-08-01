//
//  UIView+myExt.h
//  Leonard Pauli
//
//  Created by Leonard Pauli on 2013-04-29.
//  Copyright (c) 2013 Leonard Pauli. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (myExt)

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGRect)frameWithoutOrigin;
- (void)frameWithoutOrigin:(CGRect)frame;



- (UIImage*)captureViewAsImage;



- (BOOL)useCustomPointInside;
- (void)setUseCustomPointInside:(BOOL)doIt;

- (BOOL)forwardsTouches;
- (void)setForwardsTouches:(BOOL)doIt;

- (BOOL)usePointInsideBlock;

- (BOOL (^)(CGPoint point, UIEvent *event))pointInsideBlock;
- (void)setPointInsideBlock:(BOOL (^)(CGPoint point, UIEvent *event))pointInside;



@end
