//
//  LastTripSection.m
//  safecell
//
//  Created by shail on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LastTripSection.h"
#import "SCTripJourney.h"
#import "TripInfoTableCellController.h"
#import "HeaderWithCenteredTitleForSection.h"

@implementation LastTripSection


@synthesize cellController;

- (id) initWithParentController: (UIViewController *) parentController {
	self = [super initWithoutSetup];
	if (self != nil) {
		self.parentViewController = parentController;
		[self setupSection];
	}
	return self;
}


-(void)setupSection {
	self.headerText = @"LAST TRIP";		
	TripInfoTableCellController *tempCellController = [[TripInfoTableCellController alloc] initWithJourney:self.recentJourney];
	self.cellController = tempCellController;
	self.cellController.parentViewController = self.parentViewController;
	[self.rows addObject:cellController];
	[cellController release];
}

-(UIView *) headerView {
	HeaderWithCenteredTitleForSection *headerView = [[[HeaderWithCenteredTitleForSection alloc] initWithFrame:CGRectMake(0, 0, 320, 28)]autorelease];
	headerView.title = self.headerText;	
	return headerView;
}

- (void) dealloc {
	[recentJourney release];
	[super dealloc];
}

-(SCTripJourney *) recentJourney {
	return recentJourney;
}

-(void) setRecentJourney: (SCTripJourney *) journey {
	[journey retain];
	[recentJourney release];
	
	recentJourney = journey;
	
	cellController.journey = recentJourney;
}

@end
