//
//  ManageProfileViewController.m
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ManageProfileViewController.h"
#import "AppDelegate.h"
#import "AlertHelper.h"
#import "RegexKitLite.h"
#import "RegxKitLiteUtils.h"
#import "LicenseClassRepository.h"

@implementation ManageProfileViewController

@synthesize userProfile;
@synthesize licenseClasses;
@synthesize licenseClassNames;

-(ManageProfileInfoSection *)infoSection {
	if (!infoSection) {
		infoSection = [[ManageProfileInfoSection alloc] init];		
		infoSection.parentViewController = self;
	}
	
	return infoSection;
}

-(void)updateAccountButtonFooter {
	
	
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
	[button setTitle:@"Update Profile" forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	//set action of the button
	[button addTarget:self action:@selector(updateButtonTapped:)
	 forControlEvents:UIControlEventTouchUpInside];
	
	
	//add the button to the view
	[footerView addSubview:button];
	
	
	C1TableSection *lastSection = [self.sections lastObject];
	lastSection.footerView = footerView;
	
	[footerView release];
}

-(void)setupTable {	
	[self addSection:[self infoSection]];
	[infoSection setupSection];
	
	[self updateAccountButtonFooter];
}

-(id)init {
	if(self = [super initWithStyle:UITableViewStyleGrouped]) {		
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		self.userProfile = appDelegate.currentProfile;
		
		[self setupTable];
		
		accountProxy = [[AccountProxy alloc] init];
		accountProxy.delegate = self;
		
		licenseClassProxy = [[LicenseClassProxy alloc] init];
		licenseClassProxy.delegate = self;
		
		NSMutableArray *lcNames = [[NSMutableArray alloc] init];
		self.licenseClassNames = lcNames;
		[lcNames release];
		
		self.tabBarPresent = YES;
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

-(void) updateButtonTapped:(id) sender {
	BOOL validForm = YES;
	
	for(C1TableSection *sections in [self sections]) {
		if(![sections validateSection]) {
			validForm = NO;
			//stop propagation
			return;
		}
	}
	
	NSString *email = [infoSection valueForRowIndex:2];
	if (![email isMatchedByRegex:@"\\b[A-Z0-9._%-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}\\b" options:RKLCaseless inRange:NSMaxiumRange error:nil]) {
		SimpleAlertOK(@"Invalid Email", @"Please enter a valid email address.");
		return;
	}
	
	if(validForm) {		
		userProfile.firstName = [infoSection valueForRowIndex:0];
		userProfile.lastName = [infoSection valueForRowIndex:1];
		userProfile.email = [infoSection valueForRowIndex:2];
		userProfile.phone = [infoSection valueForRowIndex:3];
		
		int selectedLicenseClassIndex = [infoSection selectedLicenseClassIndex];
		SCLicenseClass *selectedLicenseClass = [licenseClasses objectAtIndex:selectedLicenseClassIndex];
		userProfile.licenseClassKey = selectedLicenseClass.key;
		
		[infoSection hideKeyboard];
		[self showHUDWithLable:@"Processing request..."];
		[accountProxy updateProfile:userProfile];
	}
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

	DecorateNavBar(self);
	
	self.navigationItem.title = @"Profile";
	
}

- (void)viewDidAppear:(BOOL)animated {
	self.tableView.frame = self.view.bounds;
	[[self infoSection] setProfile:self.userProfile];
	
	[self downloadLicenseClasses];
}

-(void) viewDidUnload {
}

#pragma mark -
#pragma mark Clean up

- (void)dealloc {
	accountProxy.delegate = nil;
	[accountProxy release];
	
	licenseClassProxy.delegate = nil;
	[licenseClassProxy release];
	
	[userProfile release];
	
	[licenseClasses release];
	[licenseClassNames release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark LicenseClassProxyDelegate

-(void) licenseClassesDownloadFinished: (NSArray *) licenses {
	[self hideHUD];
	self.licenseClasses = licenses;
	
	[self.licenseClassNames removeAllObjects];
	LicenseClassRepository *licenseClassRepository = [[LicenseClassRepository alloc] init];
	for (SCLicenseClass *licenseClass in self.licenseClasses) {
		[licenseClassRepository saveOrUpdateLicenseClass:licenseClass];
		[self.licenseClassNames addObject:licenseClass.name];
	}
	[licenseClassRepository release];
	
	[[self infoSection] setInitialSelectedLicenseClass];
}

-(void) licenseClassesDownloadFailedWithNetworkError: (BOOL) networkError {
	[self hideHUD];
	NSLog(@"MPVC : License classes download failed.");
	
	LicenseClassRepository *licenseClassRepository = [[LicenseClassRepository alloc] init];
	self.licenseClasses = [licenseClassRepository allLicenseClasses];
	[licenseClassRepository release];
	
	[self.licenseClassNames removeAllObjects];
	for (SCLicenseClass *licenseClass in self.licenseClasses) {
		[self.licenseClassNames addObject:licenseClass.name];
	}
	
	[[self infoSection] setInitialSelectedLicenseClass];
}

#pragma mark -
#pragma mark AccountProxyDelegate

-(void) updatedProfile: (SCProfile *) profile {
	[self hideHUD];
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate loadCurrentProfile];
	self.userProfile = appDelegate.currentProfile;
	SimpleAlert(@"Profile updated successfully", @"You profile was updated successfully.", @"Ok");
}

-(void) requestFailed: (ASIHTTPRequest *) request {
	[self hideHUD];
	SimpleAlertOK(@"Network Operation Failed", @"Sorry, the profile update failed because of a network error.");
}

@end
