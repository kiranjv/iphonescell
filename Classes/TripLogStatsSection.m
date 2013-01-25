//
//  TripLogStatsSection.m
//  safecell
//
//  Created by shail on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TripLogStatsSection.h"
#import "HeaderWithCenteredTitleForSection.h"
#import "TripStatsTableCellController.h"
#import "C1TableCellController.h"
#import "SCTripJourney.h"
#import "TripLogViewController.h"

@implementation TripLogStatsSection

- (id) initWithParentController: (UIViewController *) parentController {
	self = [super initWithoutSetup];
	if (self != nil) {
		self.parentViewController = parentController;
		[self setupSection];
	}
	return self;
}

-(void)setupSection {	
	TripLogViewController *parentController = (TripLogViewController *) self.parentViewController;
	
	self.headerText = [parentController.journey.tripName uppercaseString];		
	
	TripStatsTableCellController *tempCellController = [[TripStatsTableCellController alloc] initWithParentController: self.parentViewController];
	tempCellController.parentViewController = self.parentViewController;
	[self.rows addObject:tempCellController];
	[tempCellController release];
}

-(UIView *) headerView {
	HeaderWithCenteredTitleForSection *headerView = [[[HeaderWithCenteredTitleForSection alloc] initWithFrame:CGRectMake(0, 0, 320, 28)]autorelease];
	headerView.title = self.headerText;	
	return headerView;
}

@end
