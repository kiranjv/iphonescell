//
//  WayPoint.h
//  safecell
//
//  Created by shail on 07/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "JSON.h"
#import <MapKit/MapKit.h>

static const BOOL kWaypointUseBackgroundField = YES;

@interface SCWaypoint : NSObject <MKAnnotation> {	
	int waypointId;
	int journeyId;
	NSDate *timeStamp;
	CLLocationDegrees latitude;
	CLLocationDegrees longitude;
	float estimatedSpeed;
	
	BOOL background;
}

@property(nonatomic, assign) int waypointId;
@property(nonatomic, assign) int journeyId;
@property(nonatomic, retain) NSDate *timeStamp;
@property(nonatomic, assign) CLLocationDegrees latitude;
@property(nonatomic, assign) CLLocationDegrees longitude;
@property(nonatomic, assign) float estimatedSpeed;
@property(nonatomic, assign) BOOL background;

-(SCWaypoint *) initWithCLLocation: (CLLocation *) location journeyId: (int) journey;
-(CLLocation *) toCLLocation;
-(CLLocationCoordinate2D) toCoordinates;

+(SCWaypoint *) waypointWithServerDictionary: (NSDictionary *) dict;

+(SCWaypoint *) waypointWithDictionary: (NSDictionary *) dict;
+(SCWaypoint *) wayPointWithJSON: (NSString *) JSONRepresentation;

-(NSDictionary *) asDictForServer;

+(double) distanceFromWayPoint:(SCWaypoint *) from toWayPoint:(SCWaypoint *) to;

@end
