//
//  SCInterruption.h
//  safecell
//
//  Created by shail m on 5/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCWaypoint.h"


static const BOOL kInterruptionUseStatusFlags = YES;

@interface SCInterruption : NSObject {
	int interruptionId;
	NSDate *startedAt;
	NSDate *endedAt;
	int journeyId;
	
	float longitude;
	float latitude; 
	
	float estimatedSpeed;
	
	BOOL paused;	
	BOOL terminatedApp;
	
	//BOOL schoolZoneActive;
    NSString *schoolZoneActive;
	BOOL phoneRuleActive;
	BOOL smsRuleActive;
}

@property(nonatomic, assign) int interruptionId;
@property(nonatomic, retain) NSDate *startedAt;
@property(nonatomic, retain) NSDate *endedAt;
@property(nonatomic, assign) int journeyId;
@property(nonatomic, assign) BOOL terminatedApp;

@property(nonatomic, assign) float longitude;
@property(nonatomic, assign) float latitude; 
@property(nonatomic, assign) float estimatedSpeed;
@property(nonatomic, assign) BOOL paused;

//@property(nonatomic, assign) BOOL schoolZoneActive;
@property (nonatomic, strong) NSString *schoolZoneActive;
@property(nonatomic, assign) BOOL phoneRuleActive;
@property(nonatomic, assign) BOOL smsRuleActive;

+(SCInterruption *) interruptionStartingNowWithSchoolZoneActive:(NSString *) schooZoneStatus phoneRuleActive: (BOOL) phoneRuleStatus smsRuleActive: (BOOL) smsRuleStatus;

+(SCInterruption *) interruptionWithJSON: (NSString *) JSONRepresentation includeOptional: (BOOL) includeOptional;
+(SCInterruption *) interruptionWithDictionary: (NSDictionary *) dict includeOptional: (BOOL) includeOptional;

-(NSDictionary *) dictionaryRepresentationWithOptionalProperties: (BOOL) includeOptional;
-(NSString *) JSONRepresentationWithOptionalProperties: (BOOL) includeOptional;
-(void) setPropertiesFromWaypoint: (SCWaypoint *) waypoint;

@end
