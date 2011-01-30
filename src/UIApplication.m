//
//  UIApplication.m
//  UIKit
//
//  Created by Jason C. Martin on 2/8/10.
//  Copyright 2010 New Media Geekz. All rights reserved.
//

#import "UIApplication.h"

#import <QuartzCore/QuartzCore.h>

NSString *const UIApplicationDidFinishLaunchingNotification = @"UIApplicationDidFinishLaunchingNotification";
NSString *const UIApplicationDidBecomeActiveNotification = @"UIApplicationDidBecomeActiveNotification";

@implementation UIApplication

@synthesize applicationIconBadgeNumber, shouldTerminateAfterLastWindowClosed, dockMenu, delegate;

static UIApplication *sharedApplication = nil;

+ (void)initialize {
	if([self class] == [UIApplication class]) {
		[[NSApplication sharedApplication] setDelegate:[UIApplication sharedApplication]];
	}
}

+ (UIApplication *)sharedApplication
{
    @synchronized(self)
    {
        if (sharedApplication == nil)
        {
            sharedApplication = [[self alloc] init];
        }
    }
    
    return sharedApplication;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (sharedApplication == nil)
        {
            sharedApplication = [super allocWithZone:zone];
            return sharedApplication;
        }
    }
    
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (void)release
{
}

- (id)autorelease
{
    return self;
}

- (id)init {
	self = [super init];
	if(self) {
		NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
		
		if([info valueForKey:@"CFBundleURLTypes"]) {
			[[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(getUrl:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
		}
		
		shouldTerminateAfterLastWindowClosed = NO;
		dockMenu = nil;
		
		applicationIconBadgeNumber = 0;
	}
	
	return self;
}

- (void)run
{
	if ([delegate respondsToSelector:@selector(applicationDidFinishLaunching:)])
		[delegate applicationDidFinishLaunching:self];

	[[NSNotificationCenter defaultCenter]
	 postNotificationName:NSApplicationDidFinishLaunchingNotification
	 object:NSApp];

	[[NSNotificationCenter defaultCenter]
	 postNotificationName:UIApplicationDidFinishLaunchingNotification
	 object:self];
	
	shouldKeepRunning = YES;
	do
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

		[CATransaction begin];
		[CATransaction setDisableActions:YES];
		
		NSEvent *event = [NSApp
						  nextEventMatchingMask:NSAnyEventMask
						  untilDate:[NSDate distantFuture]
						  inMode:NSDefaultRunLoopMode
						  dequeue:YES];
		
		[self sendEvent:event];
		
		[CATransaction commit];
		
		[pool release];
	} while (shouldKeepRunning);
}

- (void)terminate:(id)sender
{
	shouldKeepRunning = NO;
}


- (void)setApplicationIconBadgeNumber:(NSInteger)num {
	if(num == applicationIconBadgeNumber)
		return;
	
	applicationIconBadgeNumber = num;
	
	if(applicationIconBadgeNumber != 0) {
		[[[NSApplication sharedApplication] dockTile] setBadgeLabel:[NSString stringWithFormat:@"%i", applicationIconBadgeNumber]];
	} else {
		[[[NSApplication sharedApplication] dockTile] setBadgeLabel:nil];
	}
}

- (void)sendEvent:(UIEvent *)event {
	[[NSApplication sharedApplication] sendEvent:event];
}

- (void)hide:(id)sender {
	[[NSApplication sharedApplication] hide:sender];
}

- (void)unhide:(id)sender {
	[[NSApplication sharedApplication] unhide:sender];
}

- (void)hideOtherApplications:(id)sender {
	[[NSApplication sharedApplication] hideOtherApplications:sender];
}

- (void)unhideAllApplications:(id)sender {
	[[NSApplication sharedApplication] unhideAllApplications:sender];
}

- (void)replyToApplicationShouldTerminate:(BOOL)shouldTerminate {
	[[NSApplication sharedApplication] replyToApplicationShouldTerminate:shouldTerminate];
}

- (BOOL)openURL:(NSURL *)url {
	return [[NSWorkspace sharedWorkspace] openURL:url];
}

- (BOOL)canOpenURL:(NSURL *)url {
	FSRef eh;
	
	return LSGetApplicationForURL((CFURLRef)url, kLSRolesAll, &eh, NULL) != kLSApplicationNotFoundErr;
}

- (void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
	NSString *url = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
	
	if([_delegate respondsToSelector:@selector(application:handleOpenURL:)]) {
		[_delegate application:self handleOpenURL:[NSURL URLWithString:url]];
	}
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return shouldTerminateAfterLastWindowClosed;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	if([_delegate respondsToSelector:@selector(applicationDidFinishLaunching:)]) {
		[_delegate applicationDidFinishLaunching:self];
	}
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if ([[NSApplication sharedApplication] respondsToSelector:[anInvocation selector]])
        [anInvocation invokeWithTarget:[NSApplication sharedApplication]];
    else
        [super forwardInvocation:anInvocation];
}

@end


int UIApplicationMain(int argc, char *argv[], NSString *principalClassName, NSString *delegateClassName)
{	
	if (principalClassName || delegateClassName) {
		NSLog(@"principalClassName or delegateClassName UNIMPLEMENTED in UIApplicationMain");
	};
	
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	Class principalClass =
	NSClassFromString([infoDictionary objectForKey:@"NSPrincipalClass"]);
	NSApplication *applicationObject = [principalClass sharedApplication];
	
	NSString *mainNibName = [infoDictionary objectForKey:@"NSMainNibFile"];
	NSNib *mainNib = [[NSNib alloc] initWithNibNamed:mainNibName bundle:[NSBundle mainBundle]];
	[mainNib instantiateNibWithOwner:NSApp topLevelObjects:nil];
	
	if ([applicationObject respondsToSelector:@selector(run)])
	{
		[applicationObject
		 performSelectorOnMainThread:@selector(run)
		 withObject:nil
		 waitUntilDone:YES];
	}
	
	[mainNib release];
	
	return 0;
}
