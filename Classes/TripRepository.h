//
//  TripRepository.h
//  safecell
//
//  Created by Ben Scheirman on 5/14/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCTrip.h"
#import "SCTripJourney.h"
#import "AbstractRepository.h"
#import "SCWaypoint.h"
#import "SCJourneyEvent.h"
#import "SCInterruption.h"

@interface TripRepository : AbstractRepository {

}

#pragma mark -
#pragma mark Trips

-(void) saveTrip:(SCTrip *)trip;

-(SCTrip *) tripWithId: (int) tripId;
-(NSMutableArray *) trips;
-(SCTrip *) tripWithResultSet:(FMResultSet *) resultSet;

-(int) totalNumberOfTrips;
-(void) deleteAllTrips;



#pragma mark -
#pragma mark Journeys

-(void) saveJourney:(SCTripJourney *)tripJourney;

-(SCTripJourney *) journeyWithId: (int) journeyId;
-(BOOL) journeyExists: (int) journeyId;
-(NSMutableArray *) journeys;
-(NSMutableArray *) journeysInAscendingOrder;
-(NSMutableArray *) recentJourneys: (int) maxItems;
-(SCTripJourney *) mostRecentJourneyWithTrip: (SCTrip *) trip;
-(SCTripJourney *) journeyWithResultSet:(FMResultSet *) resultSet;

-(int) totalJourneys;
-(double) totalMiles;
-(double) totalPenaltyPoints;
-(void) deleteAllJourneys;
-(int) totalPoints;
-(int) totalPositivePoints;


#pragma mark -
#pragma mark WayPoints

-(void) saveWaypoint:(SCWaypoint *)waypoint;
-(void) deleteAllWaypoints;


#pragma mark -
#pragma mark School Proximity Data

-(void) saveSchoolProximityStatus: (BOOL) status forWaypoint: (SCWaypoint *) waypoint;
-(BOOL) isSchoolProximitySignificant: (SCWaypoint *) waypoint;
-(void) clearSchoolProximityData;


#pragma mark -
#pragma mark JourneyEvents

-(void) saveJourneyEvent: (SCJourneyEvent *) journeyEvent;
-(NSMutableArray *) journeyEvents: (int) journeyId;
-(SCJourneyEvent *) eventWithResultSet:(FMResultSet *) resultSet;
-(void) deleteAllJourneyEvents;

#pragma mark -
#pragma mark Interruptions

-(void) saveInterruption: (SCInterruption *) interruption;
-(void) deleteAllInterruptions;

@end
