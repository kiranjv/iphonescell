//
//  PickTripViewController.m
//  safecell
//
//  Created by shail on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PickTripViewController.h"
#import "ExistingTripsSection.h"
#import "SCTripJourney.h"
#import "AddTripViewController.h"
#import "TripRepository.h"

@implementation PickTripViewController


-(id)initWithStyle:(UITableViewStyle)style withAddTripViewController:(AddTripViewController *) parentViewController {
	self = [super initWithStyle:style];
	if (self != nil) {
		
		self.navigationItem.title = @"Select Existing Trip";
		[self setAddTripViewController: parentViewController];
		[self setupTable];		
		
	}
	return self;
}

- (void) dealloc
{
	[existingTripsSection release];
	[addTripViewController release];
	[super dealloc];
}

-(AddTripViewController *) addTripViewController {
	return addTripViewController;
}

-(void) setAddTripViewController: (AddTripViewController *)theAddTripViewController {
	[addTripViewController release];
	addTripViewController = [theAddTripViewController retain];
	existingTripsSection.addTripViewController = theAddTripViewController;
}

-(void) setupTable {
	[self addSection:[self existingTripsSection]];
}

-(ExistingTripsSection *) existingTripsSection {	
	NSMutableArray *existingTrips = [self loadExistingTrips];
	
	if(!existingTripsSection) {
		existingTripsSection = [[ExistingTripsSection alloc] initWithTrips:existingTrips withAddTripViewController: addTripViewController];
		existingTripsSection.parentViewController = self;
	}
	
	return existingTripsSection;
}

-(NSMutableArray *)loadExistingTrips {	
	TripRepository *tripRepository = [[TripRepository alloc] init];
	NSMutableArray *tripsArr = [tripRepository trips];
	[tripRepository release];
	return tripsArr;	
}


@end
