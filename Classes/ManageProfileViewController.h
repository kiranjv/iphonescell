//
//  ManageProfileViewController.h
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManageProfileInfoSection.h"
#import "SCProfile.h"
#import "AccountProxy.h"
#import "ProgressHUD.h"
#import "LicenseClassProxy.h"

@interface ManageProfileViewController : C1TableViewController<AccountProxyDelegate, LicenseClassProxyDelegate>  {
	ManageProfileInfoSection *infoSection;
	SCProfile *userProfile;
	AccountProxy *accountProxy;
	LicenseClassProxy *licenseClassProxy;
	
	ProgressHUD *progressHUD;
	
	NSArray *licenseClasses;
	NSMutableArray *licenseClassNames;
	
	BOOL viewDidUnloadExecuted;
}

@property (nonatomic, copy) SCProfile *userProfile;
@property (nonatomic, retain) NSArray *licenseClasses;
@property (nonatomic, retain) NSMutableArray *licenseClassNames;

@end
