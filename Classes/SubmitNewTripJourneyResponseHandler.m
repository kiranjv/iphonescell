//
//  SubitNewTripJourneyResponseHandler.m
//  safecell
//
//  Created by shail m on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SubmitNewTripJourneyResponseHandler.h"
#import "SBJSON.h"
#import "SCTrip.h"
#import "SCTripJourney.h"
#import "SCWaypoint.h"
#import "TripRepository.h"
#import "WayPointsFileHelper.h"
#import "SCJourneyEvent.h"


@implementation SubmitNewTripJourneyResponseHandler

@synthesize jsonResponse;


-(void) process {
	
	SBJSON *jsonHelper = [[SBJSON alloc] init];	
	NSDictionary *reponseDict = [jsonHelper objectWithString:self.jsonResponse];
	[jsonHelper release];
	
	NSDictionary *tripDict = [reponseDict objectForKey:@"trip"];	
	SCTrip *trip = [SCTrip tripWithDictionary:tripDict];
	
	NSArray *journeysArray = [tripDict objectForKey:@"journeys"];
	
	/*
	 //Till the trip bug is solved.
	int lastJourneyIndex = [journeysArray count] - 1;
	NSDictionary *journeyDict = [journeysArray objectAtIndex:lastJourneyIndex];	
	 */
	
	NSDictionary *journeyDict = [journeysArray objectAtIndex:0];
	NSLog(@"journeyDict: %@", journeyDict);
	
	
	SCTripJourney *journey = [SCTripJourney journeyWithDict:journeyDict];
	
	TripRepository *tripRepository = [[TripRepository alloc] init];
	
	if ([tripRepository journeyExists:journey.journeyId]) {
		NSLog(@"Journey : %d exists. Not saving again.", journey.journeyId);
		[tripRepository release];
		return;
	} else {
		NSLog(@"Journey : %d doesnot exists. Saving...", journey.journeyId);
	}

	
	[journey loadCurrentWaypoints];	
	[journey calculateAndSetEstimatedSpeed];
	
	NSArray *journeyEventsArray = [journeyDict objectForKey:@"journey_events"];
	
	for (NSDictionary *eventDict in journeyEventsArray) {
		SCJourneyEvent *event = [SCJourneyEvent eventWithDictionary:eventDict];
		[journey.journeyEvents addObject:event];
	}
	
	
	[journey loadCurrentInterruptions];
	 
	
	
	[tripRepository saveTrip:trip];
	[tripRepository saveJourney:journey];
	
	for(SCWaypoint *waypoint in journey.waypoints) {
		[tripRepository saveWaypoint:waypoint];
	}
	
	for (SCJourneyEvent *event in journey.journeyEvents) {
		[tripRepository saveJourneyEvent:event];
	}
	
	for (SCInterruption *interruption in journey.interruptions) {
		[tripRepository saveInterruption:interruption];
	}
	
	[tripRepository release];
}

- (void) dealloc
{
	[jsonResponse release];
	[super dealloc];
}


@end
