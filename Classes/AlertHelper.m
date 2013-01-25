//
//  AlertHelper.m
//  safecell
//
//  Created by Ben Scheirman on 4/21/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "AlertHelper.h"

void SimpleAlertOK(NSString *title, NSString *message) {
	SimpleAlert(title, message, @"OK");
}

void SimpleAlert(NSString *title, NSString *message, NSString *buttonText) {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:buttonText otherButtonTitles:nil];
	[alert show];
	[alert autorelease];
}