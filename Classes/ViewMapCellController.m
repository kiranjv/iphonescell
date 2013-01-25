//
//  ViewMapCell.m
//  safecell
//
//  Created by shail on 08/05/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "ViewMapCellController.h"
#import "WaypointMapViewController.h"
#import "AddTripViewController.h"

static const int kMaxWaypointsForMap = 200;

@implementation ViewMapCellController

@synthesize journey;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
	
	cell.backgroundView = [[[UIView alloc] initWithFrame:cell.bounds] autorelease];
	cell.backgroundView.backgroundColor = [UIColor whiteColor];
	
	return cell;
}

-(NSMutableArray *) filterWaypointsWithAfterWaypoints: (int) afterWaypoints skipWaypoints: (int) skipWaypoints {
	NSMutableArray * waypointsArray = [[[NSMutableArray alloc] initWithCapacity:kMaxWaypointsForMap] autorelease];
	
	
	for (int i = 0; i < journey.waypoints.count; ) {
		int j = 0;
		for (; j <  afterWaypoints; j++) {
			[waypointsArray addObject:[journey.waypoints objectAtIndex: i + j]];
		}
		
		i += j;
		i += skipWaypoints;		
	}
	
	return waypointsArray;
}

-(NSMutableArray *) waypointsForMap {
	int totalWaypoints = journey.waypoints.count;
	
	if (totalWaypoints > kMaxWaypointsForMap) {
		
		float aboveMapWaypointLimit = totalWaypoints - kMaxWaypointsForMap;
		NSLog(@"Total Waypoints: %d, aboveMapWaypointLimit: %f", totalWaypoints, aboveMapWaypointLimit);
		
		int afterWaypoints = 0;
		int skipWaypoints = 0;
		
		if (aboveMapWaypointLimit < kMaxWaypointsForMap) {
			float afterWaypointsFloat = kMaxWaypointsForMap / aboveMapWaypointLimit;
			afterWaypoints = floor(afterWaypointsFloat);
			skipWaypoints = 1;
		} else {
			afterWaypoints = 1;
			float skipWaypointsFloat = aboveMapWaypointLimit / kMaxWaypointsForMap;
			skipWaypoints = ceil(skipWaypointsFloat);
		}
		
		NSLog(@"afterWaypoints: %d, skipWaypoints: %d", afterWaypoints, skipWaypoints);
		return [self filterWaypointsWithAfterWaypoints:afterWaypoints skipWaypoints:skipWaypoints];
	} else {
		return journey.waypoints;
	}
	
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	
	NSMutableArray *waypointsArr = [self waypointsForMap];
	
	NSLog(@"Original Waypoint Count: %d", journey.waypoints.count);
	NSLog(@"Showing map for Journey...  waypoints: %d", waypointsArr.count);
	
	
	WaypointMapViewController *mapController = [[WaypointMapViewController alloc] initWithWaypoints:waypointsArr];
	
	if (waypointsArr.count < journey.waypoints.count) {
		mapController.simplifiedMap = YES;
	} else {
		mapController.simplifiedMap = NO;
	}
	
	AddTripViewController *addTripViewController = (AddTripViewController *) self.parentViewController;
	[addTripViewController clearPoppedMapWarningFlag];
	mapController.addTripViewController = addTripViewController;
	[self.parentViewController.navigationController pushViewController:mapController animated:YES];
	[mapController release];
}

-(void)routeForPoints{
    
    NSMutableArray *waypointsArr = [self waypointsForMap];
	
	NSLog(@"Original Waypoint Count: %d", journey.waypoints.count);
	NSLog(@"Showing map for Journey...  waypoints: %d", waypointsArr.count);
	
    
    WaypointMapViewController *mapController = [[WaypointMapViewController alloc] initWithWaypoints:waypointsArr];
	
	if (waypointsArr.count < journey.waypoints.count) {
		mapController.simplifiedMap = YES;
	} else {
		mapController.simplifiedMap = NO;
	}
	
	AddTripViewController *addTripViewController = (AddTripViewController *) self.parentViewController;
	[addTripViewController clearPoppedMapWarningFlag];
	mapController.addTripViewController = addTripViewController;
	[self.parentViewController.navigationController pushViewController:mapController animated:YES];
	[mapController release];
    
}


@end
