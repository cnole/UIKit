//
//  UINSWindow.m
//  UIKit
//
//  Created by Andrew Pouliot on 1/28/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "UINSWindow.h"


@implementation UINSWindow

- (id)initWithUIWindow:(UIWindow *)inWindow type:(UINSWindowType)inWindowType;
{
	self = [super initWithContentRect:[inWindow frame]
							styleMask:(NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask) 
							  backing:NSBackingStoreBuffered defer:YES];
	if (!self) return nil;
	
	uiWindow = inWindow;
	
	return self;
}

- (void)sendEvent:(NSEvent *)inEvent;
{
	//TODO: fix me
	[uiWindow sendEvent:inEvent];
	[super sendEvent:inEvent];
}

@end
