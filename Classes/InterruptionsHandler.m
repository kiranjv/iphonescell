//
//  InterruptionsHandler.m
//  safecell
//
//  Created by shail m on 5/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InterruptionsHandler.h"
#import "InterruptionsFileHelper.h"
#import "AppSettingsItemRepository.h"

@interface InterruptionsHandler()
	@property(nonatomic, retain) SCInterruption *currentInterruption;
@end


@implementation InterruptionsHandler

@synthesize currentInterruption;
@synthesize previousWaypoint;
@synthesize continueTrackingAction;

@synthesize schoolZoneActive;
@synthesize phoneRuleActive;
@synthesize smsRuleActive;
@synthesize mapIntrruption;

#pragma mark -
#pragma mark Database Tracking State

-(void) setTrackingStateOff {
	AppSettingsItemRepository *settingsRepository = [[AppSettingsItemRepository alloc] init];
	[settingsRepository updateTrackingState:TRACKING_OFF];
	[settingsRepository release];
}

-(void) setTrackingStateOn {
	AppSettingsItemRepository *settingsRepository = [[AppSettingsItemRepository alloc] init];
	[settingsRepository updateTrackingState:TRACKING_ON];
	[settingsRepository release];
}

-(void) setTrackingStateToSave {
	AppSettingsItemRepository *settingsRepository = [[AppSettingsItemRepository alloc] init];
	[settingsRepository updateTrackingState:TRACKING_TO_SAVE];
	[settingsRepository release];
}

-(NSString *) trackingState {
	AppSettingsItemRepository *settingsRepository = [[AppSettingsItemRepository alloc] init];
	NSString *trackingState = [settingsRepository trackingState];
	[settingsRepository release];
	
	return trackingState;
}

-(BOOL) isTracking {
	return [[self trackingState] isEqualToString:TRACKING_ON];
}

-(BOOL) shouldShowAddTrip {
	return [[self trackingState] isEqualToString:TRACKING_TO_SAVE];
}

#pragma mark -
#pragma mark Tracking Actions

-(void) startTracking {
	[self setTrackingStateOn];
	
	if([InterruptionsFileHelper interruptionsFileExists]) {
		interruptionsFileHelper = [[InterruptionsFileHelper alloc] initWithNewFile:NO];
		
		self.currentInterruption = [interruptionsFileHelper readLastInterruption];
		if (self.currentInterruption.endedAt != nil) {
			self.currentInterruption.endedAt = [NSDate date];
			[interruptionsFileHelper updateLastInterruption:self.currentInterruption withOptionalProperties:NO];
		}		
		self.currentInterruption = nil;
	} else {
		interruptionsFileHelper = [[InterruptionsFileHelper alloc] initWithNewFile:YES];
	}
}

-(void) stopTracking {
	if (self.currentInterruption) {
		self.currentInterruption.endedAt = [NSDate date];
		[interruptionsFileHelper updateLastInterruption:self.currentInterruption withOptionalProperties:NO];
	}
	
	self.continueTrackingAction = kContinueTrackingActionSaveJourney;

	[self setTrackingStateToSave];
	[interruptionsFileHelper release];
	self.currentInterruption = nil;
}

-(void) trackingPaused {
	//self.currentInterruption = [SCInterruption interruptionStartingNowWithMapButtonClicked:self.mapIntrruption phoneRuleActive:self.phoneRuleActive smsRuleActive:self.smsRuleActive];
    self.currentInterruption = [SCInterruption interruptionStartingNowWithSchoolZoneActive:self.schoolZoneActive phoneRuleActive:self.phoneRuleActive smsRuleActive:self.smsRuleActive];
	[self.currentInterruption setPropertiesFromWaypoint:self.previousWaypoint];
	self.currentInterruption.paused = YES;
	[interruptionsFileHelper writeInterruption:self.currentInterruption withOptionalProperties:NO];
}

-(void) trackingResumed {
	self.currentInterruption.endedAt = [NSDate date];
	[interruptionsFileHelper updateLastInterruption:self.currentInterruption withOptionalProperties:NO];
	self.currentInterruption = nil;
}

#pragma mark -
#pragma mark applicationLifeCycle

-(void) wirteMapInterruption {
    if([self isTracking]) {
		self.currentInterruption = [SCInterruption interruptionStartingNowWithSchoolZoneActive:@"MAPS" phoneRuleActive:self.phoneRuleActive smsRuleActive:self.smsRuleActive];
		[self.currentInterruption setPropertiesFromWaypoint:self.previousWaypoint];
        self.currentInterruption.schoolZoneActive = @"MAPS";
		[interruptionsFileHelper writeInterruption:self.currentInterruption withOptionalProperties:NO];
	}
}

-(void) applicationWillResignActive {	
	if([self isTracking]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"applicationWillResignActive" object:nil];
		self.currentInterruption = [SCInterruption interruptionStartingNowWithSchoolZoneActive:self.schoolZoneActive phoneRuleActive:self.phoneRuleActive smsRuleActive:self.smsRuleActive];
		[self.currentInterruption setPropertiesFromWaypoint:self.previousWaypoint];
        
		[interruptionsFileHelper writeInterruption:self.currentInterruption withOptionalProperties:NO];
	}	
}

-(void) applicationDidBecomeActive {
	if([self isTracking] && (self.currentInterruption != nil)) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive" object:nil];
		self.currentInterruption.endedAt = [NSDate date];
		[interruptionsFileHelper updateLastInterruption:self.currentInterruption withOptionalProperties:NO];
		self.currentInterruption = nil;
	}
}

-(void) applicationWillTerminate {
	if ([self isTracking]) {
		if(self.currentInterruption) {
			self.currentInterruption.terminatedApp = YES;
			[interruptionsFileHelper updateLastInterruption:self.currentInterruption withOptionalProperties:NO];
		} else {
			self.currentInterruption = [SCInterruption interruptionStartingNowWithSchoolZoneActive:self.schoolZoneActive phoneRuleActive:self.phoneRuleActive smsRuleActive:self.smsRuleActive];
			self.currentInterruption.terminatedApp = YES;
			[interruptionsFileHelper writeInterruption:self.currentInterruption withOptionalProperties:NO];
		}		
	}		
}

-(void) applicationDidFinishLaunching {
	if([InterruptionsFileHelper interruptionsFileExists]) {				
		interruptionsFileHelper = [[InterruptionsFileHelper alloc] initWithNewFile:NO];		
		SCInterruption *lastInterruption = [interruptionsFileHelper readLastInterruption];
		
		if((lastInterruption != nil) && (lastInterruption.endedAt == nil)) {
			self.currentInterruption = lastInterruption;
			self.currentInterruption.endedAt = [NSDate date];
			[interruptionsFileHelper updateLastInterruption:self.currentInterruption withOptionalProperties:NO];
			self.currentInterruption = nil;
		}
		
		if ([self isTracking]) {
			self.continueTrackingAction = kContinueTrackingActionTrackJourney;
		} else if ([self shouldShowAddTrip]) {
			self.continueTrackingAction = kContinueTrackingActionSaveJourney;
		}
		
	} else {
		self.continueTrackingAction = kContinueTrackingActionNone;
	}

}

#pragma mark -
#pragma mark Clean Up

- (void) dealloc {
	[previousWaypoint release];
	[interruptionsFileHelper release];
	[currentInterruption release];
	[super dealloc];
}

@end
