//
//  UIScrollKnob.h
//  UIKit
//
//  Created by Andrew Pouliot on 1/30/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIView.h"
#import "UIScrollView.h"

@interface UIScrollKnob : UIView {
@private
    UIScrollView *scrollView;
}

- (id)initWithScrollView:(UIScrollView *)inScrollView;

@end
