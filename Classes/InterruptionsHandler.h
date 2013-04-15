//
//  InterruptionsHandler.h
//  safecell
//
//  Created by shail m on 5/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCInterruption.h"
#import "InterruptionsFileHelper.h"
#import "SCWaypoint.h"

typedef enum {
	kContinueTrackingActionNone,
	kContinueTrackingActionTrackJourney,
	kContinueTrackingActionSaveJourney
} ContinueTrackingAction;

@interface InterruptionsHandler : NSObject {
	SCInterruption *currentInterruption;
	InterruptionsFileHelper *interruptionsFileHelper;
	
	SCWaypoint *previousWaypoint;
	
	int continueTrackingAction;
	
	//BOOL schoolZoneActive;
    NSString * schoolZoneActive;
    NSString * mapIntrruption;
	BOOL phoneRuleActive;
	BOOL smsRuleActive;
}

@property(nonatomic, retain) SCWaypoint *previousWaypoint;
@property(nonatomic, assign) int continueTrackingAction;
//@property(nonatomic, assign) BOOL schoolZoneActive;
@property(nonatomic, strong) NSString *schoolZoneActive;
@property(nonatomic, strong) NSString * mapIntrruption;
@property(nonatomic, assign) BOOL phoneRuleActive;
@property(nonatomic, assign) BOOL smsRuleActive;
		  
-(void) trackingPaused;
-(void) trackingResumed;

-(void) wirteMapInterruption;

-(void) applicationWillResignActive;
-(void) applicationDidBecomeActive;

-(void) applicationWillTerminate;
-(void) applicationDidFinishLaunching;

-(void) startTracking;
-(void) stopTracking;


-(NSString *) trackingState;
-(void) setTrackingStateOff;
-(void) setTrackingStateOn;
-(void) setTrackingStateToSave;

@end
