//
//  EmergencyNumbersListSection.m
//  safecell
//
//  Created by shail m on 6/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EmergencyNumbersListSection.h"
#import "SCEmergencyContact.h"
#import "EmergencyNumberCellController.h"
#import "EmergencyNumbersViewController.h"


@implementation EmergencyNumbersListSection

-(void) addTripRows {
	for(int i = 0; i < kNumberOfMaxEmergencyContacts; i++) {
		EmergencyNumberCellController *cellController = [[EmergencyNumberCellController alloc] init];
		cellController.cellSelectionAllowed = YES;
		cellController.showDiscloserIndicator = YES;
		cellController.parentViewController = self.parentViewController;
		[self.rows addObject:cellController];
		[cellController release];
	}
}

-(void)setupSection {	
	[self addTripRows];
}



- (void) dealloc {	
	[super dealloc];
}


@end
