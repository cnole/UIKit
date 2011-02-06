//
//  TweetListViewController.m
//  UIKit Demo
//
//  Created by Andrew Pouliot on 2/6/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "TweetListViewController.h"


@implementation TweetListViewController

- (void)viewDidLoad;
{
	tableView = [[UITableView alloc] initWithFrame:CGRectZero];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.backgroundColor = [UIColor brownColor];
	tableView.contentSize = (CGSize) {.height = 1000.0f};
	[self.view addSubview:tableView];
	
	tableView.dataSource = self;
	tableView.delegate = self;
	[tableView reloadData];

}

- (void)dealloc {
    [tableView release];
    [super dealloc];
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;
{
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	NSString *reuseIdentifier = @"Reuse";
	UITableViewCell *cell = [inTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
	}
	
	cell.textLabel.text = [NSString stringWithFormat:@"Foo bar %d", indexPath.row];
	
	return cell;
}



@end
