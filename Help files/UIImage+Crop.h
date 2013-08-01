//
//  UIImage+Crop.h
//
//  Created by Leonard Pauli 2013
//  Copyright (c) 2013 Leonard Pauli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Crop) 

- (UIImage *)imageCroppedToRect:(CGRect)rect;
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;

@end

