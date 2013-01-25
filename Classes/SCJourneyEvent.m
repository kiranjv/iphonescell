//
//  SCJourneyEvent.m
//  safecell
//
//  Created by shail m on 5/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SCJourneyEvent.h"
#import "JSONHelper.h"
#import "ServerDateFormatHelper.h"

@implementation SCJourneyEvent

@synthesize eventId;
@synthesize journeyId;
@synthesize points;

@synthesize near;
@synthesize description;
@synthesize timestamp;

static NSString *TIMESTAMP = @"timestamp";
static NSString *POINTS = @"points";
static NSString *EVENT_ID = @"id";
static NSString *JOURNEY_ID = @"journey_id";
static NSString *NEAR = @"near";
static NSString *DESCRIPTION = @"description";

// static NSString *INTERRUPTION_DESCRIPTION = @"Interruption";


+(SCJourneyEvent *) eventWithJSON: (NSString *) json {
	NSDictionary *dict = [JSONHelper dictFromString:json];
	return [SCJourneyEvent eventWithDictionary:dict];
}

+(SCJourneyEvent *) eventWithDictionary: (NSDictionary *) dict {
	
	SCJourneyEvent *event = [[[SCJourneyEvent alloc] init] autorelease];
	
	event.eventId = [[dict objectForKey:EVENT_ID] intValue];
	event.journeyId = [[dict objectForKey:JOURNEY_ID] intValue];
	event.points = [[dict objectForKey:POINTS] floatValue];
	
	event.near = [dict objectForKey:NEAR];
	event.description = [dict objectForKey:DESCRIPTION];
	
	NSString *timestamp = [dict objectForKey:TIMESTAMP];
	
	event.timestamp = [ServerDateFormatHelper dateFormServerString:timestamp];
	
	return event;
}


- (void) dealloc {
	[near release];
	[description release];
	[timestamp release];
	[super dealloc];
}

-(BOOL) isInterruption {
//if ([self.description isEqualToString:INTERRUPTION_DESCRIPTION]) {
//		return YES;
//	} else {
//		return NO;
//	}
	
	if (self.points < 0) {
		return YES;
	} else {
		return NO;
	}

}


@end
