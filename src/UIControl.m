//
//  UIControl.m
//  UIKit
//
//  Created by Andrew Pouliot on 2/9/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "UIControl.h"


@interface UIControlActionPair : NSObject {
@public
	SEL action;
	id target;
	UIControlEvents mask;
}
@end
@implementation UIControlActionPair
@end

BOOL selectorsEqual(SEL a, SEL b) {
	return a == b || [NSStringFromSelector(a) isEqualToString:NSStringFromSelector(a)];
}

@interface UIControl ()
- (void)_sendActionsForControlEvents:(UIControlEvents)controlEvents withEvent:(NSEvent *)inEvent;
@end

@implementation UIControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _targetActions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
	[_targetActions release];
    [super dealloc];
}

- (BOOL)isEnabled;
{
	return !_controlFlags.disabled;
}

- (void)setEnabled:(BOOL)inEnabled;
{
	_controlFlags.disabled = !inEnabled;
}

- (BOOL)isSelected;
{
	return _controlFlags.selected;
}

- (void)setSelected:(BOOL)inSelected;
{
	_controlFlags.selected = inSelected;
}

- (BOOL)isHighlighted;
{
	return _controlFlags.highlighted;
}

- (void)setHighlighted:(BOOL)inHighlighted;
{
	_controlFlags.highlighted = inHighlighted;
}

- (UIControlState)state;
{
	UIControlState state = UIControlStateNormal;
	if (_controlFlags.highlighted) state |= UIControlStateHighlighted;
	if (_controlFlags.selected) state |= UIControlStateSelected;
	if (_controlFlags.disabled) state |= UIControlStateDisabled;
	return state;
}

- (BOOL)isTracking;
{
	return _controlFlags.tracking;
}

- (BOOL)isTouchInside;
{
	return _controlFlags.touchInside;
}


- (BOOL)beginTrackingWithEvent:(NSEvent *)event;
{
	if (!_controlFlags.disabled) {
		_controlFlags.tracking = YES;
		_downTime = CFAbsoluteTimeGetCurrent();
		CGPoint eventPoint = [self convertPoint:[event locationInWindow] fromView:nil];
		_previousPoint = eventPoint;
		BOOL inside = [self pointInside:eventPoint withEvent:event];
		_controlFlags.touchInside = inside;
		
		[self sendActionsForControlEvents:[event clickCount] > 1 ? UIControlEventTouchDown : UIControlEventTouchDownRepeat];
		
		return YES;
	}
	return NO;
}

- (BOOL)continueTrackingWithEvent:(NSEvent *)event;
{
	CGPoint eventPoint = [self convertPoint:[event locationInWindow] fromView:nil];
	BOOL inside = [self pointInside:eventPoint withEvent:event];
	BOOL wasInside = [self pointInside:_previousPoint withEvent:event];
	_controlFlags.touchInside = inside;
	
	UIControlEvents eventsMask;
	if (inside && wasInside) {
		eventsMask = UIControlEventTouchDragInside;
	} else if (inside && !wasInside) {
		eventsMask = UIControlEventTouchDragEnter;
	} else if (!inside && wasInside) {
		eventsMask = UIControlEventTouchDragExit;
	} else if (!inside && !wasInside) {
		eventsMask = UIControlEventTouchDragOutside;
	}
	
	[self sendActionsForControlEvents:eventsMask];
	
	_previousPoint = eventPoint;
	
	return YES;	
}

- (void)endTrackingWithEvent:(NSEvent *)event;
{
	_controlFlags.tracking = NO;
	[self sendActionsForControlEvents:_controlFlags.touchInside ? UIControlEventTouchUpInside : UIControlEventTouchUpOutside];
	_controlFlags.touchInside = NO;
}

- (void)cancelTrackingWithEvent:(NSEvent *)event;   // event may be nil if cancelled for non-event reasons, e.g. removed from window
{
	_controlFlags.tracking = NO;
	_controlFlags.touchInside = NO;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
{
	//Find an existing pair
	for (UIControlActionPair *pair in _targetActions) {
		if (pair->target == target && selectorsEqual(pair->action, action)) {
			UIControlEvents unionOfEvents = controlEvents | pair->mask;
			pair->mask = unionOfEvents;
		}
	}
	UIControlActionPair *pair = [[[UIControlActionPair alloc] init] autorelease];
	pair->target = target;
	pair->action = action;
	pair->mask = controlEvents;
	[_targetActions addObject:pair];
}

- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
{
	for (UIControlActionPair *pair in [[_targetActions mutableCopy] autorelease]) {
		if (pair->target == target && selectorsEqual(pair->action, action)) {
			UIControlEvents remaining = pair->mask & ~controlEvents;
			if (remaining > 0) {
				pair->mask = remaining;
			} else {
				[_targetActions removeObject:pair];
			}
		}
	}
}

- (NSSet *)allTargets;                                                                     // set may include NSNull to indicate at least one nil target
{
	NSMutableSet *allTargets = [NSMutableSet set];
	for (UIControlActionPair *pair in _targetActions) {
		pair->target ? [allTargets addObject:pair->target] : [allTargets addObject:[NSNull null]];
	}
	return allTargets;
}

- (UIControlEvents)allControlEvents;                                                       // list of all events that have at least one action
{
	UIControlEvents allControlEvents = 0;
	for (UIControlActionPair *pair in _targetActions) {
		allControlEvents |= pair->mask;
	}
	return allControlEvents;
	
}
- (NSArray *)actionsForTarget:(id)target forControlEvent:(UIControlEvents)controlEvent;    // single event. returns NSArray of NSString selector names. returns nil if none
{
	NSMutableArray *selectorNames = [NSMutableArray array];
	for (UIControlActionPair *pair in _targetActions) {
		if (pair->target == target && (pair->mask & controlEvent)) {
			[selectorNames addObject:NSStringFromSelector(pair->action)];
		}
	}
	return selectorNames;
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(NSEvent *)event;
{
	//TODO: go through UIApplication
	//- (BOOL)sendAction:(SEL)theAction to:(id)theTarget from:(id)sender;
	[NSApp sendAction:action to:target from:self];
}

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents;
{
	[self _sendActionsForControlEvents:controlEvents withEvent:nil];
}

- (void)_sendActionsForControlEvents:(UIControlEvents)controlEvents withEvent:(NSEvent *)inEvent
{
	for (UIControlActionPair *pair in _targetActions) {
		if (pair->mask & controlEvents) {
			[self sendAction:pair->action to:pair->target forEvent:inEvent];
		}
	}
}

#pragma mark -
#pragma UIResponder

- (void)mouseDown:(NSEvent *)theEvent;
{
	if ([self beginTrackingWithEvent:theEvent]) {
		
	} else {
		//Send up the responder chain
		[super mouseDown:theEvent];
	}
}

- (void)mouseDragged:(NSEvent *)theEvent;
{
	if (_controlFlags.tracking && [self continueTrackingWithEvent:theEvent]) {
		
	} else {
		[super mouseDragged:theEvent];
	}
}

- (void)mouseUp:(NSEvent *)theEvent;
{
	if (_controlFlags.tracking) {
		[self endTrackingWithEvent:theEvent];
	} else {
		[super mouseUp:theEvent];
	}
}

@end
