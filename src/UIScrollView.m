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
	[super addSubview:contentView];

	scroller = [[UIScrollKnob alloc] initWithScrollView:self];
	[super addSubview:scroller];
	
	return self;
}

- (void)dealloc {
	[contentView release];
	[scroller release];
	[super dealloc];
}

- (CGRect)scrollerFrame;
{
	CGRect bounds = self.bounds;
	return (CGRect) {
		.origin.x = bounds.size.width - 10.f,
		.origin.y = 5.f,
		.size.height = bounds.size.height - 10.f,
		.size.width = 10.f,
	};
}

- (void)layoutSubviews;
{
	[super layoutSubviews];
	
	CGRect availableFrame = [self scrollerFrame];
	
	CGFloat offset = self.contentOffset.y / self.contentSize.height;
	CGFloat size = self.frame.size.height / self.contentSize.height;
	size = fminf(fmaxf(0.0f, size), 1.0f);
	
	scroller.frame = (CGRect) {
		.origin.x = availableFrame.origin.x,
		.origin.y = availableFrame.origin.y + offset * availableFrame.size.height,
		.size.width = availableFrame.size.width,
		.size.height = size * availableFrame.size.height,
	};
}

- (void)setContentSize:(NSSize)aSize {
	NSRect aRect = self.contentView.frame;
	aRect.size = aSize;
	self.contentView.frame = aRect;
}

- (CGSize)contentSize;
{
	return contentView.bounds.size;
}

- (void)setContentOffset:(NSPoint)aPoint {
	CGRect bounds = contentView.bounds;
	bounds.origin = aPoint;
	contentView.bounds = bounds;
	[self setNeedsLayout];
}

- (NSPoint)contentOffset {
	return contentView.bounds.origin;
}

- (void)addSubview:(UIView*)aView {
	[self.contentView addSubview:aView];
}

- (void)_scrollerScrolled:(UIScrollKnob *)inScrollKnob withEvent:(NSEvent *)inEvent;
{
	//dy is backwards because of coordinate flipping. Do we care?
	CGFloat dy = -[inEvent deltaY];
	
	CGRect scrollerRect = [self scrollerFrame];
	CGPoint contentOffset = self.contentOffset;
	contentOffset.y -= (dy / scrollerRect.size.height) * self.contentSize.height;
	contentOffset.y = fmaxf(0.0f, fminf(contentOffset.y, self.contentSize.height - self.frame.size.height));
	self.contentOffset = contentOffset;
}

@end
