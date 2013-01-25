    //
//  CreateProfileViewController.m
//  safecell
//
//  Created by Ben Scheirman on 4/21/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "CreateProfileViewController.h"
#import "C1TableSection.h"
#import "C1PlainCell.h"
#import "TableViewFormField.h"
#import "FormFieldCellController.h"
#import "PersonalInformationSection.h"
#import "AppDelegate.h"
#import "AlertHelper.h"
#import "RegexKitLite.h"
#import "RegxKitLiteUtils.h"
#import "SCLicenseClass.h"
#import "LicenseClassRepository.h"
#import "UserDefaults.h"
#import "KeyUtils.h"

// #define kAccountCreationAlertView 23671
#define kLicenseClassDownloadFailed 23672

@implementation CreateProfileViewController

@synthesize existingAccount;
@synthesize delegate = _delegate;
@synthesize licenseClasses;
@synthesize licenseClassNames;

-(PersonalInformationSection *)personalInformationSection {
	if (!personalInformationSection) {
		personalInformationSection = [[PersonalInformationSection alloc] initWithoutSetup];		
		personalInformationSection.parentViewController = self;
		[personalInformationSection setupSection];
	}

	return personalInformationSection;
}

-(C1TableSection *)busDriverSection {
	if(!busDriverSection) {
		NSArray *switches = [NSArray arrayWithObjects:					   
							 [TableViewFormField switchFieldWithLabel:@"Bus Driver?" hint:nil],
							 nil];
		busDriverSection = [[C1TableSection alloc] init];
		for(TableViewFormField *field in switches)
			[busDriverSection.rows addObject:[[[FormFieldCellController alloc] initWithField:field] autorelease]];
		
		busDriverSection.footerText = @"Bus drivers may be subject to additional cell phone laws.";
	}
	
	return busDriverSection;
}

-(C1TableSection *)linkToAccountSection {
	if(!linkToAccountSection) {
		linkToAccountSection = [[LinkToAccountSection alloc] init];
	}
	return linkToAccountSection;
}

-(void)createAccountButtonFooter {
	

	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
	
	//we would like to show a gloosy red button, so get the image first
	UIImage *image = [[UIImage imageNamed:@"button_green.png"]
					  stretchableImageWithLeftCapWidth:8 topCapHeight:8];
	
	//create the button
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	
	//the button should be as big as a table view cell
	[button setFrame:CGRectMake(10, 20, 300, 44)];
	
	//set title, font size and font color
	[button setTitle:@"Create Account" forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	//set action of the button
	[button addTarget:self action:@selector(createAccount)
	 forControlEvents:UIControlEventTouchUpInside];
	
	
	//add the button to the view
	[footerView addSubview:button];
	
	
	C1TableSection *lastSection = [self.sections lastObject];
	lastSection.footerView = footerView;
	
	[footerView release];
}

-(void)setupTable {
	
	//section 1
	[self addSection:[self personalInformationSection]];
	
	//section 2
	//[self addSection:[self busDriverSection]];
	
	//section 3
	//[self addSection:[self linkToAccountSection]];

	[self createAccountButtonFooter];
}

-(id)initWithStyle:(UITableViewStyle)style {
	if(self = [super initWithStyle:style]) {
		
		accountProxy = [[AccountProxy alloc] init];
		accountProxy.delegate = self;
		
		licenseClassProxy = [[LicenseClassProxy alloc] init];
		licenseClassProxy.delegate = self;
		
		NSMutableArray *lcNames = [[NSMutableArray alloc] init];
		self.licenseClassNames = lcNames;
		[lcNames release];
		
		[self setupTable];
		
	}
	
	return self;
}


-(void) showHUDWithLable:(NSString *) label {
	if (progressHUD == nil) {
		progressHUD = [[ProgressHUD alloc] init];
	}
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[progressHUD showHUDWithLable:label inView:appDelegate.window];
}

-(void) hideHUD {
	[progressHUD hideHUD];
}

-(void)createAccount {
	BOOL validForm = YES;
	for(C1TableSection *sections in [self sections]) {
		if(![sections validateSection]) {
			//stop propagation
			return;
		}
	}
	
	NSString *email = [personalInformationSection valueForRowIndex:2];
	if (![email isMatchedByRegex:@"\\b[A-Z0-9._%-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}\\b" options:RKLCaseless inRange:NSMaxiumRange error:nil]) {
		SimpleAlertOK(@"Invalid Email", @"Please enter a valid email address.");
		return;
	}
	
	if(validForm) {
		SCProfile *profile = [[[SCProfile alloc] init] autorelease];
		profile.firstName = [personalInformationSection valueForRowIndex:0];
		profile.lastName = [personalInformationSection valueForRowIndex:1];
		profile.email = [personalInformationSection valueForRowIndex:2];
		profile.phone = [personalInformationSection valueForRowIndex:3];
        profile.phone = [personalInformationSection valueForRowIndex:3];
        
		/* code commented by surjan*/
		int selectedLicenseClassIndex = [personalInformationSection selectedLicenseClassIndex];
		SCLicenseClass *selectedLicenseClass = [licenseClasses objectAtIndex:selectedLicenseClassIndex];
		profile.licenseClassKey = selectedLicenseClass.key;
		
		if(self.existingAccount) {
			profile.apiKey = self.existingAccount.apiKey;
			profile.accountId = self.existingAccount.accountId;
		}
		
		[self showHUDWithLable:@"Creating profile..."];
		[personalInformationSection hideKeyboard];
		
		[profile assignUniqueDeviceKey];
		[accountProxy registerProfile:profile];
	}
}

-(void)cancel {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) downloadLicenseClasses {
	if (!self.licenseClasses) {
		[self showHUDWithLable:@"Retrieve license classes..."];
		[licenseClassProxy downloadLicenseClasses];
	}	
}

#pragma mark -
#pragma mark View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	DecorateNavBarWithLogo(self);
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
											  target:self action:@selector(cancel)] autorelease];
	
	NSString* guid = [KeyUtils GUID];
	[UserDefaults setValue:guid forKey:kAccountGUID];
}

