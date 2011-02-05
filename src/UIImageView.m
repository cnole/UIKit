//
//  UIImageView.m
//  UIKit
//
//  Created by Andrew Pouliot on 1/28/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "UIImageView.h"


@implementation UIImageView

@synthesize image;

- (id)initWithFrame:(CGRect)inFrame;
{
	self = [super initWithFrame:inFrame];
	if (!self) return nil;
	
	self.userInteractionEnabled = NO;
	
	return self;
}

- (void)setImage:(UIImage *)inImage;
{
	[image autorelease];
	image = [inImage retain];
	
	self.layer.contents = (id)[image CGImage];
}

- (void)dealloc
{
	[image release];
	image = nil;

	[super dealloc];
}

@end
