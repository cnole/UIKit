//
//  UINSWindow.h
//  UIKit
//
//  Created by Andrew Pouliot on 1/28/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <UIKit/UIWindow.h>

typedef enum {
	UINSWindowTypeTitled,
	UINSWindowTypeTransparent,
} UINSWindowType;

@interface UINSWindow : NSWindow {
	//weak
	UIWindow *uiWindow;
}

- (id)initWithUIWindow:(UIWindow *)inWindow type:(UINSWindowType)inWindowType;

@end
