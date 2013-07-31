//
//  MYParallaxScrollView.h
//  Leonard Pauli
//
//  Created by Leonard Pauli on 2013-04-28.
//  Copyright (c) 2013 Leonard Pauli. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol MYParallaxScrollViewDelegate;


@interface MYParallaxScrollView : UIScrollView {

    id <MYParallaxScrollViewDelegate> parallaxDelegate;
	
	UIImageView *backgroundImageView;
	UIImage *backgroundImage;
	BOOL scaleBackgroundImage;
	int backgroundImageViewOffset;
	CGFloat backgroundImageViewOffsetFactor;
	
	
	UIPageControl *pageControl;
	
    
}

@property (retain) id parallaxDelegate;

@property (nonatomic, readonly) UIImageView *backgroundImageView;
@property (nonatomic) UIImage *backgroundImage;
@property (nonatomic) int backgroundImageViewOffset;
@property (nonatomic) CGFloat backgroundImageViewOffsetFactor;

@property (nonatomic, readonly) UIPageControl *pageControl;


- (CGFloat)cwidth;
- (CGFloat)cheight;

- (int)numberOfPages;
- (int)currentPageIndex;
- (void)setNumberOfPages:(int)nr;

- (CGFloat)backgroundImageViewWidth;
- (CGFloat)backgroundImageViewOriginXFromScrollX:(CGFloat)scrollX;
- (CGRect)backgroundImageViewFrame;

- (void)setUseWillLayoutSubviewsBlock:(BOOL)useIt;
- (void)setWillLayoutSubviewsBlock:(void (^)(CGPoint offset, MYParallaxScrollView *scrollView))block;

- (id)initInView:(UIView*)inView frame:(CGRect)frame backgroundImage:(UIImage*)bgImg;
- (id)initInView:(UIView*)inView frame:(CGRect)frame willLayoutSubviewsBlock:
	(void (^)(CGPoint offset, MYParallaxScrollView *scrollView))block;


@end




@protocol MYParallaxScrollViewDelegate <NSObject>
@optional

- (void)willLayoutSubviewsInScrollView:(MYParallaxScrollView*)scrollView;

@end
