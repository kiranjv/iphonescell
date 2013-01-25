	//
//  TripLogItemsSection.m
//  safecell
//
//  Created by shail on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TripLogItemsSection.h"
#import "TripLogItemCellController.h"
#import "SCTripJourney.h"
#import "SCJourneyEvent.h"
#import "TripLogViewController.h"
#import "HeaderWithCenteredTitleForSection.h"

@implementation TripLogItemsSection

- (id) initWithParentController: (UIViewController *) parentController {
	self = [super initWithoutSetup];
	if (self != nil) {
		self.parentViewController = parentController;
		[self setupSection];
	}
	return self;
}

-(UIView *) headerView {
	HeaderWithCenteredTitleForSection *headerView = [[[HeaderWithCenteredTitleForSection alloc] initWithFrame:CGRectMake(0, 0, 320, 28)]autorelease];
	headerView.title = self.headerText;	
	return headerView;
}

-(void)setupSection {	
	self.headerText = @"TRIP LOG";
	[self addLogRows];
}

-(void) addLogRows {
	TripLogViewController *parentController = (TripLogViewController *) self.parentViewController;
	SCTripJourney *tripJourney = parentController.journey;
	
	int logItemCount = [tripJourney.journeyEvents count];
	
	for(int i = 0; i < logItemCount; i++) {
		TripLogItemCellController *cellController = [[TripLogItemCellController alloc] initWithParentController:self.parentViewController];
		[self.rows addObject:cellController];
		[cellController release];
	}	
}

@end
