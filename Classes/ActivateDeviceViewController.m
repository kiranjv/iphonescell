//
//  ActivateDeviceViewController.m
//  safecell
//
//  Created by shail on 21/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ActivateDeviceViewController.h"
#import "UIUtils.h"
#import "AlertHelper.h"
#import "CreateProfileViewController.h" 
#import "AppDelegate.h"

@implementation ActivateDeviceViewController

@synthesize delegate = _delegate;

-(void) showHUD {
	if (progressHUD == nil) {
		progressHUD = [[ProgressHUD alloc] init];
	}
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[progressHUD showHUDWithLable:@"Processing request..." inView:appDelegate.window];
}

-(void) hideHUD {
	[progressHUD hideHUD];
}

-(C1TableSection *)accountVerificationSection {
	if (!accountVerificationSection) {
		accountVerificationSection = [[AccountVerificationSection alloc] init];		
	}
	
	return accountVerificationSection;
}

-(void)addSectionFooter {	
	
	C1TableSection *lastSection = [self.sections lastObject];
	
	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 110)];
	
	UILabel *footerTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 270, 60)];
	footerTextLabel.numberOfLines = 4;
	footerTextLabel.text = lastSection.footerText;
	footerTextLabel.font = [UIFont systemFontOfSize:12];
	footerTextLabel.textColor = [UIUtils colorFromHexColor:@"323232"];
	footerTextLabel.textAlignment = UITextAlignmentCenter;
	footerTextLabel.backgroundColor = [UIColor clearColor];
	[footerView addSubview:footerTextLabel];
	[footerTextLabel release];
	
	//we would like to show a gloosy red button, so get the image first
	UIImage *image = [[UIImage imageNamed:@"button_green.png"]
					  stretchableImageWithLeftCapWidth:8 topCapHeight:8];
	
	//create the button
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	
	//the button should be as big as a table view cell
	[button setFrame:CGRectMake(10, 60, 300, 44)];
	
	//set title, font size and font color
	[button setTitle:@"Validate Account" forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	//set action of the button
	[button addTarget:self action:@selector(validateAccount) forControlEvents:UIControlEventTouchUpInside];
	
	
	//add the button to the view
	[footerView addSubview:button];
	
	
	
	lastSection.footerView = footerView;
	
	[footerView release];
}

-(void)setupTable {
	[self addSection:[self accountVerificationSection]];
	
	[self addSectionFooter];
}

-(id)initWithStyle:(UITableViewStyle)style {
	if(self = [super initWithStyle:style]) {
		
		proxy = [[AccountProxy alloc] init];
		proxy.delegate = self;
		
		[self setupTable];		
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	DecorateNavBarWithLogo(self);
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
											  target:self action:@selector(cancel)] autorelease];
}

-(void)cancel {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}


-(void)dealloc {
	[accountVerificationSection release];
	[proxy release];
	[super dealloc];
}


-(void)validateAccount {
	BOOL validForm = YES;
	for(C1TableSection *sections in [self sections]) {
		if(![sections validateSection]) {
			validForm = NO;
			//stop propagation
			break;
		}
	}
	
	if(validForm) {
		[accountVerificationSection hideKeyboard];
		[self showHUD];
		[proxy validateAccountCode:[accountVerificationSection valueForRowIndex:0]];
	}
}


#pragma mark -
#pragma mark AccountProxyDelegate

-(void) invalidAccountCreationResponse {
	[self hideHUD];
	SimpleAlert(@"Account creation failed", 
				@"Account creation failed due to server error. Please try again later.", 
				@"Ok");
}

-(void) accountNotFound {
	[self hideHUD];
	SimpleAlertOK(@"Account not found", @"The account with the specified key was not found. Please enter the correct key and try again.");
}

-(void) validatedAccount: (SCAccount *) account {
	[self hideHUD];
	if(self.delegate && [self.delegate respondsToSelector:@selector(doneValidatingAccount:)]) {
		[self.delegate doneValidatingAccount:account];
	}	
}


-(void) requestFailed: (ASIHTTPRequest *) request {
	[self hideHUD];
	SimpleAlertOK(@"Network Operation Failed", @"Sorry, the account creation process failed because of a network error.");
}

@end
