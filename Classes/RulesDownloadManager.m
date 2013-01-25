//
//  RulesDownloadManager.m
//  safecell
//
//  Created by shail m on 6/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "RulesDownloadManager.h"
#import "UnitUtils.h"
#import "RuleRepository.h"
#import "TrackingViewController.h"
#import "ResolvedLocationRepository.h"
#import "FlurryAPI.h"
#import "AppDelegate.h"

static const float kReverseGeocodeDistance  = 1;


@implementation RulesDownloadManager

@synthesize lastRulesdownloadAt;
@synthesize trackingViewController;
@synthesize lastknownWaypoint;
@synthesize lastReverseGeocoded;
@synthesize lastResolvedLocation;
@synthesize lastReverseGeocodingRequestSentFor;
@synthesize ruleRetryForFailureTimer;

- (id) init {
	self = [super init];
	if (self != nil) {
		rulesProxy = [[RuleProxy alloc] init];
		rulesProxy.delegate = self;
	}
	return self;
}

-(void) setRules:(NSArray *) rules {
	[rules retain];
	[rulesArr release];
	rulesArr = rules;
}

-(NSArray *) rules {
	return rulesArr;
}

-(void) downloadRulesForWaypoint: (SCWaypoint *) waypoint {
	[rulesProxy downloadRulesForLatitude:waypoint.latitude longidute:waypoint.longitude distance:kRulesUpdateRadius];
	rulesRequestInProgress = YES;
	self.lastRulesdownloadAt = waypoint;
}

-(SCResolvedLocation *) resolveLocationFromDb: (SCWaypoint *) waypoint {
	NSLog(@"Resolving from DB...");
	ResolvedLocationRepository *locationRepository = [[ResolvedLocationRepository alloc] init];
	
	SCResolvedLocation *resolvedLocation = [locationRepository reslovedLocationWithLatitude:waypoint.latitude longitude:waypoint.longitude];
	[locationRepository release];
	
	return resolvedLocation;
}

-(void) resolveLocationFromGeocoder: (SCWaypoint *) waypoint {
	
	if ([[ReverseGeocoder sharedReverseGeocoder] isQuerying]) {
		return;
	}
	
	[[ReverseGeocoder sharedReverseGeocoder] registerAsDeledate:self];
	[[ReverseGeocoder sharedReverseGeocoder] startWithCoordinate:[waypoint toCoordinates]];
	NSLog(@"-----------------------------> Rule DM : Satrted GC");
}

-(void) saveReslovedLocationToDb: (SCResolvedLocation *) resolvedLocation {
	ResolvedLocationRepository *resolvedLocationRepository = [[ResolvedLocationRepository alloc] init];
	[resolvedLocationRepository saveResolvedLocation:resolvedLocation];
	[resolvedLocationRepository release];
}

-(void) resolvedLocation: (SCResolvedLocation *) resolvedLocation {
	self.lastReverseGeocoded = self.lastReverseGeocodingRequestSentFor;
	if (self.lastResolvedLocation != nil) {
		NSString *newZip = EmptyIfNull(self.lastResolvedLocation.zipCode);
		NSString *oldZip = EmptyIfNull(resolvedLocation.zipCode);
		BOOL zipsAreDifferent = ![newZip isEqualToString:oldZip];

		if (zipsAreDifferent && !rulesRequestInProgress) {
			[self downloadRulesForWaypoint:self.lastReverseGeocoded];
		}
	}
	
	self.lastResolvedLocation = resolvedLocation;
}

-(void) resolveLocation:(SCWaypoint *) waypoint {
	SCResolvedLocation *resolvedLocation = [self resolveLocationFromDb:waypoint];
	self.lastReverseGeocodingRequestSentFor = waypoint;
	
	if (resolvedLocation != nil) {
		self.lastReverseGeocoded = waypoint;
		[self resolvedLocation:resolvedLocation];
	} else {
		[self resolveLocationFromGeocoder:waypoint];
	}	
}

-(void) useRulesFromDB {
	RuleRepository *ruleRepository = [[RuleRepository alloc] init];	
	NSArray *activeRules = [ruleRepository activeRules];
	[ruleRepository release];
	
	[self setRules:activeRules];
}

