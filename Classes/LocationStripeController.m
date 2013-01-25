//
//  LocationStripeController.m
//  safecell
//
//  Created by shail m on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "LocationStripeController.h"
#import "AppDelegate.h"
#import "ResolvedLocationRepository.h"


@implementation LocationStripeController

@synthesize view;
@synthesize geoCoder;

- (id) init {
	self = [super init];
	if (self != nil) {
		[self createContents];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChanged) name:@"LocationChanged" object:nil];
	}
	return self;
}

-(void) createContents {
	UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kLocationStripeHeight)];
	self.view = contentView;
	[contentView release];
	
	self.view.backgroundColor = [UIColor blackColor];
	
	locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 1, 320, 11)];
	locationLabel.backgroundColor = [UIColor clearColor];
	locationLabel.font = [UIFont systemFontOfSize:10];
	locationLabel.textColor = [UIColor whiteColor];
	
	[self.view addSubview:locationLabel];
	[self setLocation:@"Resolving location…"];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	if (appDelegate.locationHelper.lastKnownLocation != nil) {
		[self locationChanged];
	}
}

-(NSString *) location {
	return location;
}

-(void) setLocation: (NSString *) locationStr {
	[locationStr retain];
	[location release];
	location = locationStr;
	
	locationLabel.text = location;
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"LocationChanged" object:nil];
	
	self.geoCoder.delegate = nil;
	[geoCoder release];
	[view release];
	[location release];
	[locationLabel release];
	[super dealloc];
}


-(SCResolvedLocation *) resolveLocationFromDb {
	NSLog(@"Resolving from DB...");
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	CLLocationCoordinate2D coordinate = appDelegate.locationHelper.lastKnownLocation.coordinate;

	ResolvedLocationRepository *locationRepository = [[ResolvedLocationRepository alloc] init];
	
	SCResolvedLocation *resolvedLocation = [locationRepository reslovedLocationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
	[locationRepository release];
	
	return resolvedLocation;
}

-(void) resolveLocationFromGeocoder {
	if ((self.geoCoder != nil) && [self.geoCoder isQuerying]) {
		return;
	}
	
	NSLog(@"Resolving from Geocoder...");
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	MKReverseGeocoder *gCoder = [[MKReverseGeocoder alloc] initWithCoordinate:appDelegate.locationHelper.lastKnownLocation.coordinate];
	self.geoCoder = gCoder;
	[gCoder release];
	
	self.geoCoder.delegate = self;
	[self.geoCoder start];
}

-(NSString *) locationStrWithSublocality: (NSString *) subLocality city: (NSString *) city state:(NSString *) state {
	NSMutableString *locationStr = [[[NSMutableString alloc] init] autorelease];
	
	if ((subLocality != nil) && ![subLocality isBlank]){
		[locationStr appendString:subLocality];
	}
	
	if ((city != nil) && ![city isBlank]){
		if ([locationStr length] > 0) {
			[locationStr appendString:@", "];
		}
		[locationStr appendString:city];
	}
	
	if ((state != nil) && ![state isBlank]){
		if ([locationStr length] > 0) {
			[locationStr appendString:@", "];
		}
		[locationStr appendString:state];
	}
	
	return locationStr;
}

-(void) locationChanged {
	SCResolvedLocation *reslovedLocation = [self resolveLocationFromDb];
	
	if (reslovedLocation != nil) {
		NSString *locationStr = [self locationStrWithSublocality:reslovedLocation.sublocality city:reslovedLocation.city state:reslovedLocation.state];
		[self setLocation:locationStr];
	} else {
		[self resolveLocationFromGeocoder];
	}	
}

-(void) saveReslovedLocationToDb: (SCResolvedLocation *) resolvedLocation {
	ResolvedLocationRepository *resolvedLocationRepository = [[ResolvedLocationRepository alloc] init];
	[resolvedLocationRepository saveResolvedLocation:resolvedLocation];
	[resolvedLocationRepository release];
}

#pragma mark -
#pragma mark MKReverseGeocoderDelegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	NSString *subLocality = placemark.subLocality;
	NSString *city = [placemark.addressDictionary objectForKey:(NSString *)kABPersonAddressCityKey];
	NSString *state = [placemark.addressDictionary objectForKey:(NSString *)kABPersonAddressStateKey];
	
	SCResolvedLocation *resolvedLocation = [[SCResolvedLocation alloc] init];	
	resolvedLocation.latitude = geocoder.coordinate.latitude;
	resolvedLocation.longitude = geocoder.coordinate.longitude;
	resolvedLocation.sublocality = subLocality;
	resolvedLocation.city = city;
	resolvedLocation.state = state;
	[self saveReslovedLocationToDb:resolvedLocation];
	[resolvedLocation release];
	
	NSString *locationStr = [self locationStrWithSublocality:subLocality city:city state:state];
	[self setLocation:locationStr];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	//For Now Do Nothing
}

@end
