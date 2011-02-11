//
//  DNUIView.m
//  DNUIKit
//
//  Created by Andrew Pouliot on 1/28/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import <UIKit/UIColor.h>
#import <QuartzCore/QuartzCore.h>

#import "UIView.h"
#import "UIView-Private.h"
#import "UIViewController.h"

@implementation UIView

@synthesize userInteractionEnabled;
@synthesize viewDelegate;

+ (Class)layerClass;
{
	return [CALayer class];
}

- (id)initWithFrame:(CGRect)inFrame;
{
	self = [super init];
	if (!self) return nil;
	
	layer = [[[[self class] layerClass] alloc] init];
	layer.delegate = self;
	subviews = [[NSMutableArray alloc] init];
	
	userInteractionEnabled = YES;
	
	self.contentMode = UIViewContentModeScaleToFill;
	_viewFlags.implementsDrawRect = [self respondsToSelector:@selector(drawRect:)];
		
	[self setFrame:inFrame];
	
	return self;
}

- (void) dealloc
{
	layer.delegate = nil;
	[layer release];
	[subviews release];

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
	//TODO: do this better
	[subviews addObject:inSubview];
	[layer addSublayer:inSubview.layer];
	[inSubview _updateNextResponder];
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
	[self _updateNextResponder];
}

- (NSArray *)subviews;
{
	return [[subviews copy] autorelease];
}

- (void)setViewDelegate:(UIViewController *)inViewController;
{
	viewDelegate = inViewController;
	[self _updateNextResponder];
}

- (void)_updateNextResponder;
{
	if (viewDelegate) {
		[self setNextResponder:viewDelegate];
		[viewDelegate setNextResponder:self.superview];
	} else {
		[self setNextResponder:self.superview];
	}
}

#pragma mark -
#pragma mark Geometry

@end

@implementation UIView(UIViewGeometry)

- (void)setFrame:(CGRect)inFrame;
{
	layer.frame = inFrame;
	if (_viewFlags.needsDisplayOnBoundsChange)
		[self setNeedsDisplay];
}

- (CGRect)frame;
{
	return layer.frame;
}

- (void)setBounds:(CGRect)inBounds;
{
	layer.bounds = inBounds;
	if (_viewFlags.needsDisplayOnBoundsChange)
		[self setNeedsDisplay];
}

- (CGRect)bounds;
{
	return layer.bounds;
}

- (void)setCenter:(CGPoint)inCenter;
{
	self.layer.anchorPoint = inCenter;
}

- (CGPoint)center;
{
	return self.layer.anchorPoint;
}

- (CGAffineTransform)transform;
{
	CATransform3D t = layer.transform;
	if (CATransform3DIsAffine(t)) {
		return CATransform3DGetAffineTransform(t);
	} else {
		return CGAffineTransformIdentity;
	}
}

- (void)setTransform:(CGAffineTransform)inTransform;
{
	self.layer.transform = CATransform3DMakeAffineTransform(inTransform);
}


- (void)setAutoresizingMask:(UIViewAutoresizing)inAutoresizingMask;
{
	layer.autoresizingMask = inAutoresizingMask;
}

- (UIViewAutoresizing)autoresizingMask;
{
	return layer.autoresizingMask;
}

- (CGSize)sizeThatFits:(CGSize)size;
{
	return self.frame.size;
}

- (void)sizeToFit;
{
	CGRect newFrame = self.frame;
	newFrame.size = [self sizeThatFits:newFrame.size];
	self.frame = newFrame;
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
	return [self.layer convertPoint:point fromLayer:inView.layer];
}

