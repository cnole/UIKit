//
//  UIImageView.h
//  UIKit
//
//  Created by Andrew Pouliot on 1/28/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import <UIKit/UIView.h>
#import <UIKit/UIImage.h>

@interface UIImageView : UIView {
	UIImage *image;
}

@property (nonatomic, retain) UIImage *image;

- (id)initWithImage:(UIImage *)inImage;


@end
