//
//  LocationManager.m
//  safecell
//
//  Created by shail m on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationManager.h"



@implementation LocationManager

@synthesize delegate = _delegate;

- (id) init {
	return [self initWithSource:kLocationManagerSourceDevice];
}

- (id) initWithSource: (LocationManagerSource) source {
	self = [super init];
	if (self != nil) {
		if (source == kLocationManagerSourceDevice) {
			deviceLocationManager = [[CLLocationManager alloc] init] ;
           // deviceLocationManager.distanceFilter = 10;
            //deviceLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
			deviceLocationManager.delegate = self;
		} else {
			[NSException raise:@"kLocationManagerSourceSimulated Not Implemeneted" format:@"Simulated Location Manager is yet to be implemented"];
		}

	}
	return self;
}

-(CLLocationDistance) distanceFilter {
	return distanceFilter;
}

-(void) setDistanceFilter: (CLLocationDistance) filter {
	distanceFilter = filter;
	if (deviceLocationManager) {
		deviceLocationManager.distanceFilter = filter;
	}
}

-(CLLocationAccuracy) desiredAccuracy {
	return desiredAccuracy;
}

-(void) setDesiredAccuracy: (CLLocationAccuracy) accuracy {
	desiredAccuracy = accuracy;
	if (deviceLocationManager != nil) {
		deviceLocationManager.desiredAccuracy = accuracy;
	}
}


- (void) dealloc {
	NSLog(@"Location Manager Dealloced.");
	[deviceLocationManager release];	
	[super dealloc];
}

-(void) startUpdatingLocation {
	if (deviceLocationManager != nil) {
		[deviceLocationManager startUpdatingLocation];
	}
}

-(void) stopUpdatingLocation {
	if (deviceLocationManager != nil) {
		[deviceLocationManager stopUpdatingLocation];
	}
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
	if (self.delegate && [self.delegate respondsToSelector:@selector(locationManager:didUpdateToLocation:fromLocation:)]) {
		[self.delegate locationManager:self didUpdateToLocation:newLocation fromLocation:oldLocation];
        
	}
}


@end
