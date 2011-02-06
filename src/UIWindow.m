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
	
	self.layer.geometryFlipped = YES;

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
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	[self.layer setFrame:(CGRect) {
		.size = [nsWindow frame].size
	}];
	[CATransaction commit];
}

- (void)sendEvent:(NSEvent *)event;
{
	[CATransaction begin];
	[CATransaction setDisableActions:YES];

	//If it's a mouse down event, find the responsible view
	if ([event type] == NSLeftMouseDown) {
		//NSAssert(!trackingView, @"Already tracking a view! How so??");
		CGPoint windowPoint = NSPointToCGPoint([event locationInWindow]);
		windowPoint = [self convertPoint:windowPoint fromView:nil];
		UIView *hitView = [self hitTest:windowPoint withEvent:event];
		self.trackingView = hitView;
		if (hitView) {
			[trackingView mouseDown:event];
		}
	} else if ([event type] == NSLeftMouseUp) {
		if (trackingView) {
			[trackingView mouseUp:event];
		}
		self.trackingView = nil;
	} else if ([event type] == NSLeftMouseDragged) {
		if (trackingView) {
			[trackingView mouseDragged:event];
		}
	}
	[CATransaction commit];

}

- (void)makeKeyAndVisible;
{
	[nsWindow makeKeyAndOrderFront:self];
}

@end
