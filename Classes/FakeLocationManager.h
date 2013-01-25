//
//  FakeLocationManager.h
//  safecell
//
//  Created by shail on 12/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@class WayPointsReader;
@class SCWaypoint;

@protocol FakeLocationManagerDelegate<CLLocationManagerDelegate>

-(void) reachedToEndofRecordedWayPointsFile;

@end

@interface FakeLocationManager : CLLocationManager {
	WayPointsReader *wayPointsReader;
	
	SCWaypoint *firstInQue;
	SCWaypoint *secondInQue;
	
	NSTimer *updateLocationTimer;
	NSTimeInterval nextTimerInterval;
	
	CLLocation *lastSentLocation;
	
	id<FakeLocationManagerDelegate> delegate;
	
	BOOL raceToEnd;
	BOOL reachedToEOF;
}

@property (nonatomic, assign) id<FakeLocationManagerDelegate> delegate;
@property (nonatomic, retain) SCWaypoint *firstInQue;
@property (nonatomic, retain) SCWaypoint *secondInQue;
@property (nonatomic, retain) NSTimer *updateLocationTimer;
@property (nonatomic, assign) BOOL raceToEnd;

-(void) configureWayPointsReader;
-(void) readNextWayPoints;
-(void) configureTimer;
-(void) handleTimer: (NSTimer *) timer;

-(void) startUpdatingLocation;
-(void) stopUpdatingLocation;
-(void) forwardJourneyToLastStopped;

@end
