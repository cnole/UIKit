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

- (id)initWithNSImage:(NSImage *)inImage;
{
	if (!inImage) {
		[self release];
		return nil;
	}
	//TODO: how to manage the memory of this cgimage
	CGImageRef imageTemp = [inImage CGImageForProposedRect:NULL context:NULL hints:nil];
	return [self initWithCGImage:imageTemp];
}

- (id)initWithContentsOfFile:(NSString *)inPath;
{
	NSImage *image = [[[NSImage alloc] initWithContentsOfFile:inPath] autorelease];
	
	return [self initWithNSImage:image];
}

- (id)initWithCGImage:(CGImageRef)inCGImage;
{
	self = [super init];
	if (!self) return nil;
	
	CFRetain(inCGImage);
	cgImage = inCGImage;
	
	return self;
}

- (id)initWithData:(NSData *)inData;
{
	NSImage *image = [[[NSImage alloc] initWithData:inData] autorelease];
	return [self initWithNSImage:image];
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


NSData *UIImagePNGRepresentation(UIImage *inImage) {
	NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:[inImage CGImage]];
	NSData *outData = [bitmapRep representationUsingType:NSPNGFileType properties:nil];
	[bitmapRep release];
	return outData;
}