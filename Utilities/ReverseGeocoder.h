//
//  ReverseGeocoder.h
//  safecell
//
//  Created by Mobisoft Infotech on 8/9/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol ReverseGeocoderDelegate;

@interface ReverseGeocoder : NSObject<MKReverseGeocoderDelegate> {
	MKReverseGeocoder *geoCoder;
	
	NSObject<ReverseGeocoderDelegate> *delegate;
}

@property(nonatomic, retain) MKReverseGeocoder *geoCoder;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


-(void) registerAsDeledate:(NSObject<ReverseGeocoderDelegate> *) aDelegate;
-(void) unregisterAsDelegate:(NSObject <ReverseGeocoderDelegate> *)aDelegate;

-(BOOL) isQuerying;
-(void) startWithCoordinate:(CLLocationCoordinate2D) coordinate;

+ (ReverseGeocoder*)sharedReverseGeocoder;


@end

@protocol ReverseGeocoderDelegate

@required

- (void)reverseGeocoder:(ReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark;

- (void)reverseGeocoder:(ReverseGeocoder *)geocoder didFailWithError:(NSError *)error;

@end

