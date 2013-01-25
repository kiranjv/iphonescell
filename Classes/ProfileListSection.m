//
//  ProfileListSection.m
//  safecell
//
//  Created by Mobisoft Infotech on 7/19/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "ProfileListSection.h"
#import "SelectProfileViewController.h"
#import "ProfileRowCellController.h"

@implementation ProfileListSection


-(void) addProfileRows {
	SelectProfileViewController *parentController = (SelectProfileViewController *)self.parentViewController;
	int profileCount = [parentController.account.profiles count];

	for(int i = 0; i < profileCount; i++) {
		ProfileRowCellController *cellController = [[ProfileRowCellController alloc] init];
		cellController.cellSelectionAllowed = YES;
		cellController.showDiscloserIndicator = NO;
		cellController.parentViewController = self.parentViewController;
		[self.rows addObject:cellController];
		[cellController release];
	}
}

-(void)setupSection {	
	self.headerText = @"Select Profile";
	[self addProfileRows];		
}


@end
