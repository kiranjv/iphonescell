//
//  SCInterruption.m
//  safecell
//
//  Created by shail m on 5/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SCInterruption.h"
#import "SCTripJourney.h"
#import "SBJSON.h"
#import "ServerDateFormatHelper.h"
#import "JSONHelper.h"
#import "SCWaypoint.h"

@implementation SCInterruption

@synthesize interruptionId;

@synthesize startedAt;
@synthesize endedAt;

@synthesize journeyId;

@synthesize latitude;
@synthesize longitude;

@synthesize estimatedSpeed;

@synthesize paused;
@synthesize terminatedApp;

//@synthesize schoolZoneActive;
@synthesize schoolZoneActive;
@synthesize phoneRuleActive;
@synthesize smsRuleActive;


static NSString *STARTED_AT = @"started_at";
static NSString *ENDED_AT = @"ended_at";
static NSString *TERMINATED_APP = @"terminated_app";

static NSString *INTERRUPTION_ID = @"id";
static NSString *JOURNEY_ID = @"journey_id";

static NSString *LONGITUDE = @"longitude";
static NSString *LATITUDE = @"latitude";

static NSString *ESTIMATED_SPEED = @"estimated_speed";

static NSString *PAUSED = @"paused";

static NSString *SCHOOL_ZONE_ACTIVE = @"school_zone_flag";
static NSString *PHONE_RULE_ACTIVE = @"phone_rule_flag";
static NSString *SMS_RULE_ACTIVE = @"sms_rule_flag";


+(SCInterruption *) interruptionStartingNowWithSchoolZoneActive:(NSString *) schooZoneStatus phoneRuleActive: (BOOL) phoneRuleStatus smsRuleActive: (BOOL) smsRuleStatus; {
	SCInterruption *interruption = [[[SCInterruption alloc] init] autorelease];
	
	interruption.startedAt = [NSDate date];
	interruption.schoolZoneActive = schooZoneStatus;
	interruption.phoneRuleActive = phoneRuleStatus;
	interruption.smsRuleActive = smsRuleStatus;
	
	return interruption;
}

+(SCInterruption *) interruptionWithDictionary: (NSDictionary *) dict includeOptional: (BOOL) includeOptional {
	SCInterruption *interruption = [[[SCInterruption alloc] init] autorelease];
	
	interruption.terminatedApp = [[dict objectForKey:TERMINATED_APP] boolValue];
	
	NSString *startDate  = [dict objectForKey:STARTED_AT];
	interruption.startedAt = [ServerDateFormatHelper dateFormServerString:startDate];
	
	id<NSObject> endDateObj = [dict objectForKey:ENDED_AT];
	
	if(endDateObj != [NSNull null]) {
		NSString *endDate = (NSString *) endDateObj;
		interruption.endedAt = [ServerDateFormatHelper dateFormServerString:endDate];
	} else {
		interruption.endedAt = nil;
	}
	
	interruption.longitude = [[dict objectForKey:LONGITUDE] floatValue];
	interruption.latitude = [[dict objectForKey:LATITUDE] floatValue];
	interruption.estimatedSpeed = [[dict objectForKey:ESTIMATED_SPEED] floatValue];
	
	interruption.paused = [[dict objectForKey:PAUSED] boolValue];

	if(includeOptional) {
		interruption.journeyId = [[dict objectForKey:JOURNEY_ID] intValue];
		interruption.interruptionId = [[dict objectForKey:INTERRUPTION_ID] intValue];
	}
	
	if (kInterruptionUseStatusFlags) {
		
		id schoolZoneActiveObj = [dict objectForKey:SCHOOL_ZONE_ACTIVE];
		
		if (schoolZoneActiveObj == nil) {
			interruption.schoolZoneActive = @"VIOLATION";
		} else {
			//interruption.schoolZoneActive = [schoolZoneActiveObj boolValue];
            interruption.schoolZoneActive = @"VIOLATION";
		}
		
		id phoneRuleActiveObj = [dict objectForKey:PHONE_RULE_ACTIVE];
		
		if (phoneRuleActiveObj == nil) {
			interruption.phoneRuleActive = NO;
		} else {
			interruption.phoneRuleActive = [phoneRuleActiveObj boolValue];
		}
		
		
		id smsRuleActiveObj = [dict objectForKey:SMS_RULE_ACTIVE];
		
		if (smsRuleActiveObj == nil) {
			interruption.smsRuleActive = NO;
		} else {
			interruption.smsRuleActive = [smsRuleActiveObj boolValue];
		}

		
	} else {
		interruption.schoolZoneActive = NO;
		interruption.phoneRuleActive = NO;
		interruption.smsRuleActive = NO;
	}

	
	return interruption;
}

