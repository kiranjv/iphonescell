//
//  Trip.m
//  safecell
//
//  Created by shail on 05/05/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "SCTripJourney.h"
#import "WayPointsFileHelper.h"
#import "SCWaypoint.h"
#import "UnitUtils.h"
#import "WayPointsFileHelper.h"
#import "SCJourneyEvent.h"
#import "ServerDateFormatHelper.h"
#import "SBJSON.h"
#import "InterruptionsFileHelper.h"
#import "TripRepository.h"
#import "UserDefaults.h"
#import "AppDelegate.h"

#define ORIGINATOR_TOKEN @"originator_token"

@implementation SCTripJourney

@synthesize tripId;
@synthesize journeyId;
@synthesize points;
@synthesize tripName;
@synthesize miles;
@synthesize tripDate;	
@synthesize estimatedSpeed;

@synthesize waypoints;
@synthesize interruptions;


- (id) init
{
	self = [super init];
	if (self != nil) {
		self.journeyId = kJourneyIdNotPersisted;
		self.points = 0;
		self.miles = 0;
		self.estimatedSpeed = 0;
		waypoints = [[NSMutableArray alloc] init];
		interruptions = [[NSMutableArray alloc] init];
		journeyEvents = nil;
	}
	return self;
}

-(id) initWithCurrentWayPointsAndInterruptions {
	self = [super init];
	if (self != nil) {
		self.journeyId = kJourneyIdNotPersisted;
		self.points = 0;
		self.estimatedSpeed = 0;
		waypoints = [[NSMutableArray alloc] init];
		
		if([WayPointsFileHelper wayPointsFileExists]) {
			BOOL firstIteration = YES;
			
			WayPointsFileHelper *wayPointsFileHelper = [[WayPointsFileHelper alloc] initWithNewFile:NO];
			SCWaypoint * waypoint;
			SCWaypoint * previousWayPoint = nil;
			
			float totalDistanceInKilometers = 0;
			
			int i = 0;
			
			while ((waypoint = [wayPointsFileHelper readNextWayPoint]) != nil) {
				[waypoints addObject:waypoint];
				
				if(firstIteration) {					
					self.tripDate = waypoint.timeStamp;
                    NSLog(@"Trip date: %@ ",self.tripDate);
					firstIteration = NO;
				}
				
				if(previousWayPoint != nil) {
					float distanceInKilometers = [SCWaypoint distanceFromWayPoint:previousWayPoint toWayPoint:waypoint];
					
					/*
					NSLog(@"==========================================");
					NSLog(@"waypoint1: %.10f, %.10f", previousWayPoint.latitude, previousWayPoint.longitude);
					NSLog(@"waypoint2: %.10f, %.10f", waypoint.latitude, waypoint.longitude);
					NSLog(@"distanceInKilometers: %.10f", distanceInKilometers);
					NSLog(@"==========================================");
					*/
					
					distanceInKilometers = fabs(distanceInKilometers);
					totalDistanceInKilometers += distanceInKilometers;
					
					// NSLog(@"%d : %f", i, distanceInKilometers);
					i++;
				}
				
				previousWayPoint = waypoint;
			}
			
			self.miles = [UnitUtils kilometersToMiles:totalDistanceInKilometers];
			
			if(self.tripDate) {
				NSTimeInterval tripDuration = [previousWayPoint.timeStamp timeIntervalSinceDate:self.tripDate];
				
				if(tripDuration > 0) {
					self.estimatedSpeed = self.miles / (tripDuration / 3600);
				} else {
					self.estimatedSpeed = 0;
				}
				
			}
			
			[wayPointsFileHelper release];			
			
			interruptions = [[NSMutableArray alloc] init];
			[self loadCurrentInterruptions];
			
			journeyEvents = [[NSMutableArray alloc] init];
		}
	}
	return self;
}

-(void) loadCurrentWaypoints {
	WayPointsFileHelper *wayPointsFileHelper = [[WayPointsFileHelper alloc] initWithNewFile:NO];
	
	SCWaypoint *wayPoint = nil;
	
	while ((wayPoint = [wayPointsFileHelper readNextWayPoint]) != nil) {
		wayPoint.journeyId = self.journeyId;
		[self.waypoints addObject:wayPoint];
	}
	
	[wayPointsFileHelper release];
}

-(void) loadCurrentInterruptions {
	InterruptionsFileHelper *interruptionsFileHelper = [[InterruptionsFileHelper alloc] initWithNewFile:NO];
	
	SCInterruption *interruption = nil;
	
	while ((interruption = [interruptionsFileHelper readNextInterruption]) != nil) {
		interruption.journeyId = self.journeyId;
		[self.interruptions addObject:interruption];
        NSLog(@"current intrruptions = %@",self.interruptions);
	}
	
	[interruptionsFileHelper release];
}

