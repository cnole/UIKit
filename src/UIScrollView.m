//
//  UIScrollView.m
//  UIKit
//
//  Created by Shaun Harrison on 4/30/09.
//  Copyright 2009 enormego. All rights reserved.
//

#import "UIScrollView.h"
#import "UIColor.h"
#import "UIScrollKnob.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIScrollView
@synthesize contentView;

- (void)setupScrollViewDefaults {
}

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	if (!self) return nil;
	
	contentView = [[UIView alloc] initWithFrame:self.bounds];	
	contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;	

	scroller = [[UIScrollKnob alloc] initWithFrame:CGRectZero];
	scroller.backgroundColor = [UIColor redColor];
	[super addSubview:scroller];

	
	return self;
}

- (void)layoutSubviews;
{
	[super layoutSubviews];
	
	CGRect bounds = self.bounds;
	scroller.frame = (CGRect) {
		.origin.x = bounds.size.width - 10.f,
		.origin.y = 10.f,
		.size.height = bounds.size.height - 20.f,
		.size.width = 10.f,
	};
}

- (void)setContentSize:(NSSize)aSize {
	NSRect aRect = self.contentView.frame;
	aRect.size = aSize;
	self.contentView.frame = aRect;
}

- (NSSize)documentSize {
	return self.contentView.frame.size;	
}

- (CGSize)contentSize;
{
	return contentView.bounds.size;
}

- (void)setContentOffset:(NSPoint)aPoint {
	CGRect bounds = contentView.bounds;
	bounds.origin = aPoint;
	contentView.bounds = bounds;
}

- (NSPoint)contentOffset {
	return contentView.bounds.origin;
}

- (void)addSubview:(UIView*)aView {
	[self.contentView addSubview:aView];
}


- (void)dealloc {
	[contentView release];
	[scroller release];
	[super dealloc];
}

@end
