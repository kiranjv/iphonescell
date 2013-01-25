//
//  ReverseGeocoder.m
//  safecell
//
//  Created by Mobisoft Infotech on 8/9/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "ReverseGeocoder.h"

static ReverseGeocoder *sharedInstance = nil;

@implementation ReverseGeocoder

@synthesize geoCoder;

#pragma mark -
#pragma mark class instance methods

-(void) startWithCoordinate:(CLLocationCoordinate2D) coordinate {
	if ((self.geoCoder != nil) && [self.geoCoder isQuerying]) {
		NSLog(@"Already querying...");
		return;
	}
	
	NSLog(@"ReverseGeocoder :: Resolving from Geocoder");
	
	MKReverseGeocoder *gCoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
	self.geoCoder = gCoder;
	[gCoder release];
	
	self.geoCoder.delegate = self;
	[self.geoCoder start];
}


-(BOOL) isQuerying {
	if ((self.geoCoder != nil) && [self.geoCoder isQuerying]) {
		NSLog(@"Already querying...");
		return YES;
	} else {
		return NO;
	}

}

-(CLLocationCoordinate2D) coordinate {
	return self.geoCoder.coordinate;
}

-(void) registerAsDeledate:(NSObject<ReverseGeocoderDelegate> *) aDelegate {
	if (delegate != aDelegate) {
		delegate = aDelegate;
	}
}

-(void) unregisterAsDelegate:(NSObject <ReverseGeocoderDelegate> *)aDelegate {
	if (delegate == aDelegate) {
		delegate = nil;
	}
}

- (void) dealloc {
	geoCoder.delegate = nil;
	self.geoCoder = nil;

	[super dealloc];
}


#pragma mark -
#pragma mark MKReverseGeocoderDelegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	if ((delegate != nil) && [delegate respondsToSelector:@selector(reverseGeocoder:didFindPlacemark:)]) {
		[delegate reverseGeocoder:self didFindPlacemark:placemark];
	}
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	if ((delegate != nil) && [delegate respondsToSelector:@selector(reverseGeocoder:didFailWithError:)]) {
		[delegate reverseGeocoder:self didFailWithError:error];
	}
}


#pragma mark -
#pragma mark Singleton methods

+ (ReverseGeocoder*)sharedReverseGeocoder {
    
	if (sharedInstance == nil) {
		sharedInstance = [[ReverseGeocoder alloc] init];
	}
    
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    
	if (sharedInstance == nil) {
		sharedInstance = [super allocWithZone:zone];
		return sharedInstance;  // assignment and return on first allocation
	}
    
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

- (oneway void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}



@end
