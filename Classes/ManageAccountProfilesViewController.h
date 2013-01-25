//
//  ManageAccountDevicesViewController.h
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfilesSection.h"
#import "AccountInformationSection.h"
#import "SCAccount.h"
#import "AccountProxy.h"
#import "ProgressHUD.h"

@interface ManageAccountProfilesViewController : C1TableViewController<AccountProxyDelegate, UIAlertViewDelegate> {
	ProfilesSection *profilesSection;
	AccountInformationSection *accountInformationSection;
	
	SCAccount *currentAccount;
	AccountProxy *accountProxy;
	
	ProgressHUD *progressHUD;
	
	BOOL networkRequestFailed;
	int lastDeletedProfileId;
	
	NSIndexPath *indexPathOfRowBeingDeleted;
}

@property (nonatomic, retain) SCAccount *currentAccount;
@property (nonatomic, assign) BOOL networkRequestFailed;
@property (nonatomic, assign) int lastDeletedProfileId;

-(void) loadData;

@end
