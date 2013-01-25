    //
//  LoginViewController.m
//  safecell
//
//  Created by Mobisoft Infotech on 7/7/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "AlertHelper.h"
#import "UIUtils.h"


@implementation LoginViewController


@synthesize delegate;

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

-(C1TableSection *)loginInformationSection {
	if (!loginInformationSection) {
		loginInformationSection = [[LoginInformationSection alloc] init];		
	}
	
	return loginInformationSection;
}

-(void)createLoginButtonFooter {
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
	[button setTitle:@"Retrieve Profiles" forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	//set action of the button
	[button addTarget:self action:@selector(retriveProfile)
	 forControlEvents:UIControlEventTouchUpInside];
	
	//add the button to the view
	[footerView addSubview:button];
	
	lastSection.footerView = footerView;
	
	[footerView release];
}

-(void)setupTable {
	
	[self addSection:[self loginInformationSection]];
	
	[self createLoginButtonFooter];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) retriveProfile {
	BOOL validForm = YES;
	for(C1TableSection *sections in [self sections]) {
		if(![sections validateSection]) {
			validForm = NO;
			//stop propagation
			return;
		}
	}
	
	if(validForm) {
		[self showHUD];
		[loginInformationSection hideKeyboard];
		NSString *username = [loginInformationSection valueForRowIndex:0];
		NSString *password = [loginInformationSection valueForRowIndex:1];
		[proxy retrieveAccountWithUsername:username password:password];
	}
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

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	proxy.delegate = nil;
	[proxy release];
    [super dealloc];
}


#pragma mark -
#pragma mark AccountProxyDelegate

-(void) receivedAccount: (SCAccount *) account {
	[self hideHUD];
	
	if (self.delegate && [delegate respondsToSelector:@selector(doneRetrievingAccount:)]) {
		[delegate doneRetrievingAccount:account];
	}
}

-(void) requestFailed: (ASIHTTPRequest *) request {
	[self hideHUD];
	
	NSString *operation = [[request userInfo] objectForKey:@"operation"];
	
	if([operation isEqualToString:@"retrieveAccount"]) {
		if (request.responseStatusCode == 0) {
			SimpleAlertOK(@"Profile Retrieval Failed", @"The profile retrieval failed because of a network error.");
		} else {
			SimpleAlertOK(@"Profile Retrieval Failed", @"The profile retrieval failed because of an unexpected error.");
		}
	}
}

-(void) invalidCredentials {
	[self hideHUD];
	SimpleAlertOK(@"Login Failed", @"Invalid username or password.");
}
-(void) managerCheck {
    
    [self hideHUD];
    SimpleAlertOK(@"You Cannot Logged in as a Manager", @"");

}
-(void) profileCheck {
    
    [self hideHUD];
    SimpleAlertOK(@"Your account is inactive. Please call customer service at 1-800-XXX-XXXX to active you account or go to www.safecellapp.mobi with controller account and edit your profile.", @"");
    
}
/*-(void)licenceCheck{
    [self hideHUD];
    int licence =[SCProfile daysTillAccountExpiry];
    NSString *licenceStr = [NSString stringWithFormat:@"Your License Expires On %d dys",licence];
    SimpleAlertOK(licenceStr, @"");
    
}*/


@end
