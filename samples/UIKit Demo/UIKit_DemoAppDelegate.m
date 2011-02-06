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

#import "TweetListViewController.h"

#import "MouseEventView.h"

@implementation UIKit_DemoAppDelegate

- (void)addSuperfluousBlurLayer;
{
	UIView *blurView = [[UIView alloc] initWithFrame:CGRectInset(window.bounds, 10, 10)];
	blurView.layer.borderColor = [UIColor redColor].CGColor;
	
	CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
	[filter setValue:[NSNumber numberWithFloat:20.0f] forKey:@"inputRadius"];
	blurView.layer.masksToBounds = YES;
	blurView.layer.backgroundFilters = [NSArray arrayWithObject:filter];
	blurView.backgroundColor = [UIColor clearColor];
	blurView.layer.opaque = NO;
	[window addSubview:blurView];	
}

- (void)applicationDidFinishLaunching:(UIApplication *)app {
	// Insert code here to initialize your application
	
	window = [[UIWindow alloc] initWithFrame:(CGRect) {.size.width = 300.f, .size.height = 400.f}];
	
	[window makeKeyAndVisible];
	
	rootViewController = [[TweetListViewController alloc] init];
	
	CGRect bounds = NSRectToCGRect([window frame]);
	rootViewController.view.frame = bounds;
	rootViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[window addSubview:rootViewController.view];
			
}


@end
