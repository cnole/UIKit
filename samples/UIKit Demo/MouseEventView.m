//
//  MouseEventView.m
//  RecreatingNSApplication
//
//  Created by Andrew Pouliot on 1/28/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "MouseEventView.h"


@implementation MouseEventView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (!self) return self; 
	
	self.userInteractionEnabled = YES;
	
	return self;
}


- (void)mouseDown:(NSEvent *)inEvent;
{
	self.backgroundColor = [UIColor blueColor];
}

- (void)mouseUp:(NSEvent *)inEvent;
{
	self.backgroundColor = [UIColor greenColor];
}

- (void)mouseDragged:(NSEvent *)inEvent;
{
}

@end
