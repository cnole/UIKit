//
//  UIScrollView.h
//  UIKit
//
//  Created by Shaun Harrison on 4/30/09.
//  Copyright 2009 enormego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKitDefines.h>
#import <UIKit/UIView.h>

@interface UIScrollView : UIView {
@private
	CGSize _contentSize;
	CGPoint _contentOffset;
	UIView *contentView;
	UIView *scroller;
}

@property(nonatomic,assign) CGSize contentSize;
@property(nonatomic,assign) CGPoint contentOffset;

@property (nonatomic, readonly, retain) UIView *contentView;

@end