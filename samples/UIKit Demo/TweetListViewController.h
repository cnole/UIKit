//
//  TweetListViewController.h
//  UIKit Demo
//
//  Created by Andrew Pouliot on 2/6/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *tableView;
	
	NSArray *tweets;
}

@end
