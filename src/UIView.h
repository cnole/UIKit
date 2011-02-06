//
//  DNUIView.h
//  DNUIKit
//
//  Created by Andrew Pouliot on 1/28/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    UIViewAutoresizingNone                 = 0,
    UIViewAutoresizingFlexibleLeftMargin   = 1 << 0,
    UIViewAutoresizingFlexibleWidth        = 1 << 1,
    UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
    UIViewAutoresizingFlexibleTopMargin    = 1 << 3,
    UIViewAutoresizingFlexibleHeight       = 1 << 4,
    UIViewAutoresizingFlexibleBottomMargin = 1 << 5
};
typedef NSUInteger UIViewAutoresizing;


@class CALayer;
@class UIColor;
@class NSEvent;
@class UIViewController;
@interface UIView : NSResponder {
@private
	CALayer *layer;
	UIViewController *viewDelegate;
	//TODO: why don't other implementations have this, ie how do they retain the views?
	NSMutableArray *subviews;
	BOOL userInteractionEnabled;
}

@property (nonatomic, assign) BOOL userInteractionEnabled;

+ (Class)layerClass;

- (id)initWithFrame:(CGRect)inFrame;

- (void)setNeedsLayout;
- (void)layoutIfNeeded;
- (void)layoutSubviews;

- (void)setNeedsDisplay;

- (UIView *)superview;
- (void)addSubview:(UIView *)inSubview;
- (void)removeFromSuperview;

@property (nonatomic) CGFloat alpha;
@property (nonatomic) BOOL opaque;

- (void)drawRect:(CGRect)inRect;

@property (nonatomic, readonly, copy) NSArray *subviews;

- (UIView *)hitTest:(CGPoint)point withEvent:(NSEvent *)event;
- (BOOL)pointInside:(CGPoint)point withEvent:(NSEvent *)event;

- (CGPoint)convertPoint:(CGPoint)point fromView:(UIView *)inView;
- (CGPoint)convertPoint:(CGPoint)point toView:(UIView *)inView;


@property(nonatomic) CGRect            frame;

// use bounds/center and not frame if non-identity transform. if bounds dimension is odd, center may be have fractional part
@property(nonatomic) CGRect            bounds;      // default bounds is zero origin, frame size. animatable
//TODO: @property(nonatomic) CGPoint           center;      // center is center of frame. animatable
//TODO: @property(nonatomic) CGAffineTransform transform;   // default is CGAffineTransformIdentity. animatable

@property(nonatomic,readonly,retain)                 CALayer  *layer;              // returns view's layer. Will always return a non-nil value. view is layer's delegate

@property(nonatomic,copy)            UIColor          *backgroundColor;            // default is nil



//TODO: @property(nonatomic) BOOL               autoresizesSubviews; // default is YES. if set, subviews are adjusted according to their autoresizingMask if self.bounds changes
@property(nonatomic) UIViewAutoresizing autoresizingMask;    // simple resize. default is UIViewAutoresizingNone

@end
