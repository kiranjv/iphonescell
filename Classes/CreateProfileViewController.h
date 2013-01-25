//
//  CreateProfileViewController.h
//  safecell
//
//  Created by Ben Scheirman on 4/21/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "C1TableViewController.h"
#import "PersonalInformationSection.h"
#import "LinkToAccountSection.h"
#import "AccountProxy.h"
#import "SCAccount.h"
#import "ProgressHUD.h"
#import "LicenseClassProxy.h"


@protocol CreateProfileViewControllerDelegate;

@interface CreateProfileViewController : C1TableViewController <AccountProxyDelegate, LicenseClassProxyDelegate, UIAlertViewDelegate> {
	PersonalInformationSection *personalInformationSection;
	LinkToAccountSection *linkToAccountSection;
	C1TableSection *busDriverSection;
	AccountProxy *accountProxy;
	LicenseClassProxy *licenseClassProxy;
	
	SCAccount *existingAccount;
	
	NSArray *licenseClasses;
	NSMutableArray *licenseClassNames;
	
	NSObject<CreateProfileViewControllerDelegate> *_delegate;
	ProgressHUD *progressHUD;
}

@property (nonatomic, retain) SCAccount *existingAccount;
@property (nonatomic, assign) NSObject<CreateProfileViewControllerDelegate> *delegate;
@property (nonatomic, retain) NSArray *licenseClasses;
@property (nonatomic, retain) NSMutableArray *licenseClassNames;

-(NSArray *) licenseClassNames;

@end


@protocol CreateProfileViewControllerDelegate 

@optional

-(void) didCreateProfile;

@end