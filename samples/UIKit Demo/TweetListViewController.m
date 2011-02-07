//
//  TweetListViewController.m
//  UIKit Demo
//
//  Created by Andrew Pouliot on 2/6/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "TweetListViewController.h"

#import "ASIHTTPRequest.h"
#import "CJSONDeserializer.h"

@interface TweetListViewController ()
@property (nonatomic, copy) NSArray *tweets;
- (void)executeSearchForQuery:(NSString *)inQuery;
@end

@implementation TweetListViewController
@synthesize tweets;

- (void)viewDidLoad;
{
	tableView = [[UITableView alloc] initWithFrame:CGRectZero];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.backgroundColor = [UIColor brownColor];
	tableView.contentSize = (CGSize) {.height = 1000.0f};
	tableView.rowHeight = 100.f;
	[self.view addSubview:tableView];
	
	tableView.dataSource = self;
	tableView.delegate = self;
	[tableView reloadData];
	
	[self executeSearchForQuery:@"UIKit"];

}

- (NSString*)encodeURL:(NSString *)string
{
	NSString *newString = NSMakeCollectable([(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) autorelease]);
	if (newString) {
		return newString;
	}
	return @"";
}




- (void)executeSearchForQuery:(NSString *)inQuery;
{
	NSString *urlString = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@", [self encodeURL:inQuery]];
	ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
	
	[request setCompletionBlock:^{
		NSError *parseError = nil;
		NSDictionary *responseDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:[request responseData] error:&parseError];
		
		NSArray *results = [responseDictionary objectForKey:@"results"];
		
		NSLog(@"Recieved %d results", (int)results.count);
		
		self.tweets = results;
		[tableView reloadData];
		
	}];
	[request setFailedBlock:^{
		NSLog(@"Twitter API error: %@", [request error]);
		
	}];
	[request startAsynchronous];
	
}

- (void)dealloc {
    [tableView release];
    [super dealloc];
}


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;
{
	return tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	NSString *reuseIdentifier = @"Reuse";
	UITableViewCell *cell = [inTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
	if (!cell) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
		cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
		cell.textLabel.font = [NSFont fontWithName:@"Helvetica Neue Bold" size:14];
	}
	
	NSDictionary *tweet = [tweets objectAtIndex:indexPath.row];
	cell.textLabel.text = [tweet objectForKey:@"text"];
	
	return cell;
}



@end
