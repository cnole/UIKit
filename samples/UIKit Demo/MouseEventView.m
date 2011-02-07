//
//  MouseEventView.m
//  RecreatingNSApplication
//
//  Created by Andrew Pouliot on 1/28/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "MouseEventView.h"

@interface MouseEventView ()
- (void)updateState;
@end

@implementation MouseEventView
@synthesize target;
@synthesize action;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (!self) return self; 
	
	self.userInteractionEnabled = YES;
	
	imageView = [[UIImageView alloc] initWithFrame:self.bounds];
	imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self addSubview:imageView];
	
	[self updateState];
	
	return self;
}

- (void)dealloc {
    [imageView release];
    [super dealloc];
}

- (void)updateState;
{
	if (highlighted) {
		imageView.image = [UIImage imageNamed:@"ButtonHighlight.png"];
	} else {
		imageView.image = [UIImage imageNamed:@"ButtonNormal.png"];
	}
}

- (void)mouseDown:(NSEvent *)inEvent;
{
	highlighted = YES;
	[self updateState];
}

- (void)mouseUp:(NSEvent *)inEvent;
{
	highlighted = NO;
	[self updateState];
	if (action) [target performSelector:action];
}

- (void)mouseDragged:(NSEvent *)inEvent;
{
}

@end