- (CGPoint)convertPoint:(CGPoint)point toView:(UIView *)inView
{
	return [self.layer convertPoint:point toLayer:inView.layer];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(NSEvent *)event;
{
	if ([self pointInside:point withEvent:event]) {
		for (UIView *subview in [[self subviews] reverseObjectEnumerator]) {
			if (subview.userInteractionEnabled && subview.alpha > 0.01f) {
				CGPoint subviewPoint = [self convertPoint:point toView:subview];
				UIView *foundView = [subview hitTest:subviewPoint withEvent:event];
				if (foundView) {
					return foundView;
				}
			}
		}
		return self;
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



#pragma mark -


- (CGRect)convertRect:(CGRect)rect toView:(UIView *)view;
{
	return [self.layer convertRect:rect toLayer:view.layer];
}

- (CGRect)convertRect:(CGRect)rect fromView:(UIView *)view;
{
	return [self.layer convertRect:rect fromLayer:view.layer];
}


#pragma mark -
#pragma mark Debug

- (NSString *)description;
{
	return [[super description] stringByAppendingFormat:@"{frame:%@}", NSStringFromRect(NSRectFromCGRect(self.frame))];
}

- (NSString *)_recursiveDescriptionWithLevel:(NSUInteger)inLevel;
{
	NSString *indent = @"";
	for (int i=0; i<inLevel; i++) {
		indent = [indent stringByAppendingString:@" | "];
	}
	NSString *str = [NSString stringWithFormat:@"%@%@\n", indent, [self description]];
	for (UIView *view in self.subviews) {
		str = [str stringByAppendingString:[view _recursiveDescriptionWithLevel:inLevel+1]];
	}
	return str;
}


- (NSString *)recursiveDescription;
{
	return [self _recursiveDescriptionWithLevel:0];
}
@end

@implementation UIView(UIViewRendering)

//- (void)drawRect:(CGRect)rect;

- (void)setNeedsDisplay;
{
	[self.layer setNeedsDisplay];
}

- (void)setNeedsDisplayInRect:(CGRect)rect;
{
	[self.layer setNeedsDisplayInRect:rect];
}

- (BOOL)clipsToBounds;
{
	return layer.masksToBounds;
}

- (void)setClipsToBounds:(BOOL)inClipsToBounds;
{
	layer.masksToBounds = inClipsToBounds;
}

- (UIColor *)backgroundColor;
{
	return [[[UIColor alloc] initWithCGColor:layer.backgroundColor] autorelease];
}

- (void)setBackgroundColor:(UIColor *)inBackgroundColor;
{
	layer.backgroundColor = [inBackgroundColor CGColor];
}

- (CGFloat)alpha;
{
	return layer.opacity;
}

- (void)setAlpha:(CGFloat)inAlpha;
{
	layer.opacity = inAlpha;
}

- (BOOL)opaque;
{
	return layer.opaque;
}

- (void)setOpaque:(BOOL)inOpaque;
{
	layer.opaque = inOpaque;
}

//TODO:- (BOOL)              clearsContextBeforeDrawing;

- (BOOL)hidden;
{
	return layer.hidden;
}

- (void)setHidden:(BOOL)inHidden;
{
	layer.hidden = inHidden;
}

- (UIViewContentMode)contentMode;
{
	BOOL drawRectDude = _viewFlags.needsDisplayOnBoundsChange;
	if (drawRectDude) return UIViewContentModeRedraw;
	
	/*Options are `center', `top', `bottom', `left',
	* `right', `topLeft', `topRight', `bottomLeft', `bottomRight',
	* `resize', `resizeAspect', `resizeAspectFill'. The default value is
	* `resize'*/
	
	if ([layer.contentsGravity isEqualToString:@"center"]) {
		return UIViewContentModeCenter;
	} else if ([layer.contentsGravity isEqualToString:@"top"]) {
		return UIViewContentModeTop;
	} else if ([layer.contentsGravity isEqualToString:@"bottom"]) {
		return UIViewContentModeBottom;
	} else if ([layer.contentsGravity isEqualToString:@"left"]) {
		return UIViewContentModeLeft;
	} else if ([layer.contentsGravity isEqualToString:@"right"]) {
		return UIViewContentModeRight;
	} else if ([layer.contentsGravity isEqualToString:@"topLeft"]) {
		return UIViewContentModeTopLeft;
	} else if ([layer.contentsGravity isEqualToString:@"topRight"]) {
		return UIViewContentModeTopRight;
	} else if ([layer.contentsGravity isEqualToString:@"bottomLeft"]) {
		return UIViewContentModeBottomLeft;
	} else if ([layer.contentsGravity isEqualToString:@"bottomRight"]) {
		return UIViewContentModeBottomRight;
	} else if ([layer.contentsGravity isEqualToString:@"resize"]) {
		return UIViewContentModeScaleToFill;
	} else if ([layer.contentsGravity isEqualToString:@"resizeAspect"]) {
		return UIViewContentModeScaleAspectFit;
	} else if ([layer.contentsGravity isEqualToString:@"resizeAspectFill"]) {
		return UIViewContentModeScaleAspectFill;
	}
	NSAssert(FALSE, @"Unknown contentsGravity on layer couldn't be mapped to a UIView contentMode");
	return UIViewContentModeScaleToFill;
}

- (void)setContentMode:(UIViewContentMode)inContentMode;
{
	if (inContentMode == UIViewContentModeRedraw) {
		//TODO: verify this behaviour
		layer.contentsGravity = @"resize";
	} else if (inContentMode == UIViewContentModeCenter) {
		layer.contentsGravity = @"center";
	} else if (inContentMode == UIViewContentModeTop) {
		layer.contentsGravity = @"top";
	} else if (inContentMode == UIViewContentModeBottom) {
		layer.contentsGravity = @"bottom";
	} else if (inContentMode == UIViewContentModeLeft) {
		layer.contentsGravity = @"left";
	} else if (inContentMode == UIViewContentModeRight) {
		layer.contentsGravity = @"right";
	} else if (inContentMode == UIViewContentModeTopLeft) {
		layer.contentsGravity = @"topLeft";
	} else if (inContentMode == UIViewContentModeTopRight) {
		layer.contentsGravity = @"topRight";
	} else if (inContentMode == UIViewContentModeBottomLeft) {
		layer.contentsGravity = @"bottomLeft";
	} else if (inContentMode == UIViewContentModeBottomRight) {
		layer.contentsGravity = @"bottomRight";
	} else if (inContentMode == UIViewContentModeScaleToFill) {
		layer.contentsGravity = @"resize";
	} else if (inContentMode == UIViewContentModeScaleAspectFit) {
		layer.contentsGravity = @"resizeAspect";
	} else if (inContentMode == UIViewContentModeScaleAspectFill) {
		layer.contentsGravity = @"resizeAspectFill";
	}
	_viewFlags.needsDisplayOnBoundsChange = (inContentMode == UIViewContentModeRedraw);

}
//TODO: How can we implement this?
//@property(nonatomic)                 CGRect            contentStretch __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0); // animatable. default is unit rectangle {{0,0} {1,1}}

@end


@interface UIViewAnimationGroup : NSObject {
}
@property (nonatomic) NSTimeInterval delay;
@property (nonatomic) NSTimeInterval duration;

+ (NSMutableArray *)animationGroupStack;

+ (UIViewAnimationGroup *)currentAnimationGroup;

+ (void)begin;
+ (void)commit;

@end

@implementation UIViewAnimationGroup
@synthesize delay;
@synthesize duration;
+ (NSMutableArray *)animationGroupStack;
{
	static NSMutableArray *animationGroupStack;
	if (!animationGroupStack) {
		animationGroupStack = [[NSMutableArray alloc] init];
	}
	return animationGroupStack;
}

+ (UIViewAnimationGroup *)currentAnimationGroup;
{
	NSMutableArray *animationGroupStack = [self animationGroupStack];
	if (animationGroupStack.count > 0) {
		return [animationGroupStack objectAtIndex:animationGroupStack.count - 1];
	} else {
		return nil;
	}
}

+ (void)begin;
{
	UIViewAnimationGroup *group = [[[UIViewAnimationGroup alloc] init] autorelease];
	[[self animationGroupStack] addObject:group];
}

+ (void)commit;
{
	[[self animationGroupStack] removeLastObject];
}


@end


@interface UIViewAnimation : NSObject <CAAction> {
	
}
@property (nonatomic, retain) CABasicAnimation *animation;
@end

@implementation UIViewAnimation
@synthesize animation;
- (void)runActionForKey:(NSString *)event object:(id)anObject arguments:(NSDictionary *)dict;
{
	CALayer *layer = (CALayer *)anObject;
	animation.toValue = [layer valueForKey:event];
	[layer addAnimation:animation forKey:event];
}
@end


@implementation UIView (CALayerDelegate)

- (void)layoutSublayersOfLayer:(CALayer *)inLayer;
{
	NSAssert2(inLayer == layer, @"layoutSublayersOfLayer: (%@) is not the layer we were expecting (%@).", inLayer, layer);
	
	[self layoutSubviews];
}

- (void)drawLayer:(CALayer *)inLayer inContext:(CGContextRef)ctx;
{
	NSAssert2(inLayer == layer, @"drawLayer:inContext: (%@) is not the layer we were expecting (%@).", inLayer, layer);

	UIGraphicsPushContext(ctx);
	if ([self respondsToSelector:@selector(drawRect:)]) {
		[self drawRect:self.bounds];
	}
	UIGraphicsPopContext();
}

- (id<CAAction>)actionForLayer:(CALayer *)inLayer forKey:(NSString *)event;
{
	UIViewAnimationGroup *group = [UIViewAnimationGroup currentAnimationGroup];
	if (group) {
		UIViewAnimation *viewAnimation = [[[UIViewAnimation alloc] init] autorelease];
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
		animation.duration = group.duration;
		animation.fromValue = [inLayer valueForKey:event];
		viewAnimation.animation = animation;
		return viewAnimation;
	} else {
		return (id)[NSNull null];		
	}
}

@end


@implementation UIView (UIViewAnimationWithBlocks)

+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
{
	[UIViewAnimationGroup begin];
	UIViewAnimationGroup *group = [UIViewAnimationGroup currentAnimationGroup];
	group.duration = duration;
	group.delay = delay;
	[CATransaction begin];
	[CATransaction setAnimationDuration:duration];
	//TODO: delay
	if (animations)
		animations();
	
	//TODO: pass back whether we actually finished!
	if (completion) {
		[CATransaction setCompletionBlock:^{completion(YES);}];
	}
	[CATransaction commit];
	[UIViewAnimationGroup commit];
}

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
{
	[self animateWithDuration:duration delay:0.0 options:0 animations:animations completion:completion];
}

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations;
{
	[self animateWithDuration:duration delay:0.0 options:0 animations:animations completion:NULL];
}

//TODO: + (void)transitionWithView:(UIView *)view duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

//TODO: + (void)transitionFromView:(UIView *)fromView toView:(UIView *)toView duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion; // toView added to fromView.superview, fromView removed from its superview

@end
