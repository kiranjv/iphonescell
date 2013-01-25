//
//  WayPointFilter.h
//  safecell
//
//  Created by shail m on 6/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCWaypoint.h"
#import "TripRepository.h"

@interface WaypointFilter : NSObject {
	SCWaypoint *lastProcessedWaypoint;
	SCWaypoint *lastApprovedWaypoint;
	
	TripRepository *tripRepository;
	BOOL threwAwayFirstWaypoint;
	
	
}

@property(nonatomic, retain) SCWaypoint *lastProcessedWaypoint;
@property(nonatomic, retain) SCWaypoint *lastApprovedWaypoint;

-(SCWaypoint *) filterWaypoint: (SCWaypoint *) waypoint;

@end