+(SCInterruption *) interruptionWithJSON: (NSString *) JSONRepresentation includeOptional: (BOOL) includeOptional {
	NSDictionary *dict = [JSONHelper dictFromString:JSONRepresentation];
	
	 //NSLog(@"i-dict: %@", dict);
	
	return [SCInterruption interruptionWithDictionary:dict includeOptional:includeOptional];
}

-(NSString *) JSONRepresentationWithOptionalProperties: (BOOL) includeOptional {
	
	SBJSON *jsonHelper = [[SBJSON alloc] init];
	jsonHelper.humanReadable = NO;
	
	NSString *json = [jsonHelper stringWithObject:[self dictionaryRepresentationWithOptionalProperties:includeOptional]];
	
	[jsonHelper release];
	
	return json;
}


-(NSDictionary *) dictionaryRepresentationWithOptionalProperties: (BOOL) includeOptional {
    
	NSMutableDictionary *dictionary = [[[NSMutableDictionary alloc] init] autorelease];
	
	NSString *startedAtDate = [ServerDateFormatHelper formattedDateForJSON:self.startedAt];
	
	[dictionary setObject:startedAtDate forKey:STARTED_AT];
	
	id<NSObject> endedAtDate = [NSNull null];

	if(self.endedAt) {
		endedAtDate = [ServerDateFormatHelper formattedDateForJSON:self.endedAt];
	}
	[dictionary setObject:endedAtDate forKey:ENDED_AT];
	
	//[dictionary setObject:[NSNumber numberWithFloat:self.longitude] forKey:LONGITUDE];
	//[dictionary setObject:[NSNumber numberWithFloat:self.latitude] forKey:LATITUDE];
    NSLog(@"interr long = %f",self.longitude);
    [dictionary setObject:[NSString stringWithFormat:@"%f",self.longitude] forKey:LONGITUDE];
    NSLog(@"interr lat = %f",self.latitude);
    [dictionary setObject:[NSString stringWithFormat:@"%f",self.latitude] forKey:LATITUDE];
	[dictionary setObject:[NSNumber numberWithFloat:self.estimatedSpeed] forKey:ESTIMATED_SPEED];
	
	[dictionary setObject:[NSNumber numberWithBool:self.paused] forKey:PAUSED];
	[dictionary setObject:[NSNumber numberWithBool:self.terminatedApp] forKey:TERMINATED_APP];
	
	if(kInterruptionUseStatusFlags) {
		//[dictionary setObject:[NSNumber numberWithBool:self.schoolZoneActive] forKey:SCHOOL_ZONE_ACTIVE];
        [dictionary setObject:@"VIOLATION" forKey:SCHOOL_ZONE_ACTIVE];
		[dictionary setObject:[NSNumber numberWithBool:self.phoneRuleActive] forKey:PHONE_RULE_ACTIVE];
		[dictionary setObject:[NSNumber numberWithBool:self.smsRuleActive] forKey:SMS_RULE_ACTIVE];
	}
	
	if(includeOptional) {
		[dictionary setObject:[NSNumber numberWithInt:self.interruptionId] forKey:INTERRUPTION_ID];
		[dictionary setObject:[NSNumber numberWithInt:self.journeyId] forKey:JOURNEY_ID];
	}
	
	return dictionary;
}

-(void) dealloc {
	[startedAt release];
	[endedAt release];
	[super dealloc];
}

-(void) setPropertiesFromWaypoint: (SCWaypoint *) waypoint {
	self.longitude = waypoint.longitude;
	self.latitude= waypoint.latitude;
	self.estimatedSpeed = waypoint.estimatedSpeed;
}

-(NSString *) description {
	return [self JSONRepresentationWithOptionalProperties:YES];
}

@end
