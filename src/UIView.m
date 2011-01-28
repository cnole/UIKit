//
//  DNUIView.m
//  DNUIKit
//
//  Created by Andrew Pouliot on 1/28/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "UIView.h"

#import <UIKit/UIColor.h>
#import <QuartzCore/QuartzCore.h>

@implementation UIView

+ (Class)layerClass;
{
	return [CALayer class];
}

+ (void)initialize;
{
	if (self == [UIView class]) {
		[CATransaction setDisableActions:YES];
		[CATransaction setAnimationDuration:0];
	}
}

- (id)initWithFrame:(CGRect)inFrame;
{
	self = [super init];
	if (!self) return nil;
	
	layer = [[[[self class] layerClass] alloc] init];
	layer.delegate = self;
	subviews = [[NSMutableArray alloc] init];
	
	self.backgroundColor = [UIColor redColor];
	
	[self setFrame:inFrame];
	
	return self;
}

- (void) dealloc
{
	[layer release];
	[super dealloc];
}

- (CALayer *)layer;
{
	return [[layer retain] autorelease];
}

- (void)setNeedsLayout;
{
	[layer setNeedsLayout];
}

- (void)layoutIfNeeded;
{
	[layer layoutIfNeeded];
}

- (void)layoutSubviews;
{
	//TODO: auto-sizing?
}

- (void)addSubview:(UIView *)inSubview;
{
	[subviews addObject:inSubview];
	[layer addSublayer:inSubview.layer];
}

- (UIView *)superview;
{
	UIView *superview = [layer superlayer].delegate;
	NSAssert1([superview isKindOfClass:[UIView class]], @"Bad superview (superlayer delegate) of type: %@!", superview);
	return superview;
	
}

- (void)removeFromSuperview;
{
	UIView *superview = [self superview];
	if (superview) {
		NSAssert([superview->subviews containsObject:self], @"Superview doesn't have us as a subview!");
		[superview->subviews removeObject:self];
	}
	[layer removeFromSuperlayer];
}

#pragma mark -
#pragma mark Geometry

- (void)setFrame:(CGRect)inFrame;
{
#if 0
	CGPoint center =  (CGPoint) {
		CGRectGetMidX(inFrame),
		CGRectGetMidY(inFrame),
	};
	
	layer.position = center;
	layer.frame = (CGRect) {
		.origin.x = center.x - inFrame.size.width / 2.f,
		.origin.y = center.y - inFrame.size.height / 2.f,
		.size = inFrame.size,
	};
#else
	layer.frame = inFrame;
#endif
}

- (CGRect)frame;
{
#if 0
	//TODO: allow center that's not 0.5, 0.5
	CGRect layerBounds = layer.bounds;
	CGPoint layerPosition = layer.position;
	return (CGRect) {
		.origin.x = layerPosition.x - layerBounds.size.width / 2.0f,
		.origin.y = layerPosition.y - layerBounds.size.height / 2.0f,
		.size = layerBounds.size,
	};
#else
	return layer.frame;
#endif
}

- (void)setBounds:(CGRect)inBounds;
{
	layer.bounds = inBounds;
}

- (CGRect)bounds;
{
	return layer.bounds;
}

- (void)setAutoresizingMask:(UIViewAutoresizing)inAutoresizingMask;
{
	layer.autoresizingMask = inAutoresizingMask;
}

- (UIViewAutoresizing)autoresizingMask;
{
	return layer.autoresizingMask;
}

#pragma mark -
#pragma mark Color


- (UIColor *)backgroundColor;
{
	return [[[UIColor alloc] initWithCGColor:layer.backgroundColor] autorelease];
}

- (void)setBackgroundColor:(UIColor *)inBackgroundColor;
{
	layer.backgroundColor = [inBackgroundColor CGColor];
}


@end



@implementation UIView (CALayerDelegate)

- (void)layoutSublayersOfLayer:(CALayer *)inLayer;
{
	NSAssert(inLayer == layer, @"Not the layer we were expecting");
	
	[self layoutSubviews];
}

@end
