//
//  VerificationCodeSection.m
//  safecell
//
//  Created by Mobisoft Infotech on 6/23/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "AccountInformationSection.h"
#import "VerificationCodeCellController.h"
#import "ManageAccountProfilesViewController.h"
#import "ValidUntilCellController.h"
#import "TrialModeCellController.h"
#import "ActivateAccountCellController.h"
#import "AppDelegate.h"

@implementation AccountInformationSection

-(void) addVerificationCodeRow {
	VerificationCodeCellController *cellController = [[VerificationCodeCellController alloc] init];
	cellController.cellSelectionAllowed = NO;
	cellController.showDiscloserIndicator = NO;
	cellController.parentViewController = self.parentViewController;
	[self.rows addObject:cellController];
	[cellController release];
}

/*
-(void) addValidUntilRow {
	ValidUntilCellController *cellController = [[ValidUntilCellController alloc] init];
	cellController.cellSelectionAllowed = NO;
	cellController.showDiscloserIndicator = NO;
	cellController.parentViewController = self.parentViewController;
	[self.rows addObject:cellController];
	[cellController release];
}

-(void) addTrialModeRow {
	TrialModeCellController *cellController = [[TrialModeCellController alloc] init];
	cellController.cellSelectionAllowed = NO;
	cellController.showDiscloserIndicator = NO;
	cellController.parentViewController = self.parentViewController;
	[self.rows addObject:cellController];
	[cellController release];
}
*/

-(void) addActivateAccountRow {
	ActivateAccountCellController *cellController = [[ActivateAccountCellController alloc] init];
	cellController.cellSelectionAllowed = NO;
	cellController.showDiscloserIndicator = NO;
	cellController.parentViewController = self.parentViewController;
	[self.rows addObject:cellController];
	[cellController release];
}

-(void)setupSection {	
	ManageAccountProfilesViewController *parentController = (ManageAccountProfilesViewController *)self.parentViewController;
	int profileCount = 0;
	profileCount = [parentController.currentAccount.profiles count];
	
	if (profileCount > 0) {
		self.headerText = @"Account Information";
		[self.rows removeAllObjects];
		
		[self addVerificationCodeRow];
		
		/*
		[self addValidUntilRow];
		
		if (parentController.currentAccount.isTrial) {
			[self addTrialModeRow];
			AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
			if ((parentController.currentAccount.masterProfileId == appDelegate.currentProfile.profileId) 
				&&
				(!parentController.currentAccount.isActivated)) {
				[self addActivateAccountRow];
			}
		}
		*/
		
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		if ((parentController.currentAccount.masterProfileId == appDelegate.currentProfile.profileId) 
			&&
			(!parentController.currentAccount.isActivated)) {
			[self addActivateAccountRow];
		}
	}
	
}

@end
