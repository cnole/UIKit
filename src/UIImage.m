//
//  UIImage.m
//  UIKit
//
//  Created by Andrew Pouliot on 1/28/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "UIImage.h"


@implementation UIImage

+ (UIImage *)imageNamed:(NSString *)name;
{
	NSString *path = [[NSBundle mainBundle] pathForImageResource:name];
	if (!path) return nil;
	return [[[self class] alloc] initWithContentsOfFile:path];
}


- (id)initWithContentsOfFile:(NSString *)inPath;
{
	NSImage *image = [[[NSImage alloc] initWithContentsOfFile:inPath] autorelease];
	if (!image) {
		[self release];
		return nil;
	}
	//TODO: how to manage the memory of this cgimage
	CGImageRef imageTemp = [image CGImageForProposedRect:NULL context:NULL hints:nil];
	self = [self initWithCGImage:imageTemp];
	
	return self;
}

- (id)initWithCGImage:(CGImageRef)inCGImage;
{
	self = [super init];
	if (!self) return nil;
	
	CFRetain(inCGImage);
	cgImage = inCGImage;
	
	return self;
}

- (void) dealloc
{
	CFRelease(cgImage);
	[super dealloc];
}

- (CGImageRef)CGImage;
{
	return (CGImageRef)[[(id)cgImage retain] autorelease];
}

@end
