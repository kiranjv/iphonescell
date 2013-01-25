//
//  SharedLocationManager.h
//  safecell
//
//  Created by shail m on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationManager.h"
#import "DebugTrackingInformationController.h"
#import <CoreMotion/CoreMotion.h>

@class WayPointsStore;
@interface LocationHelper : NSObject<LocationManagerDelegate> {
	LocationManager *locationManager;
	CLLocation *lastKnownLocation;
    WayPointsStore *wayPointsStore;
    double distance;
    NSDate *firstWaypointTime;
    DebugTrackingInformationController *debugController;
    NSDate *lastpoint_time;
    double totalTime;
    CMMotionManager *motionManger;
    int count;
}

@property (nonatomic, retain) LocationManager *locationManager;
@property (nonatomic, retain) CLLocation *lastKnownLocation;
@property(nonatomic, retain) WayPointsStore *wayPointsStore;
@property (nonatomic, strong) NSDate *startTimestamp;
@property (nonatomic ,assign) BOOL allowMaximumAcceptableAccuracy;


-(void) startUpdatingLocation;
-(void) stopUpdatingLocation;

@end
