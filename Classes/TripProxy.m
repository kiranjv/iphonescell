//
//  TripProxy.m
//  safecell
//
//  Created by Mobisoft Infotech on 7/19/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "TripProxy.h"
#import "JSONHelper.h"
#import "SCTrip.h"
#import "SCTripJourney.h"
#import "SCJourneyEvent.h"


@implementation TripProxy

@synthesize delegate;

-(void) configureGetTripsFailureTrackerTracker: (int) profileId apiKey:(NSString *) apiKey {
	if (getTripsFailureTracker) {
		[getTripsFailureTracker release];
		getTripsFailureTracker = nil;
	}
	getTripsFailureTracker = [[NetworkCallFailureTracker alloc] initWithRetriesAllowed:3];
	
	NSDictionary *requestInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:profileId], @"profileId", apiKey, @"apiKey", nil];
	getTripsFailureTracker.requestInfo = requestInfo;
	[requestInfo release];
	
	[getTripsFailureTracker trackResponseCodesWithTotalCount:1, 0];
	[getTripsFailureTracker addTarget:self startRequestSelector:@selector(startGetTripsForProfileRequest:) requestFinallyFailedSelector:@selector(getTripsForProfileRequestFailed:)];
}

-(void) startGetTripsForProfileRequest: (NSDictionary *) requestInfo {
	
	NSNumber *profileId = [requestInfo objectForKey:@"profileId"];
	NSString *apiKey = [requestInfo objectForKey:@"apiKey"];
	
	NSString *url = [NSString stringWithFormat:@"%@/trips?profile_id=%d", [Config baseURL], [profileId intValue]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	
	[request setTimeOutSeconds:60];
	[request addRequestHeader:@"x-api-key" value:apiKey];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	
	request.userInfo = [NSDictionary dictionaryWithObject:@"getTripsForProfile" forKey:@"operation"];
	[request setDelegate:self];
	
	[request setRequestMethod:@"GET"];
	
	NSLog(@"Get Trips: %@", url);
	NSLog(@"x-api-key: %@", apiKey);
	NSLog(@"Content-Type: application/json");
	
	[request startAsynchronous];
}

-(void) getTripsForProfileRequestFailed: (ASIHTTPRequest *) request {
	if(self.delegate && [self.delegate respondsToSelector:@selector(requestFailed:)]) {
		[self.delegate requestFailed: request];
	}	
}

-(void) getTripsForProfile: (int) profileId apiKey:(NSString *) apiKey{
	[self configureGetTripsFailureTrackerTracker:profileId  apiKey:(NSString *) apiKey];
	[getTripsFailureTracker start];
}


-(void) handleGetTripsForProfileResponse: (ASIHTTPRequest *) request {
	NSMutableArray *trips = [[NSMutableArray alloc] init];
	NSArray *tripsDicts = [JSONHelper arrayFromString:[request responseString]];
	
	for (NSDictionary *container in tripsDicts) {
		NSDictionary *tripDict = [container objectForKey:@"trip"];
		SCTrip *trip = [SCTrip tripWithDictionary:tripDict];
		[trips addObject:trip];
		
		NSArray *journeysArray = [tripDict objectForKey:@"journeys"];
		
		NSMutableArray *journeys = [[NSMutableArray alloc] initWithCapacity:journeysArray.count];
		
		for (NSDictionary *journeyDict in journeysArray) {
			SCTripJourney *journey = [SCTripJourney journeyWithDict:journeyDict];
			
			NSArray *journeyEventsArray = [journeyDict objectForKey:@"journey_events"];
			
			for (NSDictionary *eventDict in journeyEventsArray) {
				SCJourneyEvent *event = [SCJourneyEvent eventWithDictionary:eventDict];
				[journey.journeyEvents addObject:event];
			}
			
			[journeys addObject:journey];
		}
		
		trip.trips = journeys;
	}
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(receivedTrips:)]) {
		[self.delegate receivedTrips: trips];
	}
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate

-(void) requestFinished:(ASIHTTPRequest *)request {
	NSLog(@"Retrieved %d bytes from the request for %@", [[request responseData] length], request.url);
	NSLog(@"%@", [request responseString]);
	
	NSDictionary *userInfo = [request userInfo];
	NSString *operation = [userInfo objectForKey:@"operation"];
	
	if(request.responseStatusCode != 200) {
		[self requestFailed:request];	
		return;
		
	}
	
	
	if([operation isEqualToString:@"getTripsForProfile"]) {
		[self handleGetTripsForProfileResponse:request];
		return;
	}
}

-(void) requestFailed:(ASIHTTPRequest *)request {
	NSLog(@"REQUEST FAILED: %@", request.url);
	NSDictionary *userInfo = [request userInfo];
	NSString *operation = [userInfo objectForKey:@"operation"];
	NSLog(@"OPERATION: %@", operation);
	NSError *error = [request error];
	if (error) {
		NSLog(@"ERROR: %@", [request.error localizedDescription]);
	}
	
	if ([operation isEqualToString:@"getTripsForProfile"]) {
		[getTripsFailureTracker failedForOnce:request];
	}
}

@end
