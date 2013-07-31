//
//  MYParallaxScrollView.m
//  Leonard Pauli
//
//  Created by Leonard Pauli on 2013-04-28.
//  Copyright (c) 2013 Leonard Pauli. All rights reserved.
//

#import "MYParallaxScrollView.h"
#import "UIView+myExt.h"


@implementation MYParallaxScrollView

@synthesize parallaxDelegate;
@synthesize backgroundImageView, backgroundImage, backgroundImageViewOffset, backgroundImageViewOffsetFactor;
@synthesize pageControl;






- (CGFloat)cwidth {
	return (self.contentSize.width?self.contentSize.width:1);
}

- (CGFloat)cheight {
	return (self.contentSize.height?self.contentSize.height:1);
}


- (int)numberOfPages {
	return self.cwidth/self.width;
}

- (int)currentPageIndex {
	return round(self.contentOffset.x/self.width);
}

- (void)setNumberOfPages:(int)nr {
	if (nr<1) nr = 1;
	self.contentSize = (CGSize){self.width*nr,self.height};
	[self.pageControl setNumberOfPages:nr];
	//[self setBackgroundImage:self.backgroundImage];
}






- (CGFloat)backgroundImageViewWidth {
	
    CGFloat ret = self.cwidth*backgroundImageViewOffsetFactor+2*backgroundImageViewOffset;
	
	return (isnan(ret)?0:ret);
}

- (CGFloat)backgroundImageViewOriginXFromScrollX:(CGFloat)scrollX {
    return -backgroundImageViewOffset*backgroundImageViewOffsetFactor+scrollX-scrollX*backgroundImageViewOffsetFactor;
}

- (CGRect)backgroundImageViewFrame {
    return CGRectMake([self backgroundImageViewOriginXFromScrollX:self.contentOffset.x], 0,
                      self.backgroundImageViewWidth, self.height);
}




- (void)setBackgroundImage:(UIImage *)image {
	if (!image) return;
	
	if (image.size.width < self.width || image.size.height < self.height)
		scaleBackgroundImage = YES;
	
	if (CGSizeEqualToSize(self.frame.size, CGSizeZero)) {
		backgroundImageView.image = backgroundImage;
		return;
	}
	
	backgroundImageView.image = backgroundImage;
    backgroundImageView.frame = self.backgroundImageViewFrame;
	
}





BOOL useWillLayoutSubviewsBlock = NO;
- (void)setUseWillLayoutSubviewsBlock:(BOOL)useIt {
	useWillLayoutSubviewsBlock = useIt;
}

void (^willLayoutSubviewsBlock)(CGPoint offset, MYParallaxScrollView *scrollView);
- (void)setWillLayoutSubviewsBlock:(void (^)(CGPoint offset, MYParallaxScrollView *scrollView))block {
	useWillLayoutSubviewsBlock = YES;
	willLayoutSubviewsBlock = block;
}



- (void)setPagingEnabled:(BOOL)pagingEnabled {
	[super setPagingEnabled:pagingEnabled];
	
	pageControl.hidden = !pagingEnabled;
	self.showsHorizontalScrollIndicator = !pagingEnabled;
	
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
	
	backgroundImageViewOffset = (self.width+1)/2;
    self.contentSize = CGSizeMake(MAX(self.width, self.cwidth), MAX(self.height, self.cheight));
	
	if (backgroundImage)
		[self setBackgroundImage:backgroundImage];
    
}


- (void)setup {

    self.showsVerticalScrollIndicator = NO;
	self.showsHorizontalScrollIndicator = YES;
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = NO;
    
    self.alwaysBounceHorizontal= YES;
    self.delaysContentTouches  = YES;
    self.scrollEnabled         = YES;
    self.scrollsToTop          = YES;
    self.contentSize           = CGSizeMake(self.width, self.height);
	
	pageControl = [[UIPageControl alloc] init];
	pageControl.hidden = YES;
	pageControl.currentPage = 0;
	pageControl.numberOfPages = 1;
	pageControl.hidesForSinglePage = YES;
	
	
	backgroundImageViewOffset = 150;
	backgroundImageViewOffsetFactor = 0.5;
	
	backgroundImageView = [[UIImageView alloc] init];
    [self addSubview:backgroundImageView];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
	self.backgroundImage = nil;
	
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
		[self setFrame:frame];
    }
    return self;
}

- (id)initInView:(UIView*)inView frame:(CGRect)frame backgroundImage:(UIImage*)bgImg {
    self = [super init];
    if (self) {
        [self setup];
		backgroundImage = bgImg;
		[self setFrame:frame];
		[inView addSubview:self];
    }
    return self;
}

- (id)initInView:(UIView*)inView frame:(CGRect)frame willLayoutSubviewsBlock:
	(void (^)(CGPoint offset, MYParallaxScrollView *scrollView))block {
    self = [super init];
    if (self) {
        [self setup];
		[self setWillLayoutSubviewsBlock:block];
		[self setFrame:frame];
		[inView addSubview:self];
    }
    return self;
}









- (void)layoutSubviews {
    
	self.pageControl.numberOfPages = self.numberOfPages;
	self.pageControl.currentPage = self.currentPageIndex;
	
	if (backgroundImage)
		backgroundImageView.frame = self.backgroundImageViewFrame;
	
	if (useWillLayoutSubviewsBlock && willLayoutSubviewsBlock)
		willLayoutSubviewsBlock(self.contentOffset, self);
	
    if ([parallaxDelegate respondsToSelector:@selector(willLayoutSubviewsInScrollView:)])
        [parallaxDelegate willLayoutSubviewsInScrollView:self];
	
    [super layoutSubviews];
}



@end
