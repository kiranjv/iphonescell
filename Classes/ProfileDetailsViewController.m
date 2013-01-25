//
//  ProfileDetailsViewController.m
//  safecell
//
//  Created by Mobisoft Infotech on 6/23/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "ProfileDetailsViewController.h"
#import "ManageAccountProfilesViewController.h"
#import "AlertHelper.h"
#import "AppDelegate.h"


#define kDeleteSuccessMessageTag 23456
#define kConfirmDeleteMessageTag 23457

@implementation ProfileDetailsViewController

@synthesize profile;
@synthesize manageAcountProfilesViewConroller;

-(void) showHUD {
	if (progressHUD == nil) {
		progressHUD = [[ProgressHUD alloc] init];
	}
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[progressHUD showHUDWithLable:@"Processing request..." inView:appDelegate.window];
}

-(void) hideHUD {
	[progressHUD hideHUD];
}

-(void) configureAccountProxy {
	accountProxy = [[AccountProxy alloc] init];
	accountProxy.delegate = self;
}

-(ProfileDetailsSection *) profileDetailsSection {
	if(!profileDetailsSection) {
		profileDetailsSection = [[ProfileDetailsSection alloc] initWithoutSetup];
		profileDetailsSection.parentViewController = self;
		[profileDetailsSection setupSection];
	}
	
	return profileDetailsSection;
}

-(void) setupTable {
	[self addSection:[self profileDetailsSection]];
}

-(void) setupNavigationBar {
	DecorateNavBar(self);
	self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName];
	if (showDeleteButton) {
		UIBarButtonItem *selectButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteProfileButtonClicked)]; 
		self.navigationItem.rightBarButtonItem = selectButton; 
		[selectButton release]; 
	}
}

-(id) initWithProfile:(SCProfile *) profileObj showDeleteButton: (BOOL) deleteButtonPresent {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self != nil) {		
		self.profile = profileObj;
		showDeleteButton = deleteButtonPresent;
		[self configureAccountProxy];
		[self setupNavigationBar];
		[self setupTable];		
	}
	return self;
}

- (void) dealloc {
	[progressHUD release];
	[accountProxy release];
	[profile release];
	[super dealloc];
}


-(void) deleteProfileButtonClicked {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm Deletion" 
														message:@"Do you really want to delete this profile?" 
													   delegate:self 
											  cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	alertView.tag = kConfirmDeleteMessageTag;
	[alertView show];
	[alertView release];
}


#pragma mark -
#pragma mark AccountProxyDelegate

-(void) deletedProfile {
	[self hideHUD];
	self.manageAcountProfilesViewConroller.lastDeletedProfileId = self.profile.profileId;
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Profile Deleted" 
														message:@"The profile was deleted successfully." 
													   delegate:self 
											  cancelButtonTitle:@"OK" otherButtonTitles:nil];
	alertView.tag = kDeleteSuccessMessageTag;
	[alertView show];
	[alertView release];
	
}

-(void) requestFailed: (ASIHTTPRequest *) request {
	[self hideHUD];
	if (request.responseStatusCode == 0) {
		SimpleAlertOK(@"Profile Deletion Failed", @"The profile deletion failed because of a network error.");
	} else {
		SimpleAlertOK(@"Profile Deletion Failed", @"The profile deletion failed because of an unexpected error.");
	}
}

#pragma mark -
#pragma mark UIAlertViewDelegate


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	switch (alertView.tag) {
		case kDeleteSuccessMessageTag:
		{
			[self.navigationController popViewControllerAnimated:YES];
		}
			break;
		case kConfirmDeleteMessageTag:
		{
			if (buttonIndex == 1) {
				[self showHUD];
				[accountProxy deleteProfile:self.profile.profileId];
			}
		}
			break;
	}
	
}


@end
