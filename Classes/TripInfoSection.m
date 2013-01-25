//
//  TripInfoSection.m
//  safecell
//
//  Created by shail on 08/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TripInfoSection.h"
#import "SCTripJourney.h"
#import "ViewMapCellController.h"
#import "HeaderWithCenteredTitleForSection.h"
#import "TripInfoCellController.h"

@implementation TripInfoSection

@synthesize journey;

-(id)initWithTrip:(SCTripJourney *)aJourney parentViewController:(UIViewController *)parentViewController {
	
	if(self = [super initWithoutSetup]) {
		self.journey = aJourney;
		self.parentViewController = parentViewController;
		[self setupSection];
	}
	
	return self;
}

-(void)setupSection {
	self.headerText = @"TRIP INFORMATION";
	
	[self addMilesTravelledCell];
	[self addEstimatedSpeedCell];
	//[self addViewMapCell]; //TEMPORARILY REMOVING MAP TO FOCUS WORK IN OTHER, MORE IMPORTANT AREAS...
}

- (void) dealloc {
	[milesTravelledCell release];
	[estimatedSpeedCell release];
	//[viewMapCell release];
	
	[journey release];
	[super dealloc];
}

-(void) addMilesTravelledCell {	
	milesTravelledCell = [[TripInfoCellController alloc] initWithLabel:@"Miles Traveled" info:[journey milesString]];
	milesTravelledCell.parentViewController = self.parentViewController;
	[self.rows addObject:milesTravelledCell];
}

-(void) addEstimatedSpeedCell {
	estimatedSpeedCell = [[TripInfoCellController alloc] initWithLabel:@"Estimated Speed" info:[journey estimatedSpeedString]];
	estimatedSpeedCell.parentViewController = self.parentViewController;
	[self.rows addObject:estimatedSpeedCell];
}

-(void) addViewMapCell {
	viewMapCell = [[ViewMapCellController alloc] init];
	viewMapCell.text = @"View Map";
	viewMapCell.journey = self.journey;
	viewMapCell.parentViewController = self.parentViewController;
	[self.rows addObject:viewMapCell];
}

-(UIView *) headerView {
	HeaderWithCenteredTitleForSection *headerView = [[[HeaderWithCenteredTitleForSection alloc] initWithFrame:CGRectMake(0, 0, 320, 28)]autorelease];
	headerView.title = self.headerText;	
	return headerView;
}

@end
