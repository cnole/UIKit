//
//  UIImage.h
//  UIKit
//
//  Created by Andrew Pouliot on 1/28/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface UIImage : NSObject {
	CGImageRef cgImage;
}

+ (UIImage *)imageNamed:(NSString *)name;

- (CGImageRef)CGImage;

- (id)initWithCGImage:(CGImageRef)inCGImage;
- (id)initWithContentsOfFile:(NSString *)inPath;

@end
