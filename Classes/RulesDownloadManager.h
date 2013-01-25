//
//  RulesDownloadManager.h
//  safecell
//
//  Created by shail m on 6/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RuleProxy.h"
#import "RuleRepository.h"
#import "SCWaypoint.h"
#import "SCResolvedLocation.h"
#import "ReverseGeocoder.h"

@class TrackingViewController;

static const int kRulesUpdateRadius = 5;

@interface RulesDownloadManager : NSObject<RuleProxyDelegate, ReverseGeocoderDelegate> {
	RuleProxy *rulesProxy;
	SCWaypoint *lastRulesdownloadAt;
	SCWaypoint *lastknownWaypoint;
	TrackingViewController *trackingViewController;
	NSArray *rulesArr;
	BOOL rulesRequestInProgress;
	
	SCWaypoint *lastReverseGeocodingRequestSentFor;
	SCWaypoint *lastReverseGeocoded;
	SCResolvedLocation *lastResolvedLocation;
	
	NSTimer *ruleRetryForFailureTimer;
}

@property(nonatomic, retain) SCWaypoint *lastRulesdownloadAt;
@property(nonatomic, retain) SCWaypoint *lastknownWaypoint;
@property(nonatomic, assign) TrackingViewController *trackingViewController;
@property(nonatomic, retain) SCWaypoint *lastReverseGeocodingRequestSentFor;
@property(nonatomic, retain) SCWaypoint *lastReverseGeocoded;
@property(nonatomic, retain) SCResolvedLocation *lastResolvedLocation;
@property(nonatomic, retain) NSTimer *ruleRetryForFailureTimer;

-(void) locationChangedtoWaypoint: (SCWaypoint *) waypoint;
-(void) updateRulesStatusAsPerSchoolZone: (BOOL) schoolZone;
-(void) stopRulesDownload;

-(NSArray *) rules;

-(void) useRulesFromDB;

@end
