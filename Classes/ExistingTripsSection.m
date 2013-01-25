//
//  ExistingTripsSection.m
//  safecell
//
//  Created by shail on 08/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ExistingTripsSection.h"
#import "PickTripTableCellController.h"
#import "AddTripViewController.h"

@implementation ExistingTripsSection

@synthesize trips;
@synthesize addTripViewController;

- (id) initWithTrips: (NSMutableArray *) tripsArr withAddTripViewController: (AddTripViewController *) theAddTripViewController {
	self = [super initWithoutSetup];
	if (self != nil) {
		self.trips = tripsArr;
		self.addTripViewController = theAddTripViewController;
		[self setupSection];
	}
	return self;
}

-(void)setupSection {
	[self addTripRows];
}

-(void) addTripRows {
	for(SCTrip * trip in self.trips) {
		PickTripTableCellController *cellController = [[PickTripTableCellController alloc] initWithParentSection:self withTrip: trip];
		cellController.cellSelectionAllowed = YES;
		[self.rows addObject:cellController];
		[cellController release];
	}
}

- (void) dealloc {
	[addTripViewController release];
	[trips release];
	[super dealloc];
}


@end
