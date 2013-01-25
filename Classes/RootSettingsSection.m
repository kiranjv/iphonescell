//
//  RootSettingsSection.m
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RootSettingsSection.h"
#import "SettingsItem.h"
#import "SettingsItemCellController.h"
#import "AccountRepository.h"
#import "SCAccount.h"
#import "SCProfile.h"
#import "AppDelegate.h"


@implementation RootSettingsSection

- (id) initWithParentController: (UIViewController *) parentController {
	self = [super initWithoutSetup];
	if (self != nil) {
		self.parentViewController = parentController;
		[self setupSection];
	}
	return self;
}

-(void)setupSection {
	self.headerText = @"";	
	[self setUpSettingsItemsArray];
	[self addSettingsRows];
}

-(BOOL) isMasterProfile {
	AccountRepository *accountRepository = [[AccountRepository alloc] init];
	SCAccount *currentAccount = [accountRepository currentAccount];
	[accountRepository release];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (currentAccount.masterProfileId == appDelegate.currentProfile.profileId) {
		return YES;
	} else {
		return NO;
	}

}

-(void) setUpSettingsItemsArray {
	settingsItems = [[NSMutableArray alloc] initWithCapacity:5];
	
	SettingsItem *gamePlayItem = [[SettingsItem alloc] initWithImage:[UIImage imageNamed:@"gameplay_icon.png"] title:@"Gameplay Settings & Score" controller:@"GameplaySettingsViewController"];
	[settingsItems addObject:gamePlayItem];
	[gamePlayItem release];
	
	SettingsItem *manageProfileItem = [[SettingsItem alloc] initWithImage:[UIImage imageNamed:@"manage_profile_icon.png"] title:@"Manage Profile" controller:@"ManageProfileViewController"];
	[settingsItems addObject:manageProfileItem];
	[manageProfileItem release];
	
	NSString *manageAccountDevicesItemTitle = @"Account Information";
	
	if ([self isMasterProfile]) {
		 manageAccountDevicesItemTitle = @"Manage Account";
	}
	SettingsItem *manageAccountDevicesItem = [[SettingsItem alloc] initWithImage:[UIImage imageNamed:@"manage_account_devices_icon.png"] title:manageAccountDevicesItemTitle controller:@"ManageAccountProfilesViewController"];
	[settingsItems addObject:manageAccountDevicesItem];
	[manageAccountDevicesItem release];
	
	SettingsItem *emergencyNumbersItem = [[SettingsItem alloc] initWithImage:[UIImage imageNamed:@"emergency_numbers_icon.png"] title:@"Emergency Numbers" controller:@"EmergencyNumbersViewController"];
	[settingsItems addObject:emergencyNumbersItem];
	[emergencyNumbersItem release];
	
	SettingsItem *notificationSoundsItem = [[SettingsItem alloc] initWithImage:[UIImage imageNamed:@"bullhorn.png"] title:@"Notification Sounds" controller:@"NotificationSoundsSettingsViewController"];
	[settingsItems addObject:notificationSoundsItem];
	[notificationSoundsItem release];	
}

-(void) addSettingsRows {
	for(SettingsItem * item in settingsItems) {
		SettingsItemCellController *cellController = [[SettingsItemCellController alloc] initWithParentController:self.parentViewController settingsItem:item];
		[self.rows addObject:cellController];
		[cellController release];
	}
}

- (void) dealloc {
	[settingsItems release];
	[super dealloc];
}


@end
