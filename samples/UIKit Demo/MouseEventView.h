//
//  MouseEventView.h
//  RecreatingNSApplication
//
//  Created by Andrew Pouliot on 1/28/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MouseEventView : UIView {
	BOOL selected;
}

- (void)mouseDown:(NSEvent *)inEvent;
- (void)mouseUp:(NSEvent *)inEvent;

@end
