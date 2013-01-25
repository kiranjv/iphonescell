//
//  SchoolsDownloadManager.h
//  safecell
//
//  Created by shail m on 6/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SchoolProxy.h"
#import "SCWaypoint.h"

@class TrackingViewController;

@interface SchoolsDownloadManager : NSObject<SchoolProxyDelegate> {
	SchoolProxy *schoolProxy;
	SCWaypoint *lastSchoolsdownloadAt;
	TrackingViewController *trackingViewController;
	BOOL lastSchoolFoundStatus;
	
	NSArray *schoolsArr;
}

@property(nonatomic, retain) SCWaypoint *lastSchoolsdownloadAt;
@property(nonatomic, assign) TrackingViewController *trackingViewController;
@property(nonatomic, retain) NSArray *schoolsArr;

-(void) locationChangedtoWaypoint: (SCWaypoint *) waypoint;
-(BOOL) waypoint: (SCWaypoint *) waypoint fallsInSchoolZoneRadius: (float) radius;
-(void) stopSchoolsDownload;

@end

