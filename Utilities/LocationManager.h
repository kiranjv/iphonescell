//
//  LocationManager.h
//  safecell
//
//  Created by shail m on 6/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum _LocationManagerSource {
    kLocationManagerSourceDevice,
	kLocationManagerSourceSimulated	
} LocationManagerSource;

@protocol LocationManagerDelegate;

@interface LocationManager : NSObject<CLLocationManagerDelegate> {
	CLLocationManager *deviceLocationManager;
	NSObject<LocationManagerDelegate> *_delegate;
	
	CLLocationDistance distanceFilter;
	CLLocationAccuracy desiredAccuracy;
}

@property(nonatomic, assign) NSObject<LocationManagerDelegate> *delegate;
@property(nonatomic, assign) CLLocationDistance distanceFilter;
@property(nonatomic, assign) CLLocationAccuracy desiredAccuracy;

-(id) initWithSource: (LocationManagerSource) source;
-(void) startUpdatingLocation;
-(void) stopUpdatingLocation;
@end




@protocol LocationManagerDelegate 

@optional

- (void)locationManager:(LocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;


@end
