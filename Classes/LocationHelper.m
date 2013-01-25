//
//  SharedLocationManager.m
//  safecell
//
//  Created by shail m on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationHelper.h"
#import "AppDelegate.h"
#import "WayPointsStore.h"
#import "SCWaypoint.h"
#import "LocationUtils.h"


@implementation LocationHelper

@synthesize locationManager;
@synthesize lastKnownLocation;
@synthesize wayPointsStore;
static const NSInteger kWayPointsStoreSize = 10;
//const CGFloat SpeedThreshold = 50;


-(void) configureWaypointsStore {
	WayPointsStore *wps = [[WayPointsStore alloc] initWithCapacity:kWayPointsStoreSize];
	self.wayPointsStore = wps;
	[wps release];
}

- (id) init {
	self = [super init];
	if (self != nil) {
        distance = 0.0;
        totalTime = 0.0;
		locationManager = [[LocationManager alloc] initWithSource:kLocationManagerSourceDevice];
		locationManager.delegate = self;
        [self configureWaypointsStore];
        motionManger = [[CMMotionManager alloc]init];
        
	}
	
	return self;
}


- (void) dealloc {
	[locationManager release];
	[lastKnownLocation release];
	[super dealloc];
}


-(void) startUpdatingLocation {
    
	self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
	self.locationManager.distanceFilter = 10;
	[self.locationManager startUpdatingLocation];
	
	[self performSelector:@selector(tryAgain) withObject:nil afterDelay:30];
}

-(void) stopUpdatingLocation {
	[self.locationManager stopUpdatingLocation];
}

-(void)tryAgain {
	if(self.lastKnownLocation == nil) {
		NSLog(@"Haven't gotten a location update in 30 seconds... restarting the location manager.");
		[self stopUpdatingLocation];
		[self performSelector:@selector(startUpdatingLocation) withObject:nil afterDelay:5];
	}
}
-(float)getDistanceInKm:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    float lat1,lon1,lat2,lon2;
    
    lat1 = newLocation.coordinate.latitude  * M_PI / 180;
    lon1 = newLocation.coordinate.longitude * M_PI / 180;
    
    lat2 = oldLocation.coordinate.latitude  * M_PI / 180;
    lon2 = oldLocation.coordinate.longitude * M_PI / 180;
    
    float R = 6371; // km
    float dLat = lat2-lat1;
    float dLon = lon2-lon1;
    
    float a = sin(dLat/2) * sin(dLat/2) + cos(lat1) * cos(lat2) * sin(dLon/2) * sin(dLon/2);
    float c = 2 * atan2(sqrt(a), sqrt(1-a));
    float d = R * c;
    
    NSLog(@"Kms-->%f",d);
    
    return d;
}


#pragma mark -
#pragma mark LocationManagerDelegate

- (void)locationManager:(LocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
	
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
	if (newLocation.horizontalAccuracy < 0) {
		return;
	}
    app.currentLatValue = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    app.currentLongValue = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    // NSLog(@"oldLocation : %f:%f", oldLocation.coordinate.latitude, oldLocation.coordinate.longitude);
    //NSLog(@"newLocation : %f:%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    //NSLog(@"current location lat  , long = %@,%@",app.currentLatValue,app.currentLongValue);
    
    
	[[NSNotificationCenter defaultCenter] postNotificationName:@"LocationChanged" object:self];
}

@end
