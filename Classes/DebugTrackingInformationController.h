//
//  DebugTrackingInformationController.h
//  safecell
//
//  Created by Ben Scheirman on 5/13/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCWaypoint.h"

@interface DebugTrackingInformationController : UIViewController {
	double distance;
	int numWaypoints;
	SCWaypoint *lastWaypoint;
	BOOL viewLoaded;
	NSDate *firstWaypointTime;
	
	IBOutlet UILabel *latLabel;
	IBOutlet UILabel *longLabel;
	IBOutlet UILabel *distanceLabel;
	IBOutlet UILabel *speedLabel;
	IBOutlet UILabel *waypointsLabel;
	IBOutlet UILabel *avgSpeedLabel;
	
	UITextView *schoolsView;
	UITextView *rulesView;
}

@property(nonatomic, assign) int numWaypoints;
@property(nonatomic, retain) IBOutlet UITextView *schoolsView;
@property(nonatomic, retain) IBOutlet UITextView *rulesView;

-(void)logWaypoint:(SCWaypoint *)waypoint;
-(IBAction)backToTrackingButtonTapped;

@end
