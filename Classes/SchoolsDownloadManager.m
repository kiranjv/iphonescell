	//
//  SchoolsDownloadManager.m
//  safecell
//
//  Created by shail m on 6/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SchoolsDownloadManager.h"
#import "SCSchool.h"
#import "UnitUtils.h"
#import "TrackingViewController.h"
#import "TripRepository.h"
#import "LocationUtils.h"

static const float kSchoolsUpdateRadius = 5.0;

@implementation SchoolsDownloadManager

@synthesize lastSchoolsdownloadAt;
@synthesize trackingViewController;
@synthesize schoolsArr;


- (id) init {
	self = [super init];
	if (self != nil) {
		schoolProxy = [[SchoolProxy alloc] init];
		schoolProxy.delegate = self;
		
		lastSchoolFoundStatus = NO;
	}
	return self;
}

-(void) locationChangedtoWaypoint: (SCWaypoint *) waypoint {
	if (lastSchoolsdownloadAt != nil) {
		float distanceInKm = [SCWaypoint distanceFromWayPoint:lastSchoolsdownloadAt toWayPoint:waypoint];
		distanceInKm = fabs(distanceInKm);
		
		float distanceInMiles = [UnitUtils kilometersToMiles:distanceInKm];
		
		if(distanceInMiles >= kSchoolsUpdateRadius) {
			NSLog(@"Distance : %f is more than %f - Satrting Schools download", distanceInMiles, kSchoolsUpdateRadius);
			
			[schoolProxy downloadSchoolsForWaypoint:waypoint distance:kSchoolsUpdateRadius];
			self.lastSchoolsdownloadAt = waypoint;
		}		
	} else {
		[schoolProxy downloadSchoolsForWaypoint:waypoint distance:kSchoolsUpdateRadius];
		self.lastSchoolsdownloadAt = waypoint;
	}	
}

- (void) dealloc {
	[schoolsArr release];
	schoolProxy.delegate = nil;
	[schoolProxy release];
	[lastSchoolsdownloadAt release];
	[super dealloc];
}

-(BOOL) waypoint: (SCWaypoint *) waypoint fallsInSchoolZoneRadius: (float) radius {
	if (schoolsArr != nil) {
		for (SCSchool * school in schoolsArr) {
			CLLocationCoordinate2D schoolLocation;
			schoolLocation.latitude = school.latitude;
			schoolLocation.longitude = school.longitude;
			
			CLLocationCoordinate2D waypointLocation;
			waypointLocation.latitude = waypoint.latitude;
			waypointLocation.longitude = waypoint.longitude;
			
			float distance = [LocationUtils distanceFrom:waypointLocation to:schoolLocation];
			
			distance = fabs(distance);
			
			if (distance <= radius) {
				return YES;
			}
		}
	}
	
	return NO;
}

-(void) stopSchoolsDownload {
	[schoolProxy stopSchoolsDownload];
}

#pragma mark - 
#pragma mark SchoolProxyDelegate

-(void) schoolsDownloadFinished: (NSArray *) schools forWaypoint: (SCWaypoint *)waypoint {
	
	self.schoolsArr = schools;
	
	if ([schools count] > 0) {
		if (!lastSchoolFoundStatus) {
			TripRepository *tripRepository = [[TripRepository alloc] init];
			[tripRepository saveSchoolProximityStatus:YES forWaypoint:waypoint];
			[tripRepository release];
		}
		
		
		// [self.trackingViewController updateSchoolStatusToActive];
		lastSchoolFoundStatus = YES;
		
		NSLog(@"Set School Zone Warning : Schools Found: %d", [schools count]);	
	} else {	
		if (lastSchoolFoundStatus) {
			TripRepository *tripRepository = [[TripRepository alloc] init];
			[tripRepository saveSchoolProximityStatus:NO forWaypoint:waypoint];
			[tripRepository release];
		}
		
		
		// [self.trackingViewController updateSchoolStatusToInactive];
		lastSchoolFoundStatus = NO;
		
		NSLog(@"Cleared School Zone Warning : Schools Found: %d", [schools count]);		
	}
	
	[self.trackingViewController receivedNewSchools];
}

@end
