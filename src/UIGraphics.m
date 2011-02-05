//
//  UIGraphics.m
//  UIKit
//
//  Created by Jason C. Martin on 2/10/10.
//  Copyright 2010 New Media Geekz. All rights reserved.
//

#import "UIGraphics.h"

NSMutableArray *UIGraphicsContextStackGetGlobal() {
	if ([NSThread currentThread] != [NSThread mainThread]) {
		NSLog(@"Attempted to use UIGraphics code on non-main thread!");
	}
	
	static NSMutableArray *stack;
	if (!stack) {
		stack = [[NSMutableArray alloc] init];
	}
	return stack;
}

CGContextRef UIGraphicsGetCurrentContext(void) {
	NSMutableArray *stack = UIGraphicsContextStackGetGlobal();
	if (stack.count > 0) {
		return (CGContextRef)[stack objectAtIndex:0];
	} else {
		return NULL;
	}
}

void UIGraphicsPushContext(CGContextRef context) {
	NSMutableArray *stack = UIGraphicsContextStackGetGlobal();
	[stack addObject:(id)context];
}

void UIGraphicsPopContext(void) {
	NSMutableArray *stack = UIGraphicsContextStackGetGlobal();
	[stack removeLastObject];
}