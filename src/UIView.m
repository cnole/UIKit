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
	NSAssert1(!superview || [superview isKindOfClass:[UIView class]], @"Bad superview (superlayer delegate) of type: %@!", superview);
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

- (NSArray *)subviews;
{
	return [[subviews copy] autorelease];
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
#pragma mark Event Handling

- (BOOL)isDescendantOfView:(UIView *)inView;
{
	UIView *parent = [self superview];
	while (parent && parent != inView) {
		parent = [parent superview];
	}
	return parent != nil;
}

- (CGPoint)convertPoint:(CGPoint)point fromView:(UIView *)inView
{
	NSAssert(inView, @"window conversion UNIMPLEMENTED");
	
	//Only supported atm if view is a descendant of self or if self is a descendant of view (not siblings)
	BOOL isDescendant = [inView isDescendantOfView:self];
	BOOL isAncestor = [self isDescendantOfView:inView];
	NSAssert(isDescendant || isAncestor, @"Sibling views not supported!");

	if (isDescendant) {
		UIView *currentView = inView;
		while (currentView && currentView != self) {
			CGRect foo = currentView.frame;
			point.x += foo.origin.x;
			point.y += foo.origin.y;
			currentView = [currentView superview];
		}
	}
	if (isAncestor) {
		UIView *currentView = self;
		while (currentView && currentView != inView) {
			CGRect foo = currentView.frame;
			point.x -= foo.origin.x;
			point.y -= foo.origin.y;
			currentView = [currentView superview];
		}
	}
	
	return point;
}

- (CGPoint)convertPoint:(CGPoint)point toView:(UIView *)inView
{
	return [inView convertPoint:point fromView:self];
}


//Assumes self contains point if converted to our coords
//Return the recursive result of this method called on the first subview that contains point
//If no subview contains the point, return self
- (UIView *)_hitTestHelper:(CGPoint)point inView:(UIView *)inView withEvent:(UIEvent *)event;
{
	for (UIView *subview in [self subviews]) {
		CGPoint subviewPoint = [inView convertPoint:point toView:subview];
		if ([subview pointInside:subviewPoint withEvent:event]) {
			return [subview _hitTestHelper:point inView:inView withEvent:event];
		}
	}
	return self;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event;
{
	if ([self pointInside:point withEvent:event]) {
		return [self _hitTestHelper:point inView:self withEvent:event];
	} else {
		return nil;
	}
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	return CGRectContainsPoint(self.bounds, point);
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

- (BOOL)pointInside:(CGPoint)inPoint;
{
	return CGRectContainsPoint([self bounds], inPoint);
}
@end



@implementation UIView (CALayerDelegate)

- (void)layoutSublayersOfLayer:(CALayer *)inLayer;
{
	NSAssert(inLayer == layer, @"Not the layer we were expecting");
	
	[self layoutSubviews];
}

@end
