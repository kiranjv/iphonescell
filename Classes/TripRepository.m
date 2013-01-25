//
//  TripRepository.m
//  safecell
//
//  Created by Ben Scheirman on 5/14/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "TripRepository.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"


@implementation TripRepository


#pragma mark Trips


-(void)saveTrip:(SCTrip *)trip {	
	NSString *insertQuery = @"INSERT INTO trips (trip_id, name) VALUES (?, ?)";	
	[db executeUpdate:insertQuery, [NSNumber numberWithInt:trip.tripId], trip.name];	
}

-(NSMutableArray *) trips {
	NSString *query = @"SELECT trip_id, name FROM trips ORDER BY name";
	NSMutableArray *trips = [[[NSMutableArray alloc] init] autorelease];
	
	FMResultSet *resultSet = [db executeQuery:query];
	
	while ([resultSet next]) {
		SCTrip *trip = [self tripWithResultSet:resultSet];		
		[trips addObject:trip];
	}
	
	[resultSet close];	
	
	return trips;
}

-(int) totalNumberOfTrips {
	
	NSString *query = @"SELECT count(trip_id) as total_no_of_trips FROM trips";
	
	int totalNoOfTrips = [db intForQuery:query];
	
	return totalNoOfTrips;
}

-(SCTrip *) tripWithId: (int) tripId {
	NSString *query = @"SELECT trip_id, name FROM trips WHERE trip_id = ?";
	
	SCTrip *trip = nil;
	
	FMResultSet *resultSet = [db executeQuery:query, [NSNumber numberWithInt:tripId]];
	
	while ([resultSet next]) {
		trip = [self tripWithResultSet:resultSet];
	}
	
	[resultSet close];	
	
	return trip;
}

-(SCTrip *) tripWithResultSet:(FMResultSet *) resultSet {
	SCTrip *trip = [[[SCTrip alloc] init] autorelease];
	trip.tripId = [resultSet intForColumn: @"trip_id"];
	trip.name = [resultSet stringForColumn:@"name"];
	
	return trip;
}

-(void) deleteAllTrips {
	NSString *query = @"DELETE FROM trips WHERE 1";
	[db executeUpdate:query];
}


#pragma mark -
#pragma mark Journeys

-(void)saveJourney:(SCTripJourney *)tripJourney {
	NSString *insertQuery = @"INSERT INTO trip_journeys ("
								@"trip_journey_id, points, miles, trip_date, "
								@"estimated_speed, trip_id "
							@") VALUES ("
								@"?, ?, ?, ?, "
								@"?, ? "
							@")";
	
	[db executeUpdate:insertQuery, 
	 [NSNumber numberWithInt:tripJourney.journeyId],
	 [NSNumber numberWithInt:tripJourney.points],
	 [NSNumber numberWithFloat:tripJourney.miles],
	 tripJourney.tripDate,
	 [NSNumber numberWithFloat:tripJourney.estimatedSpeed],
	 [NSNumber numberWithInt:tripJourney.tripId]];
}	

-(SCTripJourney *) journeyWithId: (int) journeyId {
	NSString *query =	@"SELECT "
							@"trip_journey_id, points, miles, trip_date, "
							@"estimated_speed, trip_id "
						@"FROM trip_journeys "
						@"WHERE trip_journey_id = ?";
	
	FMResultSet *resultSet = [db executeQuery:query, [NSNumber numberWithInt:journeyId]];
	
	SCTripJourney *journey = nil;
	
	if ([resultSet next]) {
		journey = [self journeyWithResultSet:resultSet];
	}
	
	[resultSet close];
	return journey;
}

-(BOOL) journeyExists: (int) journeyId {
	NSString *query = @"SELECT COUNT(trip_journey_id) from trip_journeys WHERE trip_journey_id = ?";
 	int count = [db intForQuery:query, [NSNumber numberWithInt:journeyId]];
	if (count > 0) {
		return YES;
	} else {
		return NO;
	}

}

-(SCTripJourney *) mostRecentJourneyWithTrip: (SCTrip *) trip {
	NSString *query =	@"SELECT "
							@"trip_journey_id, points, miles, trip_date, "
							@"estimated_speed, trip_id "
						@"FROM trip_journeys "
						@"ORDER BY trip_date desc, trip_journey_id desc LIMIT 0, 1";
	
	FMResultSet *resultSet = [db executeQuery:query];
	
	SCTripJourney *journey = nil;
	
	if ([resultSet next]) {
		journey = [self journeyWithResultSet:resultSet];
	}
	
	[resultSet close];
	return journey;
}

-(NSMutableArray *) journeys {
	NSString *query =	@"SELECT "
							@"trip_journey_id, points, miles, trip_date, "
							@"estimated_speed, trip_id "
						@"FROM trip_journeys "
						@"ORDER BY trip_date desc, trip_journey_id desc";
	
	FMResultSet *resultSet = [db executeQuery:query];
	
	NSMutableArray * journeys = [[[NSMutableArray alloc] init] autorelease];
	
	while ([resultSet next]) {
		SCTripJourney *journey = [self journeyWithResultSet:resultSet];		
		[journeys addObject:journey];
	}
	
	[resultSet close];
	
	return journeys;
}

