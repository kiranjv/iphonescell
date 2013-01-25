//
//  ReachabilityDelegate.m
//  safecell
//
//  Created by Mobisoft Infotech on 8/4/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "ReachabilityChecker.h"


@implementation ReachabilityChecker

@synthesize netStatus;

- (void) updateStatusWithReachability: (Reachability*) curReach {
	netStatus = [curReach currentReachabilityStatus];
}

-(void) checkRechability {
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	
	hostReach = [[Reachability reachabilityWithHostName:@"my.safecellapp.com"] retain];
	[hostReach startNotifer];
	[self updateStatusWithReachability:hostReach];
}


//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateStatusWithReachability: curReach];
}

- (id) init {
	self = [super init];
	if (self != nil) {
		[self checkRechability];
	}
	return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"kNetworkReachabilityChangedNotification" object:nil];
	[hostReach release];
	[super dealloc];
}

-(void) showNoNetworkMessageForApp: (NSString *) appName {
		NSString *message = [NSString stringWithFormat:@"%@ requires Internet connection to function. Please enable the Internet connection and restart the app again.", appName];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet Connection Required" message:message delegate:self cancelButtonTitle:@"Quit" otherButtonTitles:nil];
		[alert show];
		[alert release];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	exit(0);
}

@end
