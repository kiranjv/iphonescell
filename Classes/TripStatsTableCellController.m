//
//  TripStatsCellController.m
//  safecell
//
//  Created by shail on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TripStatsTableCellController.h"
#import "SCTripJourney.h"
#import "TripLogViewController.h"
#import "TripStatsTableCell.h"


@implementation TripStatsTableCellController

@synthesize parentViewController;

- (id) initWithParentController: (UIViewController *) parentController {
	self = [super init];
	if (self != nil) {
		self.parentViewController = parentController;
	}
	return self;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *strCellIdentifier = @" TripStatsTableCell";  
	
	TripStatsTableCell *tripStatsTableCell = (TripStatsTableCell *)[tableView dequeueReusableCellWithIdentifier:strCellIdentifier];  
	
	if (tripStatsTableCell == nil) {		
		TripLogViewController * parentController = (TripLogViewController *) parentViewController;
		tripStatsTableCell = [[[TripStatsTableCell alloc] 
							  initWithStyle:UITableViewCellStyleDefault 
							  reuseIdentifier:strCellIdentifier
							   withJourney: parentController.journey] autorelease];			
	}
	
	TripLogViewController * parentController = (TripLogViewController *) parentViewController;	
	
	if (parentController.gameplayStatus) {
		[tripStatsTableCell showPenaltyAndGrade];
	} else {
		[tripStatsTableCell hidePenaltyAndGrade];
	}

	
	return tripStatsTableCell;
}

- (void)dealloc {
	
    [super dealloc];
}

@end
