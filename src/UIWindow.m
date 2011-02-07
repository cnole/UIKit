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

- (UIView *)hitTestFromEvent:(NSEvent *)inEvent;
{
	CGPoint windowPoint = NSPointToCGPoint([inEvent locationInWindow]);
	windowPoint = [self convertPoint:windowPoint fromView:nil];
	return [self hitTest:windowPoint withEvent:inEvent];

}

- (void)sendEvent:(NSEvent *)inEvent;
{
	//If it's a mouse down event, find the responsible view
	if ([inEvent type] == NSLeftMouseDown) {
		//NSAssert(!trackingView, @"Already tracking a view! How so??");
		self.trackingView = [self hitTestFromEvent:inEvent];
		if (trackingView) {
			[trackingView mouseDown:inEvent];
		}
	} else if ([inEvent type] == NSLeftMouseUp) {
		if (trackingView) {
			[trackingView mouseUp:inEvent];
		}
		self.trackingView = nil;
	} else if ([inEvent type] == NSLeftMouseDragged) {
		if (trackingView) {
			[trackingView mouseDragged:inEvent];
		}
	} else if ([inEvent type] == NSScrollWheel) {
		UIView *scrollView = [self hitTestFromEvent:inEvent];
		[scrollView scrollWheel:inEvent];
	}
}

- (void)makeKeyAndVisible;
{
	[nsWindow makeKeyAndOrderFront:self];
}

@end