-(void) locationChangedtoWaypoint: (SCWaypoint *) waypoint {	
	self.lastknownWaypoint = waypoint;
	
	if (lastRulesdownloadAt != nil) {
		float distanceInKm = [SCWaypoint distanceFromWayPoint:lastRulesdownloadAt toWayPoint:waypoint];
		distanceInKm = fabs(distanceInKm);
		
		float distanceInMiles = [UnitUtils kilometersToMiles:distanceInKm];
		NSLog(@"Distance : %f Radius: %d", distanceInMiles, kRulesUpdateRadius);
		if(distanceInMiles >= kRulesUpdateRadius) {
			NSLog(@"Distance : %f is more than %d - Satrting Rules download", distanceInMiles, kRulesUpdateRadius);
			[self downloadRulesForWaypoint:waypoint];
		}		
	} else {
		[self useRulesFromDB];
		[self downloadRulesForWaypoint:waypoint];
	}	
	
	if (self.lastReverseGeocoded == nil) {
		[self resolveLocation:waypoint];
	} else {
		float distanceInKm = [SCWaypoint distanceFromWayPoint:lastReverseGeocoded toWayPoint:waypoint];
		distanceInKm = fabs(distanceInKm);
		
		float distanceInMiles = [UnitUtils kilometersToMiles:distanceInKm];
		
		NSLog(@"Distance : %f  kReverseGeocodeDistance: %f", distanceInMiles, kReverseGeocodeDistance);
				
		if(distanceInMiles >= kReverseGeocodeDistance) {
			[self resolveLocation:waypoint];
		}
	}
}

-(void) startRuleRetryTimer {
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60.0
									 target:self
								   selector:@selector(startRuleDownloadBecauseOfFailure)
								   userInfo:nil
									repeats:NO];
	
	self.ruleRetryForFailureTimer = timer;
}

-(void) stopRuleRetryTimer {
	if (ruleRetryForFailureTimer != nil) {
		[ruleRetryForFailureTimer invalidate];
		self.ruleRetryForFailureTimer = nil;
	}
}

-(void) stopRulesDownload {	
	[rulesProxy stopRulesDownload];
	[self stopRuleRetryTimer];
}

- (void) dealloc {
	[self stopRuleRetryTimer];
	
	[[ReverseGeocoder sharedReverseGeocoder] unregisterAsDelegate:self];
	
	[lastReverseGeocodingRequestSentFor  release];
	[lastReverseGeocoded release];
	[lastResolvedLocation release];
	
	[lastRulesdownloadAt release];
	[lastknownWaypoint release];
	[rulesArr release];
	
	rulesProxy.delegate = nil;
	[rulesProxy release];
	[super dealloc];
}



-(void) updateRulesStatusAsPerSchoolZone: (BOOL) schoolZone {
	if (rulesArr == nil) {
		return;
	}
	
	BOOL phoneRuleFound = NO;
	BOOL smsOrEmailRuleFound = NO;
	
	BOOL smsRuleApplicableForAllZones = NO;
	BOOL phoneRuleApplicableForAllZones = NO;
	
	
	/*
	 
	 for (Rule r in rules) {
		r.active = YES;
	 
		if(rule isSMSOrEmailRule) {
	 
			rule isSchoolZoneOnly
				if schoolZone 
					set SMS Rule:on
				else
					set SMS: off
			else
				set SMS: On
	 
		}
	 }
	 
			rule isSchoolZoneOnly && schoolZone
				set SMS Rule:on
			else
				set SMS Rule:on
			
		}
	 }
	 
	 */
	
	AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
	SCProfile *currentProfile = appDelegate.currentProfile;
	
	for (SCRule *rule in rulesArr) {
		
		if (![rule appliesToLicenseClass:currentProfile.licenseClassKey]) {
			NSLog(@"Rule '%@' does not apply to '%@'", rule.licenses, currentProfile.licenseClassKey);
			continue;
		} 
		
		NSLog(@"Rule '%@' applies to '%@'", rule.licenses, currentProfile.licenseClassKey);

		
		rule.active = YES;
		
		if ([rule isSMSOrEmailRule]) {
			smsOrEmailRuleFound = YES;		
			NSLog(@"smsOrEmailRule Found");
			NSLog(@"Rule ID: %d", rule.ruleId);
			if (![rule isSchoolZoneOnly]) {
				smsRuleApplicableForAllZones = YES;
			}
		}		
		
		if ([rule isPhoneRule]) {
			phoneRuleFound = YES;
			NSLog(@"phoneRule Found");
			if (![rule isSchoolZoneOnly]) {
				phoneRuleApplicableForAllZones = YES;
			}
		}
	}
	
	NSLog(@"SCHOOL ZONE: %@", schoolZone ? @"YES" : @"NO");
	NSLog(@"Phone Rule Found: %@", phoneRuleFound ? @"YES" : @"NO");
	NSLog(@"Phone Rule applies to all zones?: %@", phoneRuleApplicableForAllZones ? @"YES" : @"NO");
	NSLog(@"SMS Rule Found: %@", smsOrEmailRuleFound ? @"YES" : @"NO");
	NSLog(@"SMS Rule applies to all zones?: %@", smsRuleApplicableForAllZones ? @"YES" : @"NO");
	
	
	if (smsOrEmailRuleFound) {
		if (smsRuleApplicableForAllZones) {
			[self.trackingViewController updateSMSStatus:YES playNotifySound:YES];
		} else if ((!smsRuleApplicableForAllZones) && schoolZone) {
			[self.trackingViewController updateSMSStatus:YES playNotifySound:YES];
		} else {
			[self.trackingViewController updateSMSStatus:NO playNotifySound:YES];
		}
	} else {
		[self.trackingViewController updateSMSStatus:NO playNotifySound:YES];
		NSLog(@"smsOrEmailRule Not Found");
	}
	
	if (phoneRuleFound) {
		if (phoneRuleApplicableForAllZones) {
			[self.trackingViewController updatePhoneStatusToActive];
			[self.trackingViewController updateSMSStatus:YES playNotifySound:NO];
		} else if ((!phoneRuleApplicableForAllZones) && schoolZone) {
			[self.trackingViewController updatePhoneStatusToActive];
			[self.trackingViewController updateSMSStatus:YES playNotifySound:NO];
		} else {
			[self.trackingViewController updatePhoneStatusToInactive];
		}
	} else {
		NSLog(@"phoneRule Not Found");
		[self.trackingViewController updatePhoneStatusToInactive];
	}
}

