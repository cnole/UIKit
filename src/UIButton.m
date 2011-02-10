//
//  UIButton.m
//  UIKit
//
//  Created by Andrew Pouliot on 2/10/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "UIButton.h"

#import "UILabel.h"
#import "UIImageView.h"

@class UIButtonStateMutable;

@interface UIButtonStateMutable : NSObject {}
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) UIColor *titleColor;
@property (nonatomic, retain) UIColor *titleShadowColor;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImage *backgroundImage;
@end

@interface UIButton ()
- (void)_updateCurrentButtonState;
@end

@implementation UIButton

@synthesize contentEdgeInsets = _contentEdgeInsets;
@synthesize titleEdgeInsets = _titleEdgeInsets;
@synthesize imageEdgeInsets = _imageEdgeInsets;

+ (id)buttonWithType:(UIButtonType)buttonType;
{
	NSAssert(buttonType == UIButtonTypeCustom, @"Only custom buttons are supported on Mac.");
	return [[[UIButton alloc] initWithFrame:CGRectZero] autorelease];
}

- (id)initWithFrame:(CGRect)inFrame;
{
	self = [super initWithFrame:inFrame];
	if (!self) return nil;
	
	_stateLookupTable = [[NSMutableDictionary alloc] init];
	_backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
	[self addSubview:_backgroundView];
		
	return self;
}

- (void)dealloc {
	[_stateLookupTable release];
    [_backgroundView release];
    [_imageView release];
	[_titleView release];
    [super dealloc];
}

- (BOOL)reversesTitleShadowWhenHighlighted;
{
	return _buttonFlags.reversesTitleShadowWhenHighlighted;
}

- (void)setReversesTitleShadowWhenHighlighted:(BOOL)inReversesTitleShadowWhenHighlighted;
{
	_buttonFlags.reversesTitleShadowWhenHighlighted = inReversesTitleShadowWhenHighlighted;
}

- (UIButtonType)buttonType;
{
	return UIButtonTypeCustom;
}

//Mutable object
- (UIButtonStateMutable *)_existingStateObjectForControlState:(UIControlState)inState;
{
	return [_stateLookupTable objectForKey:[NSNumber numberWithInt:inState]];
}

- (UIButtonStateMutable *)_createOrReturnStateObjectForControlState:(UIControlState)inState;
{
	UIButtonStateMutable *stateObject =  [_stateLookupTable objectForKey:[NSNumber numberWithInt:inState]];
	if (!stateObject) {
		stateObject = [[[UIButtonStateMutable alloc] init] autorelease];
		[_stateLookupTable setObject:stateObject forKey:[NSNumber numberWithInt:inState]];
	}
	return stateObject;
}


