//
//  WayPointFilter.m
//  safecell
//
//  Created by shail m on 6/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WaypointFilter.h"
#import "UnitUtils.h"

const float kRecordingTimeInterval = 5;
const float kErrantWaypointCriteriaSpeed = 200; //mph

static int rejected = 0;
static int schoolSignificant = 0;

@implementation WaypointFilter

@synthesize lastProcessedWaypoint;
@synthesize lastApprovedWaypoint;



- (id) init {
	self = [super init];
	if (self != nil) {
		tripRepository = [[TripRepository alloc] init];
		threwAwayFirstWaypoint = NO;
	}
	return self;
}


-(BOOL) isErrantWaypoint:(SCWaypoint *) waypoint {
	if(lastProcessedWaypoint == nil) {
		return NO;
	}
	
	float distanceTravelledInKm = [SCWaypoint distanceFromWayPoint:lastProcessedWaypoint toWayPoint:waypoint];
	distanceTravelledInKm = fabs(distanceTravelledInKm);
	
	float distanceTravelledInMiles = [UnitUtils kilometersToMiles:distanceTravelledInKm];
	
	float distanceTravelledInOneSec = (kErrantWaypointCriteriaSpeed / 3600);
	float distanceTravelledRecordingInterval = distanceTravelledInOneSec * kRecordingTimeInterval;
	
	if (distanceTravelledInMiles > distanceTravelledRecordingInterval) {
		return YES;
	} else {
		return NO;
	}
}

-(SCWaypoint *) filterWaypoint: (SCWaypoint *) waypoint {
	
	if (!threwAwayFirstWaypoint) {
		threwAwayFirstWaypoint = YES;
		NSLog(@"Threw away firstwaypoint");
		return nil;
	}
	
	if (self.lastProcessedWaypoint == nil) { //First call to the method
		self.lastProcessedWaypoint = waypoint;
		self.lastApprovedWaypoint = waypoint;		
		return waypoint;
	}
		
	SCWaypoint *waypointToReturn = nil;
	
	if (![self isErrantWaypoint:waypoint]) {
		BOOL schoolSignificantPoint = [tripRepository isSchoolProximitySignificant:waypoint];
		
		if (schoolSignificantPoint) {			
			waypointToReturn = waypoint;
			schoolSignificant++;
		} else {			
			double timeElapsed = [waypoint.timeStamp timeIntervalSinceDate:self.lastApprovedWaypoint.timeStamp];
			
			if (timeElapsed > kRecordingTimeInterval) {
				waypointToReturn = waypoint;
			} else {
				//NSLog(@"Skipped waypoint since %f has not elapsed: %f, %f", kRecordingTimeInterval, waypoint.latitude, waypoint.longitude);
			}			
		}
		
	} else {
		//NSLog(@"Filtered as Errant: %f, %f", waypoint.latitude, waypoint.longitude);
	}
	
	self.lastProcessedWaypoint = waypoint;
	
	if (waypointToReturn == nil) {
		rejected++;
	} else {
		self.lastApprovedWaypoint = waypoint;
	}
	
	//NSLog(@"Total Rejected: %d Total School Significant: %d", rejected, schoolSignificant);
	return waypointToReturn;
}

- (void) dealloc {
	[tripRepository release];
	[lastProcessedWaypoint release];
	[lastApprovedWaypoint release];

	[super dealloc];
}


@end
