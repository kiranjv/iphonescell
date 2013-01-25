//
//  SchoolProxy.h
//  safecell
//
//  Created by shail m on 6/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "SCWaypoint.h"
#import "NetworkCallFailureTracker.h"

@protocol SchoolProxyDelegate;

@interface SchoolProxy : NSObject<ASIHTTPRequestDelegate> {
	NSObject<SchoolProxyDelegate> *_delegate;
	ASIHTTPRequest *downloadSchoolsRequest;
	
	
	NetworkCallFailureTracker *failureTracker;
	
	SCWaypoint *currentWaypoint;
	float currentRadius;
}

@property (nonatomic, assign) NSObject<SchoolProxyDelegate> * delegate;
@property (nonatomic, retain) ASIHTTPRequest *downloadSchoolsRequest;
@property (nonatomic, retain) SCWaypoint *currentWaypoint;

-(void) downloadSchoolsForWaypoint: (SCWaypoint *) waypoint distance: (float) radius;
-(void) stopSchoolsDownload;

@end


@protocol SchoolProxyDelegate 

@optional

-(void) schoolsDownloadFinished: (NSArray *) schools forWaypoint: (SCWaypoint *)waypoint;

@end