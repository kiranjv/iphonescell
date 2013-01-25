//
//  RootViewController.h
//  safecell
//
//  Created by shail on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsViewController.h"


@interface RootViewController : UIViewController {
	UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

-(SettingsViewController *) settingsViewController;

@end
