//
//  DebugTrackingInformationController.m
//  safecell
//
//  Created by Ben Scheirman on 5/13/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "DebugTrackingInformationController.h"
#import "LocationUtils.h"

@implementation DebugTrackingInformationController

@synthesize numWaypoints;
@synthesize schoolsView;
@synthesize rulesView;

const CGFloat SpeedThreshold = 50;

-(void)logWaypoint:(SCWaypoint *)waypoint {
	numWaypoints += 1;
	
	latLabel.text = [NSString stringWithFormat:@"%.4f", waypoint.latitude];
	longLabel.text = [NSString stringWithFormat:@"%.4f", waypoint.longitude];
	waypointsLabel.text = [NSString stringWithFormat:@"%d", numWaypoints];
	
	if (lastWaypoint != nil) {
		//calculate distance
		NSLog(@"Updating distance...");
		double deltaDistance = [LocationUtils distanceFrom:lastWaypoint.coordinate to:waypoint.coordinate];
		NSLog(@"deltaDistance: %f", deltaDistance);
		distance += deltaDistance;
		distanceLabel.text = [NSString stringWithFormat:@"%.3f km", distance];
		
		//calculate speed
		NSLog(@"Updating current speed...");
		NSTimeInterval timeInterval = [waypoint.timeStamp timeIntervalSinceDate:lastWaypoint.timeStamp];
		double hours = timeInterval / 60 / 60;  //seconds / 60 seconds in a minute / 60 minutes in an hour
		double currentEstimatedSpeed = deltaDistance / hours;
		
		//account for crazy values
		if(currentEstimatedSpeed > lastWaypoint.estimatedSpeed + SpeedThreshold || currentEstimatedSpeed < lastWaypoint.estimatedSpeed - SpeedThreshold)
			currentEstimatedSpeed = lastWaypoint.estimatedSpeed;
		
		speedLabel.text = [NSString stringWithFormat:@"%.2f km/h", currentEstimatedSpeed];
		
		//calculate overall average speed
		NSLog(@"Updating avg speed...");
		NSTimeInterval timeSinceFirstWaypoint = [waypoint.timeStamp timeIntervalSinceDate:firstWaypointTime];

		NSLog(@"Total Distance %.2f (km)", distance);
		hours = timeSinceFirstWaypoint / 60 / 60;
		double currentEstimateAvgSpeed = distance / hours;
		avgSpeedLabel.text = [NSString stringWithFormat:@"%.2f km/h", currentEstimateAvgSpeed];
		NSLog(@"avg Speed from debug = %@",[NSString stringWithFormat:@"%.2f km/h", currentEstimateAvgSpeed]);
		[lastWaypoint release];
	} else {
		//first waypoint, record the time
		firstWaypointTime = [waypoint.timeStamp retain];
	}
	lastWaypoint = [waypoint retain];
}

-(IBAction)backToTrackingButtonTapped {
	[self.view removeFromSuperview];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	viewLoaded = YES;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[schoolsView release];
	[rulesView release];
	[firstWaypointTime release];
	[lastWaypoint release];
    [super dealloc];
}


@end
