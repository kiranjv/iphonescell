//
//  RouteLineAnnotation.m
//  safecell
//
//  Created by Ben Scheirman on 5/11/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "RouteLineAnnotation.h"
#import <MapKit/MapKit.h>
#import "SCWaypoint.h"

@implementation RouteLineAnnotation

@synthesize waypoints = _waypoints;

-(CLLocationCoordinate2D)coordinate {
	SCWaypoint *firstWaypoint = [_waypoints objectAtIndex:0];
	return [firstWaypoint coordinate];
}

- (void)dealloc {
	[_waypoints release];
    [super dealloc];
}


@end
