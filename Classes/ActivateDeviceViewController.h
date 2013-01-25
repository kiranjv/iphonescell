//
//  ActivateDeviceViewController.h
//  safecell
//
//  Created by shail on 21/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "C1TableViewController.h"
#import "AccountVerificationSection.h"
#import "AccountProxy.h"
#import "ProgressHUD.h"

@protocol ActivateDeviceViewControllerDelegate;

@interface ActivateDeviceViewController : C1TableViewController <AccountProxyDelegate> {
	AccountVerificationSection *accountVerificationSection;
	AccountProxy *proxy;
	
	NSObject<ActivateDeviceViewControllerDelegate> *_delegate;
	ProgressHUD *progressHUD;
}

@property (nonatomic, assign) NSObject<ActivateDeviceViewControllerDelegate> *delegate;

-(C1TableSection *)accountVerificationSection;

@end


@protocol ActivateDeviceViewControllerDelegate 

@optional
-(void) doneValidatingAccount: (SCAccount *) account;

@end