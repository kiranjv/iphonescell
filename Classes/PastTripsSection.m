//
//  PastTripsSection.m
//  safecell
//
//  Created by shail on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PastTripsSection.h"
#import "SCTripJourney.h"
#import "TripInfoTableCellController.h"
#import "HeaderWithCenteredTitleForSection.h"

@implementation PastTripsSection

- (id) initWithParentController: (UIViewController *) parentController {
	self = [super initWithoutSetup];
	if (self != nil) {
		self.parentViewController = parentController;
		[self setupSection];
	}
	return self;
}

-(void)setupSection {
	self.headerText = @"PAST TRIPS";	
	[self addPastTrips];
}

-(void) addPastTrips {
	if(pastTrips != nil) {
		for(SCTripJourney *journey in pastTrips) {
			TripInfoTableCellController *cellController = [[TripInfoTableCellController alloc] initWithJourney:journey];
			cellController.parentViewController = self.parentViewController;
			[self.rows addObject:cellController];
			[cellController release];
		}
	}
}

-(UIView *) headerView {
	HeaderWithCenteredTitleForSection *headerView = [[[HeaderWithCenteredTitleForSection alloc] initWithFrame:CGRectMake(0, 0, 320, 28)]autorelease];
	headerView.title = self.headerText;
	
	return headerView;
}

- (void) dealloc {
	[pastTrips release];
	[super dealloc];
}

-(NSMutableArray *) pastTrips {
	return pastTrips;
}

-(void) setPastTrips: (NSMutableArray *) trips {
	[trips retain];
	[pastTrips release];
	pastTrips = trips;
	
	[self.rows removeAllObjects];
	[self addPastTrips];
}

@end
