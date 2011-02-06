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

@synthesize userInteractionEnabled;

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
	
	userInteractionEnabled = YES;
		
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

- (void)setNeedsDisplay;
{
	[layer setNeedsDisplay];
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
	layer.frame = inFrame;
	//TODO: only if content mode set to redraw!
	[self setNeedsDisplay];
}

- (CGRect)frame;
{
	return layer.frame;
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

- (NSResponder *)nextResponder;
{
	//TODO: view controller support: return the view controller if we have one
	return self.superview;
}

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
	return [self.layer convertPoint:point fromLayer:inView.layer];
}

- (CGPoint)convertPoint:(CGPoint)point toView:(UIView *)inView
{
	return [self.layer convertPoint:point toLayer:inView.layer];
}


//Assumes self contains point if converted to our coords
//Return the recursive result of this method called on the last subview that contains point
//If no subview contains the point, return self
- (UIView *)_hitTestHelper:(CGPoint)point inView:(UIView *)inView withEvent:(NSEvent *)event;
{
	for (UIView *subview in [[self subviews] reverseObjectEnumerator]) {
		if (subview.userInteractionEnabled && subview.alpha > 0.01f) {
			CGPoint subviewPoint = [inView convertPoint:point toView:subview];
			if ([subview pointInside:subviewPoint withEvent:event]) {
				return [subview _hitTestHelper:point inView:inView withEvent:event];
			}
		}
	}
	return self;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(NSEvent *)event;
{
	if ([self pointInside:point withEvent:event]) {
		return [self _hitTestHelper:point inView:self withEvent:event];
	} else {
		return nil;
	}
}


- (BOOL)pointInside:(CGPoint)point withEvent:(NSEvent *)event
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

#pragma mark -

- (BOOL)opaque;
{
	return layer.opaque;
}

- (void)setOpaque:(BOOL)inOpaque;
{
	layer.opaque = inOpaque;
}

- (CGFloat)alpha;
{
	return layer.opacity;
}

- (void)setAlpha:(CGFloat)inAlpha;
{
	layer.opacity = inAlpha;
}

#pragma mark -
#pragma mark Debug

- (NSString *)description;
{
	return [[super description] stringByAppendingFormat:@"{frame:%@}", NSStringFromRect(NSRectFromCGRect(self.frame))];
}

@end



@implementation UIView (CALayerDelegate)

- (void)layoutSublayersOfLayer:(CALayer *)inLayer;
{
	NSAssert(inLayer == layer, @"Not the layer we were expecting");
	
	[self layoutSubviews];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
{
	UIGraphicsPushContext(ctx);
	if ([self respondsToSelector:@selector(drawRect:)]) {
		[self drawRect:self.bounds];
	}
	UIGraphicsPopContext();
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event;
{
	return (id)[NSNull null];
}

@end
