//
//  ManageAccountDevicesViewController.m
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ManageAccountProfilesViewController.h"
#import "AccountRepository.h"
#import "AppDelegate.h"
#import "ViewSizeHelper.h"
#import "AlertHelper.h"
#import "AppDelegate.h"

#define kCorrectEmailAlertView 26543

@implementation ManageAccountProfilesViewController

@synthesize currentAccount;
@synthesize networkRequestFailed;
@synthesize lastDeletedProfileId;


-(void) configureAccountProxy {
	accountProxy = [[AccountProxy alloc] init];
	accountProxy.delegate = self;
}

-(void) addDeleteButtonToNavigationBar {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (currentAccount.masterProfileId == appDelegate.currentProfile.profileId) {
		UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteProfileButtonClicked)]; 
		self.navigationItem.rightBarButtonItem = button; 
		[button release]; 
	}
}

-(void) addCancelButtonToNavigationBar {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (currentAccount.masterProfileId == appDelegate.currentProfile.profileId) {
		UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDeleteButtonClicked)]; 
		self.navigationItem.rightBarButtonItem = button; 
		[button release]; 
	}
}

-(void) hideDeleteButton {
	self.navigationItem.rightBarButtonItem = nil;
}

-(void) adjustTableFrame {
	CGRect tableFrame = [ViewSizeHelper potraitBoundsWithStatusBar: YES 
													 navigationBar: YES 
															tabBar: YES 
													locationStripe: YES];
	
	self.tableView.frame = tableFrame;
}

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

-(void) loadData {
	networkRequestFailed = NO;
	AccountRepository *repository = [[AccountRepository alloc] init];
	self.currentAccount = [repository currentAccount];
	[repository release];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[self showHUD];
	[accountProxy getAccount:self.currentAccount.accountId forProfile: appDelegate.currentProfile.profileId deviceKey:appDelegate.currentProfile.deviceKey];
}

-(ProfilesSection *) profilesSection {	
	if(!profilesSection) {
		profilesSection = [[ProfilesSection alloc] initWithoutSetup];
		profilesSection.parentViewController = self;
		[profilesSection setupSection];
	}
	
	return profilesSection;
}

-(AccountInformationSection *) accountInformationSection {
	if(!accountInformationSection) {
		accountInformationSection = [[AccountInformationSection alloc] initWithoutSetup];
		accountInformationSection.parentViewController = self;
		[accountInformationSection setupSection];
	}
	
	return accountInformationSection;
}

-(void) removeDeletedAccount {
	for (SCProfile *tempProfile in self.currentAccount.profiles) {
	
		if (tempProfile.profileId == lastDeletedProfileId) {
			[self.currentAccount.profiles removeObject:tempProfile];
			[[self profilesSection] reloadRows];
			[self.tableView reloadData];
			break;
		}
	}
	
	if (currentAccount.profiles.count == 1) {
		[self hideDeleteButton];
	}
	
}

- (void)viewWillAppear: (BOOL)animated {	
	[self adjustTableFrame];
	[self removeDeletedAccount];
}

-(void) viewDidAppear: (BOOL)animated {
	if (self.currentAccount == nil) {
		[self loadData];
	}
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate configureLocationUpdateRelatedObjects];
}

-(void) setupTable {
	[self addSection:[self profilesSection]];
	[self addSection:[self accountInformationSection]];
}

-(id)init {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self != nil) {		
		DecorateNavBar(self);
		self.navigationItem.title = @"Account";
		[self configureAccountProxy];
		self.lastDeletedProfileId = 0;
		[self setupTable];		
	}
	return self;
}

- (void)dealloc {
	[progressHUD release];
	[profilesSection release];
	[accountInformationSection release];
	[accountProxy release];
	[currentAccount release];
    [super dealloc];
}

