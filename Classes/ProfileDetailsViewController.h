//
//  ProfileDetailsViewController.h
//  safecell
//
//  Created by Mobisoft Infotech on 6/23/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCProfile.h"
#import "ProfileDetailsSection.h"
#import "AccountProxy.h"
#import "ProgressHUD.h"

@class ManageAccountProfilesViewController;

@interface ProfileDetailsViewController : C1TableViewController<AccountProxyDelegate> {
	SCProfile *profile;
	ProfileDetailsSection *profileDetailsSection;
	BOOL showDeleteButton;
	ManageAccountProfilesViewController *manageAcountProfilesViewConroller;
	AccountProxy *accountProxy;
	
	ProgressHUD *progressHUD;
}

@property (nonatomic, retain) SCProfile *profile;
@property (nonatomic, assign) ManageAccountProfilesViewController *manageAcountProfilesViewConroller;


-(id) initWithProfile:(SCProfile *) profileObj showDeleteButton: (BOOL) deleteButtonPresent;

@end
