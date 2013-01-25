//
//  NavBarHelper.m
//  safecell
//
//  Created by Ben Scheirman on 5/13/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "NavBarHelper.h"


void DecorateNavBar(UIViewController *controller) {
	controller.navigationController.navigationBar.tintColor = [UIColor colorWithRed:.35 green:.43 blue:.58 alpha:1];
}

void DecorateNavBarWithLogo(UIViewController *controller) {
	DecorateNavBar(controller);
	NSString *headerImageFilename = @"nav_bar_logo.png";  //@"nav-header-with-logo.png"
	UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:headerImageFilename]];
	controller.navigationItem.titleView = titleImageView;	
	[titleImageView release];
}