- (void)setTitle:(NSString *)title forState:(UIControlState)state;
{
	[self _createOrReturnStateObjectForControlState:state].title = title;
	[self _updateCurrentButtonState];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
{
	[self _createOrReturnStateObjectForControlState:state].titleColor = color;
	[self _updateCurrentButtonState];
}

- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state;
{
	[self _createOrReturnStateObjectForControlState:state].titleShadowColor = color;
	[self _updateCurrentButtonState];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state;
{
	[self _createOrReturnStateObjectForControlState:state].image = image;
	[self _updateCurrentButtonState];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
{
	[self _createOrReturnStateObjectForControlState:state].backgroundImage = image;
	[self _updateCurrentButtonState];
}

- (void)_updateCurrentButtonState;
{
	[self titleLabel].text = self.currentTitle;
	[self titleLabel].textColor = self.currentTitleColor ? self.currentTitleColor : [UIColor whiteColor];
//TODO:	[self titleLabel].textShadowColor = self.textShadowColor ? self.textShadowColor : [UIColor colorWithWhite:0.0f alpha:0.5f];
	[self imageView].image = self.currentImage;
	_backgroundView.image = self.currentBackgroundImage;
}

/*
 
 This table made by Andrew Pouliot, but has not been compared with UIKit for iOS.
 I tried to pick the most logical thing, but who knows what the iOS engineers chose.
 
 D	S	H	Name								Fallback Order
 0	0	0	0	Normal							none
 1	0	0	1	Highlighted						0
 2	0	1	0	Selected						0
 3	0	1	1	Highlighted|Selected			1,2,0
 4	1	0	0	Disabled						0
 5	1	0	1	Highlighted|Disabled			4,0
 6	1	1	0	Disabled|Selected				4,2,0
 7	1	1	1	Highlighted|Disabled|Selected	4,0
 
 D = disabled
 S = selected
 H = highlighted
 
 */

//- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;        // default if nil. use opaque white
//- (void)setTitleShadowColor:(UIColor *)color forState:(UIControlState)state;  // default is nil. use 50% black
//- (void)setImage:(UIImage *)image forState:(UIControlState)state;             // default is nil. should be same size if different for different states
//- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;   // default is nil

- (NSString *)titleForState:(UIControlState)state;
{
	NSString *title = nil; //nil is the fallback
	//Try the main one
	title = [self _existingStateObjectForControlState:state].title;
	//Fallback
	if (!title) {
		if (state == UIControlStateHighlighted) {

			title = [self _existingStateObjectForControlState:UIControlStateNormal].title;
			
		} else if (state == UIControlStateSelected) {
			
			title = [self _existingStateObjectForControlState:UIControlStateNormal].title;
			
		} else if (state == (UIControlStateHighlighted | UIControlStateSelected)) {
			
			title = [self _existingStateObjectForControlState:UIControlStateHighlighted].title;
			if (!title)
				title = [self _existingStateObjectForControlState:UIControlStateSelected].title;
			if (!title)
				title = [self _existingStateObjectForControlState:UIControlStateNormal].title;
			
		} else if (state == UIControlStateDisabled) {
			
			title = [self _existingStateObjectForControlState:UIControlStateNormal].title;
			
		} else if (state == (UIControlStateDisabled | UIControlStateHighlighted)) {
			
			title = [self _existingStateObjectForControlState:UIControlStateDisabled].title;
			if (!title)
				title = [self _existingStateObjectForControlState:UIControlStateNormal].title;
			
		} else if (state == (UIControlStateDisabled | UIControlStateSelected)) {
			
			title = [self _existingStateObjectForControlState:UIControlStateDisabled].title;
			if (!title)
				title = [self _existingStateObjectForControlState:UIControlStateSelected].title;
			if (!title)
				title = [self _existingStateObjectForControlState:UIControlStateNormal].title;
			
		} else if (state == (UIControlStateDisabled | UIControlStateSelected | UIControlStateHighlighted)) {

			title = [self _existingStateObjectForControlState:UIControlStateDisabled].title;
			if (!title)
				title = [self _existingStateObjectForControlState:UIControlStateNormal].title;

		}
	}
	return title;
}

- (UIColor *)titleColorForState:(UIControlState)state;
{
	UIColor *titleShadowColor = nil; //nil is the fallback
	//Try the main one
	titleShadowColor = [self _existingStateObjectForControlState:state].titleShadowColor;
	//Fallback
	if (!titleShadowColor) {
		if (state == UIControlStateHighlighted) {
			
			titleShadowColor = [self _existingStateObjectForControlState:UIControlStateNormal].titleShadowColor;
			
		} else if (state == UIControlStateSelected) {
			
			titleShadowColor = [self _existingStateObjectForControlState:UIControlStateNormal].titleShadowColor;
			
		} else if (state == (UIControlStateHighlighted | UIControlStateSelected)) {
			
			titleShadowColor = [self _existingStateObjectForControlState:UIControlStateHighlighted].titleShadowColor;
			if (!titleShadowColor)
				titleShadowColor = [self _existingStateObjectForControlState:UIControlStateSelected].titleShadowColor;
			if (!titleShadowColor)
				titleShadowColor = [self _existingStateObjectForControlState:UIControlStateNormal].titleShadowColor;
			
		} else if (state == UIControlStateDisabled) {
			
			titleShadowColor = [self _existingStateObjectForControlState:UIControlStateNormal].titleShadowColor;
			
		} else if (state == (UIControlStateDisabled | UIControlStateHighlighted)) {
			
			titleShadowColor = [self _existingStateObjectForControlState:UIControlStateDisabled].titleShadowColor;
			if (!titleShadowColor)
				titleShadowColor = [self _existingStateObjectForControlState:UIControlStateNormal].titleShadowColor;
			
		} else if (state == (UIControlStateDisabled | UIControlStateSelected)) {
			
			titleShadowColor = [self _existingStateObjectForControlState:UIControlStateDisabled].titleShadowColor;
			if (!titleShadowColor)
				titleShadowColor = [self _existingStateObjectForControlState:UIControlStateSelected].titleShadowColor;
			if (!titleShadowColor)
				titleShadowColor = [self _existingStateObjectForControlState:UIControlStateNormal].titleShadowColor;
			
		} else if (state == (UIControlStateDisabled | UIControlStateSelected | UIControlStateHighlighted)) {
			
			titleShadowColor = [self _existingStateObjectForControlState:UIControlStateDisabled].titleShadowColor;
			if (!titleShadowColor)
				titleShadowColor = [self _existingStateObjectForControlState:UIControlStateNormal].titleShadowColor;
			
		}
	}
	return titleShadowColor;
	
}

- (UIColor *)titleShadowColorForState:(UIControlState)state;
{
	UIColor *titleShadowColor = nil; //nil is the fallback
	//Try the main one
	titleShadowColor = [self _existingStateObjectForControlState:state].titleShadowColor;
	//Fallback
	if (!titleShadowColor) {
		if (state == UIControlStateHighlighted) {
			
			titleShadowColor = [self _existingStateObjectForControlState:UIControlStateNormal].titleShadowColor;
			
		} else if (state == UIControlStateSelected) {
			
			titleShadowColor = [self _existingStateObjectForControlState:UIControlStateNormal].titleShadowColor;
			
		} else if (state == (UIControlStateHighlighted | UIControlStateSelected)) {
			
			titleShadowColor = [self _existingStateObjectForControlState:UIControlStateHighlighted].titleShadowColor;
			if (!titleShadowColor)
				titleShadowColor = [self _existingStateObjectForControlState:UIControlStateSelected].titleShadowColor;
			if (!titleShadowColor)
				titleShadowColor = [self _existingStateObjectForControlState:UIControlStateNormal].titleShadowColor;
			
		} else if (state == UIControlStateDisabled) {
			
			titleShadowColor = [self _existingStateObjectForControlState:UIControlStateNormal].titleShadowColor;
			
		} else if (state == (UIControlStateDisabled | UIControlStateHighlighted)) {
			
			titleShadowColor = [self _existingStateObjectForControlState:UIControlStateDisabled].titleShadowColor;
			if (!titleShadowColor)
				titleShadowColor = [self _existingStateObjectForControlState:UIControlStateNormal].titleShadowColor;
			
		} else if (state == (UIControlStateDisabled | UIControlStateSelected)) {
			
			titleShadowColor = [self _existingStateObjectForControlState:UIControlStateDisabled].titleShadowColor;
			if (!titleShadowColor)
				titleShadowColor = [self _existingStateObjectForControlState:UIControlStateSelected].titleShadowColor;
			if (!titleShadowColor)
				titleShadowColor = [self _existingStateObjectForControlState:UIControlStateNormal].titleShadowColor;
			
		} else if (state == (UIControlStateDisabled | UIControlStateSelected | UIControlStateHighlighted)) {
			
			titleShadowColor = [self _existingStateObjectForControlState:UIControlStateDisabled].titleShadowColor;
			if (!titleShadowColor)
				titleShadowColor = [self _existingStateObjectForControlState:UIControlStateNormal].titleShadowColor;
			
		}
	}
	return titleShadowColor;
}

- (UIImage *)imageForState:(UIControlState)state;
{
	UIImage *image = nil; //nil is the fallback
	//Try the main one
	image = [self _existingStateObjectForControlState:state].image;
	//Fallback
	if (!image) {
		if (state == UIControlStateHighlighted) {
			
			image = [self _existingStateObjectForControlState:UIControlStateNormal].image;
			
		} else if (state == UIControlStateSelected) {
			
			image = [self _existingStateObjectForControlState:UIControlStateNormal].image;
			
		} else if (state == (UIControlStateHighlighted | UIControlStateSelected)) {
			
			image = [self _existingStateObjectForControlState:UIControlStateHighlighted].image;
			if (!image)
				image = [self _existingStateObjectForControlState:UIControlStateSelected].image;
			if (!image)
				image = [self _existingStateObjectForControlState:UIControlStateNormal].image;
			
		} else if (state == UIControlStateDisabled) {
			
			image = [self _existingStateObjectForControlState:UIControlStateNormal].image;
			
		} else if (state == (UIControlStateDisabled | UIControlStateHighlighted)) {
			
			image = [self _existingStateObjectForControlState:UIControlStateDisabled].image;
			if (!image)
				image = [self _existingStateObjectForControlState:UIControlStateNormal].image;
			
		} else if (state == (UIControlStateDisabled | UIControlStateSelected)) {
			
			image = [self _existingStateObjectForControlState:UIControlStateDisabled].image;
			if (!image)
				image = [self _existingStateObjectForControlState:UIControlStateSelected].image;
			if (!image)
				image = [self _existingStateObjectForControlState:UIControlStateNormal].image;
			
		} else if (state == (UIControlStateDisabled | UIControlStateSelected | UIControlStateHighlighted)) {
			
			image = [self _existingStateObjectForControlState:UIControlStateDisabled].image;
			if (!image)
				image = [self _existingStateObjectForControlState:UIControlStateNormal].image;
			
		}
	}
	return image;

}

- (UIImage *)backgroundImageForState:(UIControlState)state;
{
	UIImage *backgroundImage = nil; //nil is the fallback
	//Try the main one
	backgroundImage = [self _existingStateObjectForControlState:state].backgroundImage;
	//Fallback
	if (!backgroundImage) {
		if (state == UIControlStateHighlighted) {
			
			backgroundImage = [self _existingStateObjectForControlState:UIControlStateNormal].backgroundImage;
			
		} else if (state == UIControlStateSelected) {
			
			backgroundImage = [self _existingStateObjectForControlState:UIControlStateNormal].backgroundImage;
			
		} else if (state == (UIControlStateHighlighted | UIControlStateSelected)) {
			
			backgroundImage = [self _existingStateObjectForControlState:UIControlStateHighlighted].backgroundImage;
			if (!backgroundImage)
				backgroundImage = [self _existingStateObjectForControlState:UIControlStateSelected].backgroundImage;
			if (!backgroundImage)
				backgroundImage = [self _existingStateObjectForControlState:UIControlStateNormal].backgroundImage;
			
		} else if (state == UIControlStateDisabled) {
			
			backgroundImage = [self _existingStateObjectForControlState:UIControlStateNormal].backgroundImage;
			
		} else if (state == (UIControlStateDisabled | UIControlStateHighlighted)) {
			
			backgroundImage = [self _existingStateObjectForControlState:UIControlStateDisabled].backgroundImage;
			if (!backgroundImage)
				backgroundImage = [self _existingStateObjectForControlState:UIControlStateNormal].backgroundImage;
			
		} else if (state == (UIControlStateDisabled | UIControlStateSelected)) {
			
			backgroundImage = [self _existingStateObjectForControlState:UIControlStateDisabled].backgroundImage;
			if (!backgroundImage)
				backgroundImage = [self _existingStateObjectForControlState:UIControlStateSelected].backgroundImage;
			if (!backgroundImage)
				backgroundImage = [self _existingStateObjectForControlState:UIControlStateNormal].backgroundImage;
			
		} else if (state == (UIControlStateDisabled | UIControlStateSelected | UIControlStateHighlighted)) {
			
			backgroundImage = [self _existingStateObjectForControlState:UIControlStateDisabled].backgroundImage;
			if (!backgroundImage)
				backgroundImage = [self _existingStateObjectForControlState:UIControlStateNormal].backgroundImage;
			
		}
	}
	return backgroundImage;
}

- (NSString *)currentTitle;
{
	return [self titleForState:[self state]];
}

- (UIColor  *)currentTitleColor;
{
	return [self titleColorForState:[self state]];
}

- (UIColor  *)currentTitleShadowColor;
{
	return [self titleShadowColorForState:[self state]];
}

- (UIImage  *)currentImage;
{
	return [self imageForState:[self state]];
}

- (UIImage  *)currentBackgroundImage;
{
	return [self backgroundImageForState:[self state]];
}

#pragma mark -
#pragma mark Subviews

- (UILabel *)titleLabel;
{
	if (!_titleView) {
		_titleView = [[UILabel alloc] initWithFrame:CGRectZero];
		[self addSubview:_titleView];
		[self setNeedsLayout];
	}
	return _titleView;
}

- (UIImageView *)imageView;
{
	if (!_imageView) {
		_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self addSubview:_imageView];
		[self setNeedsLayout];
	}
	return _imageView;
}

//TODO: warning these are under-implemented!!
- (CGRect)backgroundRectForBounds:(CGRect)bounds;
{
	return self.bounds;
}

- (CGRect)contentRectForBounds:(CGRect)bounds;
{
	return self.bounds;	
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect;
{
	return self.bounds;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect;
{
	return self.bounds;
}


#pragma mark -
#pragma mark Impl

- (void)setSelected:(BOOL)arg1;
{
	[super setSelected:arg1];
	[self _updateCurrentButtonState];
}

- (void)setEnabled:(BOOL)arg1;
{
	[super setEnabled:arg1];
	[self _updateCurrentButtonState];
}

- (void)setHighlighted:(BOOL)arg1;
{
	[super setHighlighted:arg1];
	[self _updateCurrentButtonState];
}


- (BOOL)beginTrackingWithEvent:(NSEvent *)event;
{
	BOOL begin = [super beginTrackingWithEvent:event];
	[self _updateCurrentButtonState];
	return begin;
}

- (BOOL)continueTrackingWithEvent:(NSEvent *)event;
{
	BOOL cont = [super continueTrackingWithEvent:event];
	[self _updateCurrentButtonState];
	return cont;
}

- (void)endTrackingWithEvent:(NSEvent *)event;
{
	[super endTrackingWithEvent:event];
	[self _updateCurrentButtonState];
}

- (void)cancelTrackingWithEvent:(NSEvent *)event;
{
	[super cancelTrackingWithEvent:event];
	[self _updateCurrentButtonState];
}

- (void)layoutSubviews;
{
	_backgroundView.frame = [self backgroundRectForBounds:self.bounds];
	CGRect contentRect = [self contentRectForBounds:self.bounds];
	_titleView.frame = [self titleRectForContentRect:contentRect];
	_imageView.frame = [self imageRectForContentRect:contentRect];
}

@end

//Internal object foo


@implementation UIButtonStateMutable
@synthesize title;
@synthesize titleColor;
@synthesize titleShadowColor;
@synthesize image;
@synthesize backgroundImage;
@end
