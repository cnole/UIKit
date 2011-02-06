//
//  UIViewController.h
//  UIKit
//
//  Created by Andrew Pouliot on 2/6/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIView;
@interface UIViewController : NSResponder {
    UIView *view;
}

- (BOOL)isViewLoaded;

//Override this to customize view loading
- (void)loadView;
- (void)viewDidLoad;

@property (nonatomic, retain) UIView *view;

//This is the designated initializer for now
- (id)init;

@end
