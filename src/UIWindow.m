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

@interface UIWindow ()
@property (nonatomic, retain) UIView *trackingView;
@end


@implementation UIWindow

@synthesize trackingView;

- (void)dealloc
{
	[trackingView release];
	trackingView = nil;

	[super dealloc];
}

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
		//NSAssert(!trackingView, @"Already tracking a view! How so??");
		UIView *hitView = [self hitTest:NSPointToCGPoint([event locationInWindow]) withEvent:event];
		if (hitView) {
			self.trackingView = hitView;
			[trackingView mouseDown:event];
		}
	} else if ([event type] == NSLeftMouseUp) {
		if (trackingView) {
			[trackingView mouseUp:event];
			self.trackingView = nil;
		}
	} else if ([event type] == NSMouseMoved) {
		if (trackingView) {
			[trackingView mouseDragged:event];
		}
	}
	
}

- (void)makeKeyAndVisible;
{
	[nsWindow makeKeyAndOrderFront:self];
}

@end
