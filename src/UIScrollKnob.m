//
//  UIScrollKnob.m
//  UIKit
//
//  Created by Andrew Pouliot on 1/30/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "UIScrollKnob.h"
#import "UIKit.h"
#import "CGRoundRect.h"

@interface UIScrollView (UIScrollKnobPrivate)
- (void)_scrollerScrolled:(UIScrollKnob *)inScrollKnob withEvent:(NSEvent *)inEvent;
@end

@implementation UIScrollKnob

- (id)initWithScrollView:(UIScrollView *)inScrollView;
{
	self = [super initWithFrame:CGRectZero];
	scrollView = inScrollView;
	
	return self;
}
- (void)drawRect:(CGRect)inRect;
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	[[UIColor blueColor] set];
	CGContextBeginPath(ctx);
	CGContextAddRoundRect(ctx, inRect, inRect.size.width / 2.0f);
	CGContextFillPath(ctx);
}


- (void)mouseDragged:(NSEvent *)theEvent;
{
	[scrollView _scrollerScrolled:self withEvent:theEvent];
}

- (void)dealloc {
    // Clean-up code here.
    
    [super dealloc];
}

@end