- (void)viewDidAppear:(BOOL)animated {
	[self downloadLicenseClasses];
}

- (void)viewWillDisappear:(BOOL)animated {
	[[self personalInformationSection] hideKeyboard];
	self.tableView.frame = self.view.frame;
}

#pragma mark -
#pragma mark Clean up

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	accountProxy.delegate = nil;
	[accountProxy release];
	
	licenseClassProxy.delegate = nil;
	[licenseClassProxy release];
	
	[personalInformationSection release];
	[busDriverSection release];
	[linkToAccountSection release];
	
	[licenseClasses release];
	[licenseClassNames release];
	
	[existingAccount release];
	
	[super dealloc];
}

/*
-(void) showHomeScreen {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate loadTabBar];
	[self.view removeFromSuperview];
}
*/


#pragma mark -
#pragma mark LicenseClassProxyDelegate

-(void) licenseClassesDownloadFinished: (NSArray *) licenses {
    /* COMMENT MADE BY SURJAN TO AVOID ALERT POPUP*/
	[self hideHUD];
	self.licenseClasses = licenses;
	
	[self.licenseClassNames removeAllObjects];
	LicenseClassRepository *licenseClassRepository = [[LicenseClassRepository alloc] init];
	for (SCLicenseClass *licenseClass in self.licenseClasses) {
		[licenseClassRepository saveOrUpdateLicenseClass:licenseClass];
		[self.licenseClassNames addObject:licenseClass.name];
	}
	[licenseClassRepository release];
}

-(void) licenseClassesDownloadFailedWithNetworkError: (BOOL) networkError {
	[self hideHUD];
	/*COMMENT MADE BY SURJAN TO AVOID ALERT POPUP*/
	NSString *title = @"Request Failed";
	NSString *message = @"The license class request failed because of an unexpected error.";
	
	if (networkError) {
		message = @"The license class request failed because of a network error.";
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Quit" otherButtonTitles: @"Retry", nil];
	alert.delegate = self;
	alert.tag = kLicenseClassDownloadFailed;
	[alert show];
	[alert release];	
}


#pragma mark -
#pragma mark AccountProxyDelegate


#pragma mark Acivation

//-(void) showActivationFailedAlert {
//	NSString *title = @"Activation Failed";
//	NSString *message = @"The trial account was created successfully but the activation email sending failed. Please go to the 'Manage Account' screen under Settings to send the activation email again.";
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//	alert.tag = kAccountCreationAlertView;
//	[alert show];
//	[alert release];
//}
//
//-(void) activationFailedWithMessage: (NSString *) message {
//	[self hideHUD];
//	
//	[self showActivationFailedAlert];
//}
//
//-(void) activatedAccount: (SCActivation *) activation {
//	[self hideHUD];
//	
//	NSString *title = @"Trial Account Created";
//	NSString *message = @"Your trial account was created. An email which contains further instructions to activate your account has been sent to you. Thank You.";
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//	alert.tag = kAccountCreationAlertView;
//	[alert show];
//	[alert release];
//}

#pragma mark Account Creation

-(void) accountCreationFaliedWithMessage: (NSString *) message {
	[self hideHUD];
	
	if (message == nil) {
		message = @"Account creation failed because of an unexpected error.";
	}
	
	SimpleAlertOK(@"Activation Status", message);
}

-(void) createdAccount: (SCAccount *) account andProfile: (SCProfile *) profile {	
	//[progressHUD setLabel:@"Sending activation email..."];
//	[accountProxy activateAccount];	
	
	NSLog(@"Clearing the user defaults");
	[UserDefaults setValue:@"" forKey:kAccountGUID];
	
	[self hideHUD];
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(didCreateProfile)]) {
		[self.delegate didCreateProfile];
	}
}

-(void) createdProfile: (SCProfile *) profile {
	if(self.delegate && [self.delegate respondsToSelector:@selector(didCreateProfile)]) {
		[self.delegate didCreateProfile];
	}	
}

-(void) requestFailed: (ASIHTTPRequest *) request {
	[self hideHUD];
	//NSString *operation = [[request userInfo] objectForKey:@"operation"];
	
	//if ([operation isEqualToString:@"activateAccount"]) {
//		[self showActivationFailedAlert];
//		return;
//	} else {
		SimpleAlertOK(@"Network Operation Failed", @"Sorry, the account creation process failed because of a network error.");
	//}	
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	//if (alertView.tag == kAccountCreationAlertView) {
//		if(self.delegate && [self.delegate respondsToSelector:@selector(didCreateProfile)]) {
//			[self.delegate didCreateProfile];
//		}
//		
//		return;
//	}
	
	if (alertView.tag == kLicenseClassDownloadFailed) {
		if (buttonIndex == [alertView cancelButtonIndex]) {
			exit(0);
		} else {
			[self downloadLicenseClasses];
			return;
		}
	}
}

@end