-(void) startRuleDownloadBecauseOfFailure {
	if ((rulesRequestInProgress == YES) || (self.lastknownWaypoint == nil)) {
		NSLog(@"Auto falire rule download cancelled. rulesRequestInProgress : %d", rulesRequestInProgress);
		return;
	}
	
	NSLog(@"Downloading rules for failure");
	[self downloadRulesForWaypoint:self.lastknownWaypoint];
}



#pragma mark - 
#pragma mark Response Handlers

-(void) rulesDownloadFinished: (NSArray *) rules {
	rulesRequestInProgress = NO;
	[self setRules:rules];
	RuleRepository *ruleRepository = [[RuleRepository alloc] init];	
	[ruleRepository setAllRulesToInactive];
	for (SCRule *rule in rulesArr) {
		rule.active = YES;
		[ruleRepository saveOrUpdateRule:rule];
	}
	[ruleRepository release];
	NSLog(@"Total Rules Downloaded: %d", [rules count]);
	

	[self.trackingViewController receivedNewRules];

}


-(void) rulesDownloadFailed {
	[FlurryAPI logEvent:@"Rules Download Manager : Rules Download Failed"];
	rulesRequestInProgress = NO;
	
	[self startRuleRetryTimer];
}

#pragma mark -
#pragma mark ReverseGeocoderDelegate

- (void)reverseGeocoder:(ReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	[[ReverseGeocoder sharedReverseGeocoder] unregisterAsDelegate:self];
	NSLog(@"-----------------------------> Rule DM : Successs GC");
	
	NSString *subLocality = placemark.subLocality;
	NSString *city = [placemark.addressDictionary objectForKey:(NSString *)kABPersonAddressCityKey];
	NSString *state = [placemark.addressDictionary objectForKey:(NSString *)kABPersonAddressStateKey];
	NSString *zipCode = [placemark.addressDictionary objectForKey:(NSString *)kABPersonAddressZIPKey];
	
	SCResolvedLocation *resolvedLocation = [[SCResolvedLocation alloc] init];	
	resolvedLocation.latitude = geocoder.coordinate.latitude;
	resolvedLocation.longitude = geocoder.coordinate.longitude;
	resolvedLocation.sublocality = subLocality;
	resolvedLocation.city = city;
	resolvedLocation.state = state;
	resolvedLocation.zipCode = zipCode;
	[self saveReslovedLocationToDb:resolvedLocation];
	
	NSLog(@"Resolved Location Zip: %@", resolvedLocation.zipCode);
	[self resolvedLocation:resolvedLocation];
	
	[resolvedLocation release];
}

- (void)reverseGeocoder:(ReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	[[ReverseGeocoder sharedReverseGeocoder] unregisterAsDelegate:self];
	NSLog(@"-----------------------------> Rule DM : fail GC");
	
	if (error) {
		NSLog(@"Geo Coding Error: %@", [error localizedDescription]);
	}
}



@end