-(void) calculateAndSetEstimatedSpeed {
		
	float totalDistanceInKilometers = 0;
	SCWaypoint *previousWaypoint = nil;
	
	int i = 0;
	
	for(SCWaypoint *waypoint in self.waypoints) {
		if(previousWaypoint != nil) {
			float distanceInKilometers = [SCWaypoint distanceFromWayPoint:previousWaypoint toWayPoint:waypoint];
			
			distanceInKilometers = fabs(distanceInKilometers);
			totalDistanceInKilometers += distanceInKilometers;
			
			// NSLog(@"%d : %f", i, distanceInKilometers);
			i++;
		}
		
		previousWaypoint = waypoint;
	}
		
	self.miles = [UnitUtils kilometersToMiles:totalDistanceInKilometers];
	
	if(self.tripDate) {
		NSTimeInterval tripDuration = [previousWaypoint.timeStamp timeIntervalSinceDate:self.tripDate];
		
		if(tripDuration > 0) {
			self.estimatedSpeed = self.miles / (tripDuration / 3600);
		} else {
			self.estimatedSpeed = 0;
		}
		
	}
}

+(SCTripJourney *) journeyWithDict: (NSDictionary *) dict {
	SCTripJourney *journey = [[[SCTripJourney alloc] init] autorelease];
	
	journey.journeyId = [[dict objectForKey:@"id"] intValue];
	journey.tripId = [[dict objectForKey:@"trip_id"] intValue];
	
	id pointsValue = [dict objectForKey:@"total_points"];
	
	if(pointsValue != [NSNull null]) {
		journey.points = [pointsValue intValue];
	} else {
		journey.points = 0;
	}
	
	journey.miles = [[dict objectForKey:@"miles_driven"] floatValue];
	
	NSString *startedAtDateStr = [dict objectForKey:@"started_at"];
	
	journey.tripDate = [ServerDateFormatHelper dateFormServerString:startedAtDateStr];
	
	return journey;
}

- (void)dealloc {
	[tripName release];
	[tripDate release];
	
	// NSLog(@"Waypoints: %d", [waypoints retainCount]);
	// NSLog(@"interruptions: %d", [interruptions retainCount]);
	// NSLog(@"journeyEvents: %d", [journeyEvents retainCount]);
	
	[waypoints release];
	[interruptions release];
	[journeyEvents release];
	
	[super dealloc];
}

-(NSMutableArray *) journeyEvents {
	if (journeyEvents == nil) {
		TripRepository *tripRepository = [[TripRepository alloc] init];
		self.journeyEvents = [tripRepository journeyEvents:self.journeyId];
		[tripRepository release];
	}
	
	return journeyEvents;
}

-(void) setJourneyEvents: (NSMutableArray *) events {
	[events retain];
	[journeyEvents release];
	journeyEvents = events;
}

-(NSString *) milesString {
	char buffer[30];
	sprintf (buffer, "%.2f", self.miles);
	NSString *milesStr = [NSString stringWithFormat:@"%@ miles", [NSString stringWithUTF8String:buffer]];
	return milesStr;
}

-(NSString *) estimatedSpeedString {
	char buffer[30];
	sprintf (buffer, "%.2f", self.estimatedSpeed);
	NSString *speedStr = [NSString stringWithFormat:@"%@ mph", [NSString stringWithUTF8String:buffer]];
	return speedStr;
}

-(NSMutableArray *) waypointsDictsArr {
	int totalWaypoints = [self.waypoints count];	
	NSMutableArray * waypointsArr = [[[NSMutableArray alloc] initWithCapacity:totalWaypoints] autorelease];
	
	for(SCWaypoint *waypoint in self.waypoints) {
		[waypointsArr addObject:[waypoint asDictForServer]];
	}
	
	return waypointsArr;	
}

-(NSMutableArray *) interruptionDictsArr {
	int totalInterruptions = [self.interruptions count];	
	NSMutableArray * interruptionsArr = [[[NSMutableArray alloc] initWithCapacity:totalInterruptions] autorelease];
	
	for(SCInterruption *interruption in self.interruptions) {
		[interruptionsArr addObject:[interruption dictionaryRepresentationWithOptionalProperties: NO]];
	}
	
	return interruptionsArr;
}

