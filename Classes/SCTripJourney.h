//
//  Trip.h
//  safecell
//
//  Created by shail on 05/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSInteger kJourneyIdNotPersisted = 0;

/********* SCTripJourney:  Represents a physical instance of a given trip.  For example, you can name a trip "Home to work"
 and take that trip 5 times.  Each time would be a new "Journey" linked to the known trip. **********************/

@interface SCTripJourney : NSObject {
	int tripId;
	int journeyId;
	int points;
	
	NSString *tripName;
	float miles;
	NSDate *tripDate;
	
	float estimatedSpeed;
	NSMutableArray *waypoints;
	NSMutableArray *interruptions;
	NSMutableArray *journeyEvents;
}

@property (nonatomic, assign)	int tripId;
@property (nonatomic, assign)	int journeyId;
@property (nonatomic, assign)	int points;
@property (nonatomic, retain)	NSString *tripName;
@property (nonatomic, assign)	float miles;
@property (nonatomic, retain)	NSDate *tripDate;
@property (nonatomic, readonly)	int grade;
@property (nonatomic, assign)	float estimatedSpeed;
@property (nonatomic, readonly)	NSMutableArray *waypoints;
@property (nonatomic, readonly)	NSMutableArray *interruptions;
@property (nonatomic, retain)	NSMutableArray *journeyEvents;

-(id) initWithCurrentWayPointsAndInterruptions;

+(SCTripJourney *) journeyWithDict: (NSDictionary *) dict;

-(NSString *) milesString;
-(NSString *) estimatedSpeedString;

-(NSString *) JSONRepresentation;

-(void) updateWayPointJourneyIds;

-(int) penaltyPoints;

-(void) calculateAndSetEstimatedSpeed;
-(void) loadCurrentWaypoints;
-(void) loadCurrentInterruptions;


-(int) tripMilesForDisplay;
-(int) totalPositivePoints;
-(int) tripPointsForDisplay;
-(int) safetyPointsForDisplay;


@end
