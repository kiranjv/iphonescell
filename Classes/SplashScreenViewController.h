//
//  SplashScreenViewController.h
//  safecell
//
//  Created by Ben Scheirman on 4/19/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivateDeviceViewController.h"
#import "CreateProfileViewController.h"
#import "PrivacyPolicyViewController.h"
#import "ModalViewControllerDelegate.h"
#import "AccountProxy.h"
#import "ProgressHUD.h"
#import "SCAccount.h"
#import "LoginViewController.h"
#import "SelectProfileViewController.h"

typedef enum PRIVACY_POLICY_SHOWED_FOR {
	PrivacyPolicyShowedForJoinButton,
	PrivacyPolicyShowedForActivateButton,
	PrivacyPolicyShowedForLoginButton
} PrivacyPolicyShowedFor;

@interface SplashScreenViewController : UIViewController<ActivateDeviceViewControllerDelegate, CreateProfileViewControllerDelegate, ModalViewControllerDelegate, AccountProxyDelegate, UIActionSheetDelegate, LoginViewControllerDelegate, SelectProfileViewControllerDelegate> {
	IBOutlet UIButton *joinButton;
	IBOutlet UIButton *loginButton;
	
	PrivacyPolicyViewController *privacyPolicyViewController;
	
	int privacyPolicyShowedFor;
	
	AccountProxy *accountProxy;
	ProgressHUD *progressHUD;
	
	BOOL createdProfileInCurrentRun;
	SCAccount *retrievedAccount;
	BOOL checkedProfileStatusInCurrentRun;
 }

@property (nonatomic, retain) UIButton *joinButton;
@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) PrivacyPolicyViewController *privacyPolicyViewController;
@property (nonatomic, retain) SCAccount *retrievedAccount;

-(IBAction)onJoinSafecell;
-(IBAction)onLogin;

@end
