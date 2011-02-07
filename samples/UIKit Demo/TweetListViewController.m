//
//  TweetListViewController.m
//  UIKit Demo
//
//  Created by Andrew Pouliot on 2/6/11.
//  Copyright 2011 Darknoon. All rights reserved.
//

#import "TweetListViewController.h"

#import "MouseEventView.h"

#import "ASIHTTPRequest.h"
#import "CJSONDeserializer.h"

@interface TweetListViewController ()
@property (nonatomic, copy) NSArray *tweets;
- (void)executeSearchForQuery:(NSString *)inQuery;
- (void)refresh;
@end

@implementation TweetListViewController
@synthesize tweets;

- (void)dealloc {
    [tableView release];
    [super dealloc];
}


- (void)viewDidLoad;
{
	searchString = @"UIKit";
	
	self.view.backgroundColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
	
	//Use this to set up views, which will be autoresized later
	self.view.frame = (CGRect) {
		.size.height = 400.f,
		.size.width = 400.f,
	};
	
	tableView = [[UITableView alloc] initWithFrame:(CGRect) {
		.origin.y = 50.f,
		.size.height = 350.f,
		.size.width = 400.f,
	}];
	tableView.layer.masksToBounds = YES;
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.backgroundColor = [UIColor brownColor];
	tableView.contentSize = (CGSize) {.height = 1000.0f};
	tableView.rowHeight = 100.f;
	[self.view addSubview:tableView];
	
	tableView.dataSource = self;
	tableView.delegate = self;
	[tableView reloadData];
	
	MouseEventView * mouseEventView = [[[MouseEventView alloc] initWithFrame:(CGRect) {
		.origin.x = 400.f - 178.f,
		.size.width = 178.f,
		.size.height = 50.f,
	}] autorelease];
	mouseEventView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	[mouseEventView setTarget:self];
	[mouseEventView setAction:@selector(refresh)];
	[self.view addSubview:mouseEventView];
	
	UILabel *descriptionLabel = [[[UILabel alloc] initWithFrame:(CGRect) {
		.origin.x = 10.f,
		.size.width = 200.f,
		.size.height = 50.f,
	}] autorelease];
	[self.view addSubview:descriptionLabel];
	descriptionLabel.text = [NSString stringWithFormat:@"Tweets about \"%@\"", searchString];
	descriptionLabel.backgroundColor = [UIColor clearColor];
	descriptionLabel.font = [UIFont fontWithName:@"Helvetica Neue Bold" size:18.f];
	descriptionLabel.textColor = [UIColor whiteColor];
	
	[self refresh];
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

- (void)refresh;
{
	[self executeSearchForQuery:searchString];
	self.tweets = nil;
	[tableView reloadData];
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
