//
//  WayPointsStore.m
//  safecell
//
//  Created by shail on 07/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WayPointsStore.h"
#import "SCWaypoint.h"
#import "UnitUtils.h"
#import "AppDelegate.h"
//#import "iToast.h"


@implementation WayPointsStore

@synthesize isTripStarted;
BOOL autostarttimmer = false;
BOOL stoptimmerrunning = false;


- initWithCapacity: (int) maxSize;
{
	self = [super init];
	if (self != nil) {
		capacity = maxSize;
		dataStore = [[NSMutableArray alloc] initWithCapacity:maxSize];
	}
	return self;
}

/**
 Push the waypoint into local database repository
 */
-(void) pushWayPoint: (SCWaypoint *) wayPoint {
	
    if([dataStore count] == capacity) {
		[dataStore removeObjectAtIndex:0];
	}
	[dataStore addObject:wayPoint];
	wayPoint.estimatedSpeed = [self averageSpeed];
    
   //  [[[[iToast makeText:[NSString stringWithFormat:@" avg speed %.2f",wayPoint.estimatedSpeed]]setGravity:iToastGravityTop] setDuration:iToastDurationNormal] show];
    
}

-(float) averageSpeed {
   
	int count = [dataStore count];
	
	if(count > 1) {
		
		float totalDistanceInKilometers = 0;
		NSTimeInterval totalTime = 0;
		
		SCWaypoint *previousWayPoint = nil;
		
		for(int i = 0; i < count; i++) {
			SCWaypoint * wayPoint = [dataStore objectAtIndex:i];
			
			if(previousWayPoint != nil) {
				float distanceInKilometers = [SCWaypoint distanceFromWayPoint:previousWayPoint toWayPoint:wayPoint];
				distanceInKilometers = fabs(distanceInKilometers);
				totalDistanceInKilometers += distanceInKilometers;
				
				NSTimeInterval duration = [wayPoint.timeStamp timeIntervalSinceDate:previousWayPoint.timeStamp];
				totalTime += duration;
			}
			
			previousWayPoint = wayPoint;
		}		
		
		float totalDistanceInMiles= [UnitUtils kilometersToMiles:totalDistanceInKilometers];
			
        NSLog(@"Total distance in miles: %f", totalDistanceInMiles);
        NSLog(@"Total time in seconds : %f", totalTime);
		if(totalTime > 0) {
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            //app.speedValue = 0;
            app.totalMiles = 0;
			float totoalTimeInHours = totalTime / 60/60;
			float estimatedSpeed = totalDistanceInMiles / totoalTimeInHours;
            //float estimatedSpeed = totalDistanceInKilometers / totoalTimeInHours;
           // app.speedValue = (int)estimatedSpeed;
            app.totalMiles = totalDistanceInKilometers;
            //[[[[iToast makeText:[NSString stringWithFormat:@" distance in km %.2f",app.totalMiles]]setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
			return estimatedSpeed;
		} else {
			return 0;
		}
	} else {
		return 0;
	}
}

- (void) dealloc
{
	[dataStore release];
	[super dealloc];
}


@end
