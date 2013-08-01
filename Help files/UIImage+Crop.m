//
//  UIImage+Crop.h
//
//  Created by Leonard Pauli 2013
//  Copyright (c) 2013 Leonard Pauli. All rights reserved.
//

#import <Foundation/Foundation.h>


@implementation UIImage (Crop) 

- (UIImage *)imageCroppedToRect:(CGRect)rect {
    if (self.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * self.scale,
                          rect.origin.y * self.scale,
                          rect.size.width * self.scale,
                          rect.size.height * self.scale);
    }
	
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}


- (UIImage *)imageWithCornerRadius:(CGFloat)radius {
	if (radius==0) return self;
	
	CGFloat w = self.size.width;
	CGFloat h = self.size.height;
	CGRect rect = CGRectMake(0,0,w,h);
	
	UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGMutablePathRef path = CGPathCreateMutable();
	//addRoundedRectToPath(path, rect, radius, YES);
	//void addRoundedRectToPath(CGMutablePathRef path, CGRect rect, CGFloat radius, BOOL close) {
	//addRoundedRectToPathLong(path, rect, radius, radius, radius, radius, close);}
	//void addRoundedRectToPathLong(CGMutablePathRef path, CGRect rect, CGFloat tL, CGFloat tR, CGFloat bR, CGFloat bL, BOOL close) {
	CGFloat tL, tR, bR, bL;
	tL = tR = bR = bL = radius;
	BOOL close = YES;
	
		CGFloat x = rect.origin.x, y = rect.origin.y;
		//CGFloat w = rect.size.width,h= rect.size.height;
		
		if (close) CGPathMoveToPoint(path, NULL, x+0, y+h/2);
		if (!close) CGPathAddLineToPoint(path, NULL, x+0, y+h/2);
		
		CGPathAddArcToPoint(path, NULL, x+0, y+h, x+w/2, y+h+0, tL);
		CGPathAddArcToPoint(path, NULL, x+w, y+h, x+w+0, y+h/2, tR);
		CGPathAddArcToPoint(path, NULL, x+w, y+0, x+w/2, y+000, bR);
		CGPathAddArcToPoint(path, NULL, x+0, y+0, x+000, y+h/2, bL);
		if (close) CGPathCloseSubpath(path);
		
	//}
	
	
	
	CGContextAddPath(context, path);
	CGContextClip(context);
	
	[self drawInRect:rect];
	
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
	
}



@end

