//
//  NewTripSection.m
//  safecell
//
//  Created by shail on 08/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SaveTripSection.h"
#import "NewTripCellController.h"
#import "PickFromExistingTripsCellController.h"
#import "TripRepository.h"
#import "AddTripViewController.h"
#import "SCTripJourney.h"
#import "HeaderWithCenteredTitleForSection.h"

@implementation SaveTripSection

-(void)setupSection {
	self.headerText = @"SAVE TRIP";
	
	[self addNewTripCell];
	
	/*if([self totalNoOfTrips] > 0) {
		[self addPickFromExistingTripsCell];
	}*/
}

- (void) dealloc {
	[newTripCell release];	
	[pickFromExistingTripsCell release];
	[super dealloc];
}

-(void) addNewTripCell {
	newTripCell = [[NewTripCellController alloc] init];
	newTripCell.label = @"Trip Name";
	newTripCell.info = [self defaultTripTitleText];
	newTripCell.parentViewController = self.parentViewController;
	newTripCell.saveTripSection = self;
	[self.rows addObject:newTripCell];
}

-(void) addPickFromExistingTripsCell {
	pickFromExistingTripsCell = [[PickFromExistingTripsCellController alloc] init];
	pickFromExistingTripsCell.text = @"Pick From Existing Trips";
	pickFromExistingTripsCell.parentViewController = self.parentViewController;
	[self.rows addObject:pickFromExistingTripsCell];
}

-(void) setNewTripTitle:(NSString *) title {
	newTripCell.info = title;
	[self reloadData];
}

-(NSString *) tripTitle {
	return newTripCell.info;
}

-(int) totalNoOfTrips {
	TripRepository *tripRepository = [[TripRepository alloc] init];	
	int totalNoOfTrips = [tripRepository totalNumberOfTrips];	
	[tripRepository release];
	
	return totalNoOfTrips;
}

-(NSString *) defaultTripTitleText {
	AddTripViewController *addTripViewController = (AddTripViewController *)self.parentViewController;
	SCTripJourney * tripJourney = addTripViewController.journey;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MMM d"];
	NSString *tripDate = [dateFormatter stringFromDate:tripJourney.tripDate];
	[dateFormatter release];
	
	NSString * tripTitle = @"";
	
	if (tripDate) {
		tripTitle = [[[NSString alloc] initWithFormat:@"Trip on %@", tripDate] autorelease];
	}
	
	return tripTitle;
}

-(UIView *) headerView {
	HeaderWithCenteredTitleForSection *headerView = [[[HeaderWithCenteredTitleForSection alloc] initWithFrame:CGRectMake(0, 0, 320, 28)]autorelease];
	headerView.title = self.headerText;	
	return headerView;
}

@end
