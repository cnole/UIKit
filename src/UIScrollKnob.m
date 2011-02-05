//
//  UIScrollKnob.m
//  UIKit
//
//  Created by Andrew Pouliot on 1/30/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "UIScrollKnob.h"
#import "UIKit.h"

@implementation UIScrollKnob

- (id)init {
    if ((self = [super init])) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(CGRect)inRect;
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	[[UIColor whiteColor] set];
	CGContextFillRect(ctx, inRect);
	
}

- (void)dealloc {
    // Clean-up code here.
    
    [super dealloc];
}

@end
