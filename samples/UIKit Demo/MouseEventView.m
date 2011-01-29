//
//  MouseEventView.m
//  RecreatingNSApplication
//
//  Created by Andrew Pouliot on 1/28/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "MouseEventView.h"


@implementation MouseEventView

- (void)mouseDown:(UIEvent *)inEvent;
{
	self.backgroundColor = [UIColor blueColor];
}

- (void)mouseUp:(UIEvent *)inEvent;
{
	self.backgroundColor = [UIColor greenColor];
}

- (void)mouseDragged:(UIEvent *)inEvent;
{
	//TODO: blah
	CGPoint dragToPoint;
}

@end
