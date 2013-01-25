//
//  SelectProfileViewController.h
//  safecell
//
//  Created by Mobisoft Infotech on 7/19/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TripProxy.h"
#import "AccountProxy.h"
#import "ProgressHUD.h"

@class ProfileListSection;
@class SCProfile;
@class SCAccount;

@protocol SelectProfileViewControllerDelegate;

@interface SelectProfileViewController : C1TableViewController<TripProxyDelegate, AccountProxyDelegate,UIAlertViewDelegate> {
	ProfileListSection *profileListSection;
	SCProfile *selectedProfile;
	SCAccount *account;
	TripProxy *proxy;
	AccountProxy *accountProxy;
	ProgressHUD *progressHUD;
	NSObject<SelectProfileViewControllerDelegate> *delegate;
    UIAlertView *alert;
}

@property (nonatomic, retain) SCProfile *selectedProfile;
@property (nonatomic, retain) SCAccount *account;
@property (nonatomic, assign) NSObject<SelectProfileViewControllerDelegate> *delegate;

-(id)initWithProfiles: (SCAccount *) accountObj;

@end

@protocol SelectProfileViewControllerDelegate 

@optional
-(void) doneSavingAccount;

@end