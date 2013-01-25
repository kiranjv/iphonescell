//
//  SCTrip.m
//  safecell
//
//  Created by Ben Scheirman on 5/10/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "SCTrip.h"


@implementation SCTrip

@synthesize tripId, name, trips;

+(SCTrip *) tripWithDictionary: (NSDictionary *) dict {
	SCTrip * trip = [[[SCTrip alloc] init] autorelease];
	
	trip.tripId = [[dict objectForKey:@"id"] intValue];
	trip.name = [dict objectForKey:@"name"];
	
	return trip;
}

- (void) dealloc {
	[name release];
	[trips release];
	[super dealloc];
}


@end
