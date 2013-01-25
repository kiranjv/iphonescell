//
//  ProfileTableCellController.m
//  safecell
//
//  Created by Mobisoft Infotech on 6/23/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "ProfileTableCellController.h"
#import "SCProfile.h"
#import "ManageAccountProfilesViewController.h"
#import "AppDelegate.h"
#import "ProfileDetailsViewController.h"

@implementation ProfileTableCellController


-(SCProfile *) profileForIndexPath: (NSIndexPath *) indexPath {
	ManageAccountProfilesViewController *parentController = (ManageAccountProfilesViewController *)self.parentViewController;
	int row = [indexPath row];
	SCProfile *profile = [parentController.currentAccount.profiles objectAtIndex:row];
	return profile;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	ManageAccountProfilesViewController *parentController = (ManageAccountProfilesViewController *)self.parentViewController;

	SCProfile *profile = [self profileForIndexPath:indexPath];
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName];
	
	if (parentController.currentAccount.masterProfileId == profile.profileId) {
		cell.textLabel.textColor = [UIColor blackColor];
	} else {
		cell.textLabel.textColor = [UIColor darkGrayColor];
	}
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	if (profile.profileId == appDelegate.currentProfile.profileId) {
		cell.textLabel.textColor = [UIColor redColor];
	}

	cell.detailTextLabel.text = profile.phone;
	
	cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	SCProfile *profile = [self profileForIndexPath:indexPath];
	
	BOOL showDeleteButton = NO;
	
	ManageAccountProfilesViewController *parentController = (ManageAccountProfilesViewController *)self.parentViewController;

	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSLog(@"parentController.currentAccount.masterProfileId: %d", parentController.currentAccount.masterProfileId);
	NSLog(@"appDelegate.currentProfile.profileId: %d", appDelegate.currentProfile.profileId);
	
	
	if (profile.profileId == parentController.currentAccount.masterProfileId) {
		//Profile being shown is master profile. Don't show delete button.
		showDeleteButton = NO;
	} else if (parentController.currentAccount.masterProfileId == appDelegate.currentProfile.profileId) {
		showDeleteButton = YES;
	}
	
	ProfileDetailsViewController *viewController = [[ProfileDetailsViewController alloc] initWithProfile:profile showDeleteButton:showDeleteButton];
	viewController.manageAcountProfilesViewConroller = parentController;
	[self.parentViewController.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}

@end
