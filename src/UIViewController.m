//
//  UIViewController.m
//  UIKit
//
//  Created by Andrew Pouliot on 2/6/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "UIViewController.h"

#import "UIView.h"
#import "UIView-Private.h"

@implementation UIViewController

- (id)init;
{
	self = [super init];
	if (!self) return nil;
	
	
	
	return self;
}

- (void)dealloc {
	view.viewDelegate = nil;
    [view release];
	
    [super dealloc];
}

- (BOOL)isViewLoaded;
{
	return view != nil;
}

- (void)loadView;
{
	self.view = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (void)viewDidLoad;
{
	//For subclassers
}

- (UIView *)view;
{
	if (![self isViewLoaded]) {
		[self loadView];
		[self viewDidLoad];
	}
	return [[view retain] autorelease];
}

- (void)setView:(UIView *)inView;
{
	if (inView == view)
		return;
	
	view.viewDelegate = nil;
	[view release];
	view = [inView retain];
	view.viewDelegate = self;
	[self setNextResponder:view.superview];
}

@end
