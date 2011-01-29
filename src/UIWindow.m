//
//  UIWindow.m
//  UIKit
//
//  Created by Jason C. Martin on 2/10/10.
//  Copyright 2010 New Media Geekz. All rights reserved.
//

#import "UIWindow.h"

#import <UIKit/UIColor.h>
#import <QuartzCore/QuartzCore.h>
#import "UINSWindow.h"

@implementation UIWindow

- (id)initWithFrame:(NSRect)aFrame {
	self = [super initWithFrame:aFrame];
	
	self.backgroundColor = [UIColor whiteColor];
	
	nsWindow = [[UINSWindow alloc] initWithUIWindow:self type:UINSWindowTypeTitled]; 
	
	[nsWindow setDelegate:self];
	[[nsWindow contentView] setLayer:self.layer];
	[[nsWindow contentView] setWantsLayer:YES];

	//cause the nswindow to resize
	[self setFrame:aFrame];
	
	return self;
}

- (void)setFrame:(CGRect)inFrame;
{
	[super setFrame:(CGRect) {
		.size = inFrame.size
	}];
	[nsWindow setFrame:inFrame display:YES animate:YES];
}

- (CGRect)frame;
{
	return NSRectToCGRect([nsWindow contentRectForFrameRect:[nsWindow frame]]);
}

- (void)windowDidResize:(NSNotification *)notification
{
	[super setFrame:(CGRect) {
		.size = [nsWindow frame].size
	}];
}

- (void)sendEvent:(UIEvent *)event;
{
	//If it's a mouse down event, find the responsible view
	if ([event type] == NSLeftMouseDown) {
		UIView *hitView = [self hitTest:NSPointToCGPoint([event locationInWindow]) withEvent:event];
		if (hitView) {
			[hitView mouseDown:event];
		}
	} else if ([event type] == NSLeftMouseUp) {
		UIView *hitView = [self hitTest:NSPointToCGPoint([event locationInWindow]) withEvent:event];
		if (hitView) {
			[hitView mouseUp:event];
		}
	}
	
}

- (void)makeKeyAndVisible;
{
	[nsWindow makeKeyAndOrderFront:self];
}

@end
