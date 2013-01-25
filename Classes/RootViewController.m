//
//  RootViewController.m
//  safecell
//
//  Created by shail on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"


@implementation RootViewController

@synthesize tabBarController;

- (void)dealloc {
	[tabBarController release];
    [super dealloc];
}

-(SettingsViewController *) settingsViewController {
	UINavigationController *navController = (UINavigationController *)[tabBarController.viewControllers objectAtIndex:kSettingsTabIndex];
	SettingsViewController *settingsViewController = (SettingsViewController *) [navController.viewControllers objectAtIndex:0];
	
	return settingsViewController;
}


@end