-(NSMutableArray *) journeysInAscendingOrder {
	NSString *query =	@"SELECT "
							@"trip_journey_id, points, miles, trip_date, "
							@"estimated_speed, trip_id "
						@"FROM trip_journeys "
						@"ORDER BY trip_date asc, trip_journey_id asc";
	
	FMResultSet *resultSet = [db executeQuery:query];
	
	NSMutableArray * journeys = [[[NSMutableArray alloc] init] autorelease];
	
	while ([resultSet next]) {
		SCTripJourney *journey = [self journeyWithResultSet:resultSet];		
		[journeys addObject:journey];
       
	}
	
	[resultSet close];
	
	return journeys;
}

-(NSMutableArray *) recentJourneys: (int) maxItems {
	NSString *query =	@"SELECT "
							@"trip_journey_id, points, miles, trip_date, "
							@"estimated_speed, trip_id "
						@"FROM trip_journeys "
						@"ORDER BY trip_date desc, trip_journey_id desc LIMIT 0, ?";
	
	FMResultSet *resultSet = [db executeQuery:query, [NSNumber numberWithInt:maxItems]];
	
	NSMutableArray * journeys = [[[NSMutableArray alloc] initWithCapacity:maxItems] autorelease];
	
	while ([resultSet next]) {
		SCTripJourney *journey = [self journeyWithResultSet:resultSet];		
		[journeys addObject:journey];
	}
	
	[resultSet close];
	
	return journeys;
}

-(SCTripJourney *) journeyWithResultSet:(FMResultSet *) resultSet {
	SCTripJourney *journey = [[[SCTripJourney alloc] init] autorelease];
	
	journey.journeyId = [resultSet intForColumn:@"trip_journey_id"];
	journey.points = [resultSet intForColumn:@"points"];
	journey.miles = [resultSet  doubleForColumn:@"miles"];
	journey.tripDate = [resultSet dateForColumn:@"trip_date"];
	journey.estimatedSpeed = [resultSet doubleForColumn:@"estimated_speed"];
	journey.tripId = [resultSet intForColumn:@"trip_id"];		
	
	SCTrip *trip = [self tripWithId:journey.tripId];
	journey.tripName = trip.name;
	
	return journey;
}

-(int) totalJourneys {
	NSString *query = @"SELECT COUNT(trip_journey_id) FROM trip_journeys";	
	int totalJourneys = [db intForQuery:query];
	
	return totalJourneys;
}

-(double) totalMiles {
	NSString *query = @"SELECT SUM (miles) FROM trip_journeys";
	double totalMiles = [db doubleForQuery:query];
	
	return totalMiles;
}

-(double) totalPenaltyPoints {
	NSString *query = @"SELECT SUM (points) FROM journey_events WHERE points < 0";
	double totalPenaltyPoints = [db doubleForQuery:query];
	
	return totalPenaltyPoints;
}

-(int) totalPoints {
	NSString *query = @"SELECT SUM (points) FROM trip_journeys";
	int totalPoints = [db intForQuery:query];
	
	return totalPoints;
}

-(int) totalPositivePoints {
	NSString *query = @"SELECT SUM (points) FROM journey_events WHERE points > 0";
	double totalPositivePoints = [db doubleForQuery:query];
	
	return totalPositivePoints;
}

-(void) deleteAllJourneys {
	NSString *query = @"DELETE FROM trip_journeys WHERE 1";
	[db executeUpdate:query];
}

#pragma mark -
#pragma mark WayPoints

-(void) saveWaypoint:(SCWaypoint *)waypoint {
	NSString *insertQuery = @"INSERT INTO trip_journey_waypoints ("
								@"timestamp, latitude, longitude, "
								@"estimated_speed, trip_journey_id, background "
							@") VALUES ("
								@"?, ?, ?, "
								@"?, ?, ? "
							@")";
	
	[db executeUpdate:insertQuery, 
			 waypoint.timeStamp,
			 [NSNumber numberWithFloat:waypoint.latitude],
			 [NSNumber numberWithFloat:waypoint.longitude],
			 [NSNumber numberWithFloat:waypoint.estimatedSpeed],
			 [NSNumber numberWithInt:waypoint.journeyId],
			 [NSNumber numberWithBool:waypoint.background]];
	
	waypoint.waypointId = [self lastInsertRowId];
}

-(void) deleteAllWaypoints {
	NSString *query = @"DELETE FROM trip_journey_waypoints WHERE 1";
	[db executeUpdate:query];
}

#pragma mark -
#pragma mark School Proximity Data

-(void) saveSchoolProximityStatus: (BOOL) status forWaypoint: (SCWaypoint *) waypoint {
	NSString *insertQuery =		@"INSERT INTO school_proximity_data ("
									@"latitude, longitude, found_schools"
								@") VALUES ("
									@"?, ?, ? "
								@")";
	
	[db executeUpdate:insertQuery, 
			[NSNumber numberWithFloat:waypoint.latitude],
			[NSNumber numberWithFloat:waypoint.longitude],
			[NSNumber numberWithBool:status]];
}

