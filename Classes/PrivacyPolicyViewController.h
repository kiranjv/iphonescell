//
//  PrivacyPolicyViewController.h
//  safecell
//
//  Created by Mobisoft Infotech on 6/28/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModalViewController.h"


@interface PrivacyPolicyViewController : ModalViewController<ModalViewControllerDelegate, UIWebViewDelegate> {
	BOOL userAcceptedPolicy;
	BOOL loadTOS;
	UIButton *agreeButton;
}

@property (nonatomic, assign) BOOL userAcceptedPolicy;

@end
