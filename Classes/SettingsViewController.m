//
//  SettingsViewController.m
//  safecell
//
//  Created by shail on 06/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "RootSettingsSection.h"
#import "ManageAccountProfilesViewController.h"


@implementation SettingsViewController



-(void)loadView {	
	//if (!finishedSetup) {
		[self setUpNavigationBar];
		[self setupTable];
		
		self.style = UITableViewStyleGrouped;
		
		[super loadView];
		finishedSetup = YES;
	//}	
}

-(void) setUpNavigationBar {	
	DecorateNavBar(self);
	self.navigationItem.title = @"Settings";	
}

-(void) setupTable {
	if (!rootSettingsSection) {
		[self addSection:[self rootSettingsSection]];
	}
}

-(RootSettingsSection *) rootSettingsSection {	
	if(!rootSettingsSection) {		
		rootSettingsSection = [[RootSettingsSection alloc] initWithParentController:self];		
	}
	
	return rootSettingsSection;
}

- (void)dealloc {
	[rootSettingsSection release];
    [super dealloc];
}

-(void) showManageAccountScreen {
	self.navigationItem.title = @"Settings";
	ManageAccountProfilesViewController *manageAccountProfilesViewController = [[ManageAccountProfilesViewController alloc] init];
	[self.navigationController pushViewController:manageAccountProfilesViewController animated:NO];
	[manageAccountProfilesViewController release];
}


@end
