//
//  UIWindow.h
//  UIKit
//
//  Created by Jason C. Martin on 2/10/10.
//  Copyright 2010 New Media Geekz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <UIKit/UIView.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIKitDefines.h>

@interface UIWindow : UIView <NSWindowDelegate> {
@private
	NSWindow *nsWindow;
	UIView *trackingView;
}

- (void)makeKeyAndVisible;                             // convenience. most apps call this to show the main window and also make it key. otherwise use view hidden property

- (void)sendEvent:(NSEvent *)event;

@end
