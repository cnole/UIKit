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
	
	CGRect bounds = NSRectToCGRect([window frame]);
	
	
	tableView = [[UITableView alloc] initWithFrame:bounds];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.backgroundColor = [UIColor brownColor];
	tableView.contentSize = (CGSize) {.height = 1000.0f};
	[window addSubview:tableView];
	
	tableView.dataSource = self;
	tableView.delegate = self;
	[tableView reloadData];
			
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;
{
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	NSString *reuseIdentifier = @"Reuse";
	UITableViewCell *cell = [inTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
	}
	
	cell.textLabel.text = [NSString stringWithFormat:@"Foo bar %d", indexPath.row];
	
	return cell;
}


@end
