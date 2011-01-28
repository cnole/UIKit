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

@implementation UIWindow

- (id)initWithFrame:(NSRect)aFrame {
	self = [super initWithFrame:aFrame];
	
	self.backgroundColor = [UIColor whiteColor];
	
	nsWindow = [[NSWindow alloc] initWithContentRect:aFrame
										 styleMask:(NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask) 
										   backing:NSBackingStoreBuffered defer:YES]; 
	
	[nsWindow setDelegate:self];
	[[nsWindow contentView] setLayer:self.layer];
	[[nsWindow contentView] setWantsLayer:YES];

	//cause the nswindow to resize
	[self setFrame:self.frame];
	
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

- (void)windowDidMove:(NSNotification *)notification;
{

}

- (void)makeKeyAndVisible;
{
	[nsWindow makeKeyAndOrderFront:self];
}

@end
