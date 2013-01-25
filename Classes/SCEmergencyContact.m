//
//  SCEmergencyNumber.m
//  safecell
//
//  Created by shail m on 6/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SCEmergencyContact.h"


@implementation SCEmergencyContact

@synthesize emergencyContactId;
@synthesize name;
@synthesize number;


- (void) dealloc {
	[name release];
	[number release];
	[super dealloc];
}


@end
