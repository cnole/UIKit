//
//  MouseEventView.h
//  RecreatingNSApplication
//
//  Created by Andrew Pouliot on 1/28/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MouseEventView : UIView {
	UIImageView *imageView;
	BOOL highlighted;	
}

@property (nonatomic, assign) id target;
@property (nonatomic) SEL action;

@end