-(BOOL) isSchoolProximitySignificant: (SCWaypoint *) waypoint {
	NSString *query = @"SELECT count(*) from school_proximity_data WHERE latitude = ? AND longitude = ?";
	
	int count = [db intForQuery:query, [NSNumber numberWithFloat:waypoint.latitude], [NSNumber numberWithFloat:waypoint.longitude]];
	
	// NSLog(@"checking %f, %f", waypoint.latitude, waypoint.longitude);
	
	if (count > 0) {
		// NSLog(@"YES");
		return YES;
	} else {
		// NSLog(@"NO");
		return NO;
	}
}

-(void) clearSchoolProximityData {
	NSString *query = @"DELETE FROM school_proximity_data WHERE 1";
	[db executeUpdate:query];
}


#pragma mark -
#pragma mark JourneyEvents

-(void) saveJourneyEvent: (SCJourneyEvent *) journeyEvent {
	NSString *insertQuery =		@"INSERT INTO journey_events ("
									@"id, journey_id, points, "
									@"near, description, timestamp "
								@") VALUES ("
									@"?, ?, ?, "
									@"?, ?, ? "
								@")";
	
	[db executeUpdate:insertQuery, 
		[NSNumber numberWithInt:journeyEvent.eventId],
		[NSNumber numberWithInt:journeyEvent.journeyId],
		[NSNumber numberWithFloat:journeyEvent.points],
		journeyEvent.near,
		journeyEvent.description,
		journeyEvent.timestamp];
}

-(NSMutableArray *) journeyEvents: (int) journeyId {
	NSString *query =	@"SELECT "
							@"id, journey_id, points, "
							@"near, description, timestamp "
						@"FROM journey_events "
						@"WHERE journey_id = ?";
	
	NSMutableArray *events = [[[NSMutableArray alloc] init] autorelease];
	FMResultSet *resultSet = [db executeQuery:query, [NSNumber numberWithInt:journeyId]];
	while ([resultSet next]) {
		SCJourneyEvent *event = [self eventWithResultSet:resultSet];
		[events addObject:event];
	}
	[resultSet close];
	return events;	
}	

-(SCJourneyEvent *) eventWithResultSet:(FMResultSet *) resultSet {
	SCJourneyEvent *event =[[[SCJourneyEvent alloc] init] autorelease];
	
	event.eventId = [resultSet intForColumn:@"id"];
	event.journeyId = [resultSet intForColumn:@"journey_id"];
	event.points = [resultSet doubleForColumn:@"points"];
	event.near = [resultSet stringForColumn:@"near"];
	event.description = [resultSet stringForColumn:@"description"];
	event.timestamp = [resultSet dateForColumn:@"timestamp"];
	
	return event;
}

-(void) deleteAllJourneyEvents {
	NSString *query = @"DELETE FROM journey_events WHERE 1";
	
	[db executeUpdate:query];
}

#pragma mark -
#pragma mark Interruptions

-(void) saveInterruption: (SCInterruption *) interruption {
	NSString *insertQuery =		@"INSERT INTO interruptions ("
									@"started_at, ended_at, "
									@"journey_id, latitude, longitude, "
									@"estimated_speed, paused, terminated_app, "
									@"school_zone_active, phone_rule_active, sms_rule_active "
								@") VALUES ("
									@"?, ?, "
									@"?, ?, ?, "
									@"?, ?, ?, "
									@"?, ?, ? "
								@")";
	
	/*[db executeUpdate:insertQuery,
			interruption.startedAt,
			interruption.endedAt,
			[NSNumber numberWithInt:interruption.journeyId],
			[NSNumber numberWithFloat:interruption.latitude],
			[NSNumber numberWithFloat:interruption.longitude],
			[NSNumber numberWithFloat:interruption.estimatedSpeed],
			[NSNumber numberWithBool:interruption.paused],
			[NSNumber numberWithBool:interruption.terminatedApp],
			//[NSNumber numberWithBool:interruption.schoolZoneActive] @"VIOLATION",
			[NSNumber numberWithBool:interruption.phoneRuleActive],
			[NSNumber numberWithBool:interruption.smsRuleActive]];*/
    [db executeUpdate:insertQuery,
     interruption.startedAt,
     interruption.endedAt,
     [NSNumber numberWithInt:interruption.journeyId],
     [NSNumber numberWithFloat:interruption.latitude],
     [NSNumber numberWithFloat:interruption.longitude],
     [NSNumber numberWithFloat:interruption.estimatedSpeed],
     [NSNumber numberWithBool:interruption.paused],
     [NSNumber numberWithBool:interruption.terminatedApp],
     @"VIOLATION",
     [NSNumber numberWithBool:interruption.phoneRuleActive],
     [NSNumber numberWithBool:interruption.smsRuleActive]];
}

-(void) deleteAllInterruptions {
	NSString *query = @"DELETE FROM interruptions WHERE 1";
	
	[db executeUpdate:query];
}

@end
