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
+ (UIImage *)imageWithData:(NSData *)inData;


- (CGImageRef)CGImage;

- (id)initWithData:(NSData *)inData;
- (id)initWithCGImage:(CGImageRef)inCGImage;
- (id)initWithContentsOfFile:(NSString *)inPath;

@property(nonatomic,readonly) CGSize size;

@end

NSData *UIImagePNGRepresentation(UIImage *inImage);
