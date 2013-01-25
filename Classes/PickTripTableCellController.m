//
//  PickTripTableCellController.m
//  safecell
//
//  Created by shail on 08/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PickTripTableCellController.h"
#import "SCTrip.h"
#import "TripInfoTableCell.h"
#import "ExistingTripsSection.h"
#import "AddTripViewController.h"
#import "TripRepository.h"

@implementation PickTripTableCellController

@synthesize parentSection;

- (id) initWithParentSection: (ExistingTripsSection *) existingTripsSection withTrip:(SCTrip *) aTrip {
	self = [super init];
	if (self != nil) {
		self.parentSection = existingTripsSection;
		[self setTrip:aTrip];
	}
	return self;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	cell.accessoryType = UITableViewCellAccessoryNone;	
	
	if(self.parentSection.addTripViewController.selectedTrip == self.trip) {
		cell.accessoryView = nil;
		cell.accessoryType = UITableViewCellAccessoryCheckmark;	
	} else {
		UILabel *accessoryView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
		accessoryView.text = @"";
		accessoryView.backgroundColor = [UIColor clearColor];
		cell.accessoryView = accessoryView;
		[accessoryView release];		
	}
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	self.parentSection.addTripViewController.selectedTrip = self.trip;
	[self performSelector:@selector(reloadTableData) withObject:self afterDelay:0.3];	
}

-(void) reloadTableData {
	[self.parentSection reloadData];
}

- (void) dealloc {
	[parentSection release];
	[trip release];
	[super dealloc];
}

-(SCTrip *) trip {
	return trip;
}

-(void) setTrip: (SCTrip *) aTrip {
	[aTrip retain];
	[trip release];
	trip = aTrip;
	
	self.label = trip.name;	
	
	TripRepository *tripRepository = [[TripRepository alloc] init];
	
	SCTripJourney *mostRecentJourney = [tripRepository mostRecentJourneyWithTrip:trip];
	self.info = [mostRecentJourney milesString];
	
	[tripRepository release];
}	


@end
