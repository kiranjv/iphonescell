//
//  SettingsViewController.h
//  safecell
//
//  Created by shail on 06/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootSettingsSection;

@interface SettingsViewController : C1TableViewController {
	RootSettingsSection *rootSettingsSection;
	BOOL finishedSetup;
}

-(RootSettingsSection *) rootSettingsSection;

-(void) setupTable;
-(void) setUpNavigationBar;
-(void) showManageAccountScreen;


@end
