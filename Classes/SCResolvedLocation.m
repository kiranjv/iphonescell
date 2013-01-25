//
//  SCResolvedLocations.m
//  safecell
//
//  Created by shail m on 6/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SCResolvedLocation.h"


@implementation SCResolvedLocation

@synthesize resolvedLocationId;

@synthesize latitude;
@synthesize longitude;

@synthesize sublocality;
@synthesize city;
@synthesize state;
@synthesize zipCode;


- (void) dealloc {
	[sublocality release];
	[city release];
	[state release];
	[zipCode release];
	[super dealloc];
}


@end
