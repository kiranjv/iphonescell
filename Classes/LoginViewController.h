//
//  LoginViewController.h
//  safecell
//
//  Created by Mobisoft Infotech on 7/7/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginInformationSection.h"
#import "AccountProxy.h"
#import "ProgressHUD.h"
#import "SCAccount.h"

@protocol LoginViewControllerDelegate;

@interface LoginViewController : C1TableViewController<AccountProxyDelegate> {
	LoginInformationSection *loginInformationSection;
	AccountProxy *proxy;
	ProgressHUD *progressHUD;
	NSObject<LoginViewControllerDelegate> *delegate;
}

@property (nonatomic, assign) NSObject<LoginViewControllerDelegate> *delegate;

@end


@protocol LoginViewControllerDelegate 

@optional
-(void) doneRetrievingAccount: (SCAccount *) account;

@end