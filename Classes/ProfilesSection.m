//
//  ProfilesSection.m
//  safecell
//
//  Created by Mobisoft Infotech on 6/22/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "ProfilesSection.h"
#import "ProfileTableCellController.h"
#import "ManageAccountProfilesViewController.h"
#import "SCAccount.h"
#import "ProfileFetchFailedCellController.h"


@implementation ProfilesSection

-(void) addProfileRows {
	ManageAccountProfilesViewController *parentController = (ManageAccountProfilesViewController *)self.parentViewController;
	int profileCount = 0;
	profileCount = [parentController.currentAccount.profiles count];
	for(int i = 0; i < profileCount; i++) {
		
		ProfileTableCellController *cellController = [[ProfileTableCellController alloc] init];
		cellController.cellSelectionAllowed = YES;
		cellController.showDiscloserIndicator = YES;
		cellController.parentViewController = self.parentViewController;
		[self.rows addObject:cellController];
		[cellController release];
	}
}

-(void) addNetworkErrorCell {
	ProfileFetchFailedCellController *cellController = [[ProfileFetchFailedCellController alloc] init];
	cellController.parentViewController = self.parentViewController;
	[self.rows addObject:cellController];
	[cellController release];
}

-(void)setupSection {	
	ManageAccountProfilesViewController *parentController = (ManageAccountProfilesViewController *)self.parentViewController;
	
	if (parentController.networkRequestFailed) {
		[self.rows removeAllObjects];
		[self addNetworkErrorCell];
	} else {
		int profileCount = 0;
		profileCount = [parentController.currentAccount.profiles count];
		if (profileCount > 0) {
			self.headerText = @"Profiles";
		}
		
		[self.rows removeAllObjects];
		[self addProfileRows];		
	}

}

-(void) reloadRows {
	[self setupSection];
}

@end
