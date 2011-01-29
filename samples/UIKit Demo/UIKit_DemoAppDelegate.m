//
//  UIKit_DemoAppDelegate.m
//  UIKit Demo
//
//  Created by Jason C. Martin on 2/13/10.
//  Copyright 2010 New Media Geekz. All rights reserved.
//

#import "UIKit_DemoAppDelegate.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "MouseEventView.h"

@implementation UIKit_DemoAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)app {
	// Insert code here to initialize your application
	
	window = [[UIWindow alloc] initWithFrame:(CGRect) {.size.width = 300.f, .size.height = 400.f}];
	
	[window makeKeyAndVisible];
	
	CGRect bounds = NSRectToCGRect([window frame]);
	
	UIView *subviewA = [[MouseEventView alloc] initWithFrame:(CGRect) {
		.origin.y = bounds.size.height / 2.f,
		.size.width = bounds.size.width / 2.f,
		.size.height = bounds.size.height / 2.f,
	}];
	subviewA.backgroundColor = [UIColor blackColor];
	[subviewA setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin];
	
	UIView *subviewB = [[MouseEventView alloc] initWithFrame:(CGRect) {
		.origin.x = bounds.size.width / 2.f,
		.origin.y = bounds.size.height / 2.f,
		.size.width = bounds.size.width  / 2.f,
		.size.height = bounds.size.height / 2.f,
	}];
	subviewB.backgroundColor = [UIColor redColor];
	[subviewB setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin];
	
	[window addSubview: subviewA];
	[window addSubview: subviewB];
	
	UIView *blurView = [[UIView alloc] initWithFrame:(CGRect) {
		.origin.x = 100,
		.origin.y = 100,
		.size.width = 200,
		.size.height = 200,
	}];
	blurView.layer.borderColor = [UIColor redColor].CGColor;
	
	CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
	[filter setValue:[NSNumber numberWithFloat:20.0f] forKey:@"inputRadius"];
	blurView.layer.masksToBounds = YES;
	blurView.layer.backgroundFilters = [NSArray arrayWithObject:filter];
	blurView.backgroundColor = [UIColor clearColor];
	blurView.layer.opaque = NO;
	[window addSubview:blurView];
}

- (IBAction)setBadge:(id)sender {
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:[sender intValue]];
}

@end
