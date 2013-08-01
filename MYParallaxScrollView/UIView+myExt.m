//
//  UIView+myExt.h
//  Leonard Pauli
//
//  Created by Leonard Pauli on 2013-04-29.
//  Copyright (c) 2013 Leonard Pauli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h> // For method swizzling and to associate objects
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Crop.h"


static char useCustomPointInsideKey;
static char forwardsTouchesKey;
static char usePointInsideBlockKey;
static char pointInsideBlockKey;



@implementation UIView (myExt)


- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    self.frame = (CGRect){{x, self.y}, self.frame.size};
}


- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    self.frame = (CGRect){{self.x, y}, self.frame.size};
}


- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    self.frame = (CGRect){self.frame.origin, {width, self.height}};
}


- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    self.frame = (CGRect){self.frame.origin, {self.width, height}};
}


- (CGRect)frameWithoutOrigin {
    return CGRectMake(0, 0, self.width, self.height);
}

- (void)frameWithoutOrigin:(CGRect)frame {
	[self setWidth:frame.size.width];
	[self setHeight:frame.size.height];
}







- (UIImage*)captureViewAsImage {
    
	int re = ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
			  ([UIScreen mainScreen].scale == 2.0)) ? 2 : 1;
	
	if ([self isKindOfClass:[UIScrollView class]]) {
		CGSize _contentSize = [(UIScrollView*)self contentSize];
		CGPoint _contentOffset = [(UIScrollView*)self contentOffset];
		//[(UIScrollView*)self setContentOffset:CGPointZero];
		//CGRect _frame = self.frame;
		//self.frame = (CGRect){{0,0},_contentSize};
		
		UIGraphicsBeginImageContextWithOptions(_contentSize, NO, re);
		[self.layer renderInContext:UIGraphicsGetCurrentContext()];
		UIImage *vwImg = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		//self.frame = _frame;
		//[(UIScrollView*)self setContentOffset:_contentOffset];
		
		return [vwImg imageCroppedToRect:(CGRect){_contentOffset, self.frame.size}];
	}
	
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, re);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *vwImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return vwImg;
    
}







- (BOOL)useCustomPointInside {
	return [(NSNumber*)objc_getAssociatedObject(self, &useCustomPointInsideKey) boolValue];
}

- (void)setUseCustomPointInside:(BOOL)doIt {
	objc_setAssociatedObject(self, &useCustomPointInsideKey, 
		[NSNumber numberWithBool:doIt], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)forwardsTouches {
	return [(NSNumber*)objc_getAssociatedObject(self, &forwardsTouchesKey) boolValue];
}

- (void)setForwardsTouches:(BOOL)doIt {
	objc_setAssociatedObject(self, &forwardsTouchesKey, 
							 [NSNumber numberWithBool:doIt], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self setUseCustomPointInside:YES];
}


- (BOOL)usePointInsideBlock {
	return [(NSNumber*)objc_getAssociatedObject(self, &usePointInsideBlockKey) boolValue];
}

- (void)setUsePointInsideBlock:(BOOL)doIt {
	objc_setAssociatedObject(self, &usePointInsideBlockKey, 
							 [NSNumber numberWithBool:doIt], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL (^)(CGPoint point, UIEvent *event))pointInsideBlock {
	return objc_getAssociatedObject(self, &pointInsideBlockKey);
}

- (void)setPointInsideBlock:(BOOL (^)(CGPoint point, UIEvent *event))pointInside {
	objc_setAssociatedObject(self, &pointInsideBlockKey, pointInside, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[self setUseCustomPointInside:YES];
	[self setUsePointInsideBlock:YES];
}








/*BOOL useCustomPointInside = NO;
- (void)setUseCustomPointInside:(BOOL)doIt {
    useCustomPointInside = doIt;
}
- (BOOL)getUseCustomPointInside {
    return useCustomPointInside;
}

BOOL forwardsTouches = YES;
- (void)setForwardsTouches:(BOOL)doIt {
	useCustomPointInside = YES;
    forwardsTouches = doIt;
}

BOOL usePointInsideBlock = NO;
- (void)setUsePointInsideBlock:(BOOL)useIt {
    usePointInsideBlock = useIt;
    useCustomPointInside = useIt;
}

BOOL (^pointInsideBlock)(CGPoint point, UIEvent *event) = ^BOOL(CGPoint point, UIEvent *event) {
	return NO;
};
- (void)setPointInsideBlock:(BOOL (^)(CGPoint point, UIEvent *event))pointInside {
	useCustomPointInside = YES;
    usePointInsideBlock = YES;
    pointInsideBlock = pointInside;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
	
	for (UIView *vw in self.subviews)
        if (!vw.hidden && vw.userInteractionEnabled &&
            [vw pointInside:[self convertPoint:point toView:vw] withEvent:event])
            return YES;
	
	return (usePointInsideBlock?pointInsideBlock(point, event):CGRectContainsPoint(self.bounds, point));
}
*/
- (BOOL)swizzled_pointInside:(CGPoint)point withEvent:(UIEvent*)event {
	
	if (!self.useCustomPointInside)
		return [self swizzled_pointInside:point withEvent:event];
	
	if (self.forwardsTouches) for (UIView *vw in self.subviews)
        if (!vw.hidden && vw.userInteractionEnabled &&
            [vw pointInside:[self convertPoint:point toView:vw] withEvent:event])
            return YES;
	
	return (self.usePointInsideBlock?self.pointInsideBlock(point, event):CGRectContainsPoint(self.bounds, point));
}


+ (void)load {
	
	Method original = class_getInstanceMethod(self, @selector(pointInside:withEvent:));
    Method swizzle = class_getInstanceMethod(self, @selector(swizzled_pointInside:withEvent:));
	
    method_exchangeImplementations(original, swizzle);
	
}





@end