-(void) reloadTable {
	[[self profilesSection] setupSection];
	[[self accountInformationSection] setupSection];
	
	if (currentAccount.profiles.count > 1) {
		[self addDeleteButtonToNavigationBar];
	}
	
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark Actions

-(void) acivateAccountButtonClicked {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	NSString * message = [NSString stringWithFormat:@"Further information will be emailed to '%@'."
						  @" Is this the correct email address?",
						  appDelegate.currentProfile.email
						  ];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Activate Subscription" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Send Email", nil];
	alertView.tag = kCorrectEmailAlertView;
	[alertView show];
	[alertView release];
}

-(void) deleteProfileButtonClicked {
	[self.tableView setEditing:YES animated:YES];
	[self addCancelButtonToNavigationBar];
}

-(void) cancelDeleteButtonClicked {
	[self.tableView setEditing:NO animated:YES];
	[self addDeleteButtonToNavigationBar];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    int section = [indexPath section];
	
	if (section > 0) { //Verification code 
		return NO;
	}
			   
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	int section = [indexPath section];
	int row = [indexPath row];
	
	if (section > 0) { //Verification code 
		return  UITableViewCellEditingStyleNone;
	} else if (row == 0) {
		return UITableViewCellEditingStyleNone;
	}
	
	[self addCancelButtonToNavigationBar];
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	int row = [indexPath row];
	
	SCProfile *profile = [self.currentAccount.profiles objectAtIndex:row];
	
	indexPathOfRowBeingDeleted = indexPath;
	[self showHUD];
	[accountProxy deleteProfile:profile.profileId];
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex > 0) { 
		[self showHUD];
		[accountProxy activateAccount];
	}
}

#pragma mark -
#pragma mark AccountProxyDelegate

-(void) activationFailedWithMessage: (NSString *) message {
	[self hideHUD];
	
	if (message == nil) {
		message = @"Activation failed because of an unexpected error.";
	}
	
	SimpleAlertOK(@"Activation Status", message);
}

-(void) activatedAccount: (SCActivation *) activation {
	[self hideHUD];
	AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	SCProfile *currentProfile = delegate.currentProfile;
	NSString *message = [NSString stringWithFormat:
						 @"An email which contains further instructions to complete the activation has been sent to %@. Thank You.", 
						 currentProfile.email];
	SimpleAlertOK(@"Activation Email Sent", message);
}

-(void) receivedAccount: (SCAccount *) account {
	[self hideHUD];
	
	self.currentAccount = account;
	[self.currentAccount sortProfilesById];
	[self reloadTable];
}

-(void) requestFailed: (ASIHTTPRequest *) request {
	[self hideHUD];
	
	NSString *operation = [[request userInfo] objectForKey:@"operation"];
	
	if([operation isEqualToString:@"deleteProfile"]) {
		indexPathOfRowBeingDeleted = nil;
		[self.tableView setEditing:NO animated:YES];
		[self addDeleteButtonToNavigationBar];
		if (request.responseStatusCode == 0) {
			SimpleAlertOK(@"Profile Deletion Failed", @"The profile deletion failed because of a network error.");
		} else {
			SimpleAlertOK(@"Profile Deletion Failed", @"The profile deletion failed because of an unexpected error.");
		}
	}
	
	if([operation isEqualToString:@"getAccount"]) {
		networkRequestFailed = YES;
		[self reloadTable];
	}
	
	if ([operation isEqualToString:@"activateAccount"]) {
		if (request.responseStatusCode == 0) {
			SimpleAlertOK(@"Activation Failed", @"Activation failed because of a network error.");
		} else {
			SimpleAlertOK(@"Activation Failed", @"Activation failed because of an unexpected error.");
		}
	}
}

-(void) deletedProfile {
	[self hideHUD];
	
	int row = [indexPathOfRowBeingDeleted row];
	[self.currentAccount.profiles removeObjectAtIndex:row];
	[[self profilesSection] reloadRows];
	
	[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathOfRowBeingDeleted] withRowAnimation:UITableViewRowAnimationFade];
	
	if (self.currentAccount.profiles.count == 1) {
		[self hideDeleteButton];
		[self.tableView setEditing:NO animated:YES];
	} else {
		[self addDeleteButtonToNavigationBar];
	}
	
	indexPathOfRowBeingDeleted = nil;
}

@end