-(NSString *) JSONRepresentation  {
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
   
	NSMutableDictionary *tripDict = [[NSMutableDictionary alloc] init];	
	
	[tripDict setObject:self.tripName forKey:@"name"];
	// Newly Added Values
    
    if (appDelegate.is_abandon_trip) {
        [tripDict setObject:[NSNumber numberWithBool:1] forKey:@"is_abandon_trip"];
    }
    else{
        
        [tripDict setObject:[NSNumber numberWithBool:0] forKey:@"is_abandon_trip"];
    }
    
//    [tripDict setObject:@"41218" forKey:@"manager_id"];
    //-------------------
	
	NSMutableArray *journeys_attributes = [[NSMutableArray alloc] init];
	[tripDict setObject:journeys_attributes forKey:@"journeys_attributes"];
	
	NSMutableDictionary *waypointDataDict  = [[NSMutableDictionary alloc] init];
	
	
	NSMutableArray * waypointDicts = [self waypointsDictsArr];
	
	[waypointDataDict setObject:waypointDicts forKey:@"waypoints_attributes"];
	[waypointDataDict setObject:@"null" forKey:@"total_points"];		
	[waypointDataDict setObject:[NSNumber numberWithFloat:self.miles] forKey:@"miles_driven"];
	
	NSString* startedAt = [ServerDateFormatHelper formattedDateForJSON:self.tripDate];
	[waypointDataDict setObject:startedAt forKey:@"started_at"];
	
	int totalWaypoints = [self.waypoints count];	
	SCWaypoint *lastWaypoint = [self.waypoints objectAtIndex:(totalWaypoints- 1)];
	NSString* endedAt = [ServerDateFormatHelper formattedDateForJSON:lastWaypoint.timeStamp];
	[waypointDataDict setObject:endedAt forKey:@"ended_at"];
	
	NSString *tripGUID = [UserDefaults valueForKey:kTripGUID];
	NSLog(@"tripGUID = %@",tripGUID);
	if ((tripGUID != nil) && ![@"" isEqualToString:tripGUID]) {
		[waypointDataDict setObject:tripGUID forKey:ORIGINATOR_TOKEN];
	}
	
	[journeys_attributes addObject:waypointDataDict];
	
		
	NSMutableArray * interruptionDicts = [self interruptionDictsArr];
    
    NSLog(@"interruptionDicts = %@",interruptionDicts);

	[waypointDataDict setObject:interruptionDicts forKey:@"interruptions_attributes"];
		
	/*
	 NSMutableDictionary *interruptionsDataDict = [[NSMutableDictionary alloc] init];
	 [interruptionsDataDict setObject:interruptionDicts forKey:@"interruptions_attributes"];
	
	//Commented out till server APIs are modified.
	[journeys_attributes addObject:interruptionsDataDict];	
	*/
	
	NSMutableDictionary * parentDict = [[NSMutableDictionary alloc] init];
	
	[parentDict setObject:tripDict forKey:@"trip"];
	
	SBJSON *jsonHelper = [[SBJSON alloc] init];
	jsonHelper.humanReadable = NO;
	NSString *jsonStr = [jsonHelper stringWithObject:parentDict];
	[jsonHelper release];
		
	[waypointDataDict release];
	[journeys_attributes release];
	[tripDict release];
	[parentDict release];
	
	return jsonStr;
}

-(void) updateWayPointJourneyIds {
	for(SCWaypoint * waypoint in waypoints) {
		waypoint.journeyId = self.journeyId;
	}
}
/**
 * Uses logic of trip points = trip miles
 */
-(int) tripMilesForDisplay {
	if(!self.journeyEvents) {
		return 0;
	}
	
	int totalMiles = 0;
	
	for(SCJourneyEvent * logItem in self.journeyEvents) {
		if(!logItem.isInterruption) {
			totalMiles += logItem.points;
		}
	}
	
	return totalMiles;
}



-(int) tripPointsForDisplay {
	int tripPoints = [self totalPositivePoints] + [self penaltyPoints];
	
//	if (tripPoints < 0) {
//		tripPoints = 0;
//	}
	
	return tripPoints;
}

-(int) totalPositivePoints {
	if(!self.journeyEvents) {
		return 0;
	}
	
	int totalMiles = 0;
	
	for(SCJourneyEvent * logItem in self.journeyEvents) {
		if(!logItem.isInterruption) {
			totalMiles += logItem.points;
		}
	}
	
	return totalMiles;
}

-(int) penaltyPoints {	
	if(!self.journeyEvents) {
		return 0;
	}
	
	int penaltyPoints = 0;
	
	for(SCJourneyEvent * logItem in self.journeyEvents) {
		
		if(logItem.isInterruption) {			
			if(logItem.points < 0) {
				penaltyPoints += logItem.points;
			}			
		}
	}
	
	return penaltyPoints;
}

-(int) safetyPointsForDisplay {
	int milesPoints = [self totalPositivePoints];
	int penaltyPoints = [self penaltyPoints];
	int safetyPoints = milesPoints + penaltyPoints; //Penalty Pointes are always negative.
	
//	if (safetyPoints < 0) {
//		safetyPoints = 0;
//	}
	
	return safetyPoints;
}

-(int) grade {
	float milesPoints = [self totalPositivePoints];
	int penaltyPoints = [self penaltyPoints];
	float safetyPoints = milesPoints + penaltyPoints; //Penalty Pointes are always negative.
	
	if (safetyPoints <= 0 || milesPoints <= 0) {
		return 0;
	}
	
	float ratio = (safetyPoints / milesPoints);	
	ratio = ratio * 100;
	int ratioInt = (int) round(ratio);
	
	NSLog(@"milesPoints: %f, penaltyPoints: %d, ratioInt: %d", milesPoints, penaltyPoints, ratioInt);
	
	return ratioInt;
}

@end
