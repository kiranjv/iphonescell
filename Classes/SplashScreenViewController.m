//
//  SplashScreenViewController.m
//  safecell
//
//  Created by Ben Scheirman on 4/19/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "AppDelegate.h"
#import "SplashScreenViewController.h"
#import "CreateProfileViewController.h"
#import "HomeScreenViewController.h"
#import "ActivateDeviceViewController.h"
#import "PrivacyPolicyViewController.h"
#import "LoginViewController.h"
#import "AlertHelper.h"
#import "SettingsViewController.h"

#import "AppSettingsItemRepository.h"
#import "AccountRepository.h"
#import "ProfileRepository.h"
#import "TripRepository.h"
#import "RuleRepository.h"
#import "EmergencyContactRepository.h"
#import "SelectProfileViewController.h"
#import "ManageAccountProfilesViewController.h"


static const NSInteger kCreateAccountButtonIndex = 0;
static const NSInteger kAccountCodeButtonIndex = 1;


#define kRequestFailedAlertViewTag 23786
#define kProfileStatusAlertViewTag 23787
#define kTrialExpiredAlertViewTag 23789
#define kActivationFailedAlertViewTag 23790
#define kExitAppAfterActivationAlertViewTag 23791
#define kProfileTerminatedAlertViewTag 23792
#define kDeleteDataBeforeNewProfileAletViewTag 23793
#define kProfileInUseAlertViewTag 23794

static NSString *NEW_PROFILE_BUTTON_TITLE =  @"New Profile";
static NSString *EXISTING_PROFILE_BUTTON_TITLE = @"Existing Profile";
static NSString *CANCEL_BUTTON_TITLE = @"Cancel";

static NSString *MOVE_PROFILE_TO_THIS_DEVICE_OPTION = @"Move profile to this device";
static NSString *DELETE_PROFILE_OPTION =  @"Delete this profile";
static NSString *DELETE_PROFILE_SHORT_OPTION = @"Delete profile";

@implementation SplashScreenViewController

@synthesize joinButton;
@synthesize loginButton;
@synthesize privacyPolicyViewController;
@synthesize retrievedAccount;


-(NSTimeInterval) timeSinceLastProfileDownload {
	AppSettingsItemRepository *settingsRepository = [[AppSettingsItemRepository alloc] init];
	NSDate *lastProfileDownloadedOn = [settingsRepository profileDownloadedOn];
	NSLog(@"lastProfileDownloadedOn: %@", lastProfileDownloadedOn);
	[settingsRepository release];
	
	NSDate *now = [NSDate date];
	NSLog(@"now: %@", now);
	NSTimeInterval difference = [now timeIntervalSinceDate:lastProfileDownloadedOn];
	return difference;
}

-(BOOL) wasProfileDownloadedInLastTwentyFourHours {
	NSTimeInterval interval = [self timeSinceLastProfileDownload];
	NSLog(@"interval: %f", interval);
	if(interval < 86400) {
		return YES;
	} else {
		return NO;
	}
}


-(void) showHUD {
	if (progressHUD == nil) {
		progressHUD = [[ProgressHUD alloc] init];
	}
	
	// AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	// [progressHUD showHUDWithLable:@"Loading..." inView:appDelegate.window];
	
	[progressHUD showHUDWithLable:@"Loading..." inView:self.view];
}

-(void) hideHUD {
	[progressHUD hideHUD];
}

-(void) configureAccountProxy {
	accountProxy = [[AccountProxy alloc] init];
	accountProxy.delegate = self;
}


-(void) showPrivacyPolicy: (PrivacyPolicyShowedFor) flag {
	privacyPolicyShowedFor = flag;
	
	PrivacyPolicyViewController *policyViewController = [[PrivacyPolicyViewController alloc] init];
	self.privacyPolicyViewController = policyViewController;
	self.privacyPolicyViewController.delegate = self;
	[policyViewController release];
	
	[policyViewController showModalFromTop];
}

-(IBAction)onJoinSafecell {
	[self showPrivacyPolicy:PrivacyPolicyShowedForJoinButton];
}
-(void) showLoginViewController {
	LoginViewController *loginController = [[LoginViewController alloc] initWithStyle:UITableViewStyleGrouped];
	loginController.delegate = self;
	UINavigationController *navController = [[UINavigationController alloc] 
											 initWithRootViewController:loginController];
	[self presentViewController:navController animated:YES completion:nil];
	[loginController release];
}

-(IBAction)onLogin {
    
    [self showPrivacyPolicy:PrivacyPolicyShowedForLoginButton];
    //[self showLoginViewController];
	/*AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	UIActionSheet *actionSheet = nil;
	
	if ([self wasProfileDownloadedInLastTwentyFourHours]) {
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"Profile Status" 
									delegate:self 
						   cancelButtonTitle:CANCEL_BUTTON_TITLE 
					  destructiveButtonTitle:nil 
						   otherButtonTitles:NEW_PROFILE_BUTTON_TITLE, nil];
	} else {
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"Profile Status" 
									delegate:self 
						   cancelButtonTitle:CANCEL_BUTTON_TITLE 
					  destructiveButtonTitle:nil 
						   otherButtonTitles:EXISTING_PROFILE_BUTTON_TITLE, NEW_PROFILE_BUTTON_TITLE, nil];
	}

	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:appDelegate.window];
	[actionSheet release];*/
    
}

-(void) showJoinSafecellViewController {
	CreateProfileViewController *createProfileController = [[CreateProfileViewController alloc] initWithStyle:UITableViewStyleGrouped];
	createProfileController.delegate = self;
	UINavigationController *navController = [[UINavigationController alloc]
											 initWithRootViewController:createProfileController];
	
	[self presentModalViewController:navController animated:YES];
	[createProfileController release];
}

-(void) showActivateDeviceViewController {
	ActivateDeviceViewController *activateDeviceViewController = [[ActivateDeviceViewController alloc] initWithStyle:UITableViewStyleGrouped];
	activateDeviceViewController.delegate = self;
	UINavigationController *navController = [[UINavigationController alloc] 
											 initWithRootViewController:activateDeviceViewController];
	
	[self presentModalViewController:navController animated:YES];
	[activateDeviceViewController release];	
}

-(void) showHomeScreen {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate loadTabBar: 0];
	[self.view removeFromSuperview];
}

-(void) showSettingsScreen {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate loadTabBar: kSettingsTabIndex];
	[self.view removeFromSuperview];
	SettingsViewController *settingsViewController =  [appDelegate.rootController settingsViewController];
	settingsViewController.navigationController.navigationBar.tintColor = [UIColor colorWithRed:.35 green:.43 blue:.58 alpha:1];
	[settingsViewController showManageAccountScreen];
}

-(void) showFaxScreen {
    /*Show fax data*/
    NSLog(@"FaxButton clicked");
}

-(void) hideAccountButtons {
	joinButton.hidden = YES;
	loginButton.hidden = YES;
}

-(void) showAccountButtons {
	joinButton.hidden = NO;
	loginButton.hidden = NO;
}

- (void)viewDidLoad {
    
	[self configureAccountProxy];
	createdProfileInCurrentRun = FALSE;
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    //[df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss Z"];
   
    NSString *dateString = [df stringFromDate:date];
    NSLog(@"dateString is = %@",dateString);
    
  //  [self showLoginViewController];

}
-(void)viewWillAppear:(BOOL)animated{
    
    
  /*  NSDateFormatter *tempFormatter = [[[NSDateFormatter alloc]init]autorelease];
    [tempFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSDate *startdate = [tempFormatter dateFromString:@"15-01-2011 09:00:00"];
    NSLog(@"startdate ==%@",startdate);
    
    NSDateFormatter *tempFormatter1 = [[[NSDateFormatter alloc]init]autorelease];
    [tempFormatter1 setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSDate *toDate = [tempFormatter1 dateFromString:@"15-01-2013 09:00:00"];
    NSLog(@"toDate ==%@",toDate);
    
    int i = [startdate timeIntervalSince1970];
    int j = [toDate timeIntervalSince1970];
    
    double X = j-i;
    
    int days=(int)((double)X/(3600.0*24.00));
    int years = days/365;
    NSLog(@"Total Days Between::%d",days);
     NSLog(@"Total years Between::%d",years);*/
   /* NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:startdate
                                                 toDate:toDate
                                                options:0];
    
    NSLog(@"Difference in date components: %i/%i/%i", components.day, components.month, components.year);*/
    
   
   [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	
    ProfileRepository *repository = [[ProfileRepository alloc] init];
	
	if([repository profileExists] && !checkedProfileStatusInCurrentRun) {
		[self hideAccountButtons];
		if (!createdProfileInCurrentRun) {
			[self showHUD];
			AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
			[appDelegate loadCurrentProfile];
			[accountProxy checkCurrentProfileStatus];
		}
		
		checkedProfileStatusInCurrentRun = YES;
	}
	[repository release];
}

-(void) showCreateProfileViewController: (SCAccount*) account {
	CreateProfileViewController *createProfileController = [[CreateProfileViewController alloc] initWithStyle:UITableViewStyleGrouped];
	createProfileController.delegate = self;
	UINavigationController *navController = [[UINavigationController alloc] 
												 initWithRootViewController:createProfileController];
	createProfileController.existingAccount = account;
	[self presentModalViewController:navController animated:YES];
	[createProfileController release];
}


- (void) dealloc {
	[retrievedAccount release];
	[progressHUD release];
	[accountProxy release];
	[joinButton release];
	[loginButton release];
	[privacyPolicyViewController release];
	[super dealloc];
}

/*
-(void) showLoginToWebAccountForTrialMessage: (SCAccount *) account {
	NSString *message = @"Your trial account has expired. Please login to http://my.safecellapp.com/ to purchase a subscription.";
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Trail Expired" message:message delegate:self cancelButtonTitle:@"Quit" otherButtonTitles: nil];
	alertView.tag = kExitAppAfterActivationAlertViewTag;
	[alertView show];
	[alertView release];
}

-(void) showLoginToWebAccountForRenewalMessage: (SCAccount *) account {
	NSString *message = @"Your subscription has expired. Please login to http://my.safecellapp.com/ to renew the subscription.";
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Trail Expired" message:message delegate:self cancelButtonTitle:@"Quit" otherButtonTitles: nil];
	alertView.tag = kExitAppAfterActivationAlertViewTag;
	[alertView show];
	[alertView release];
}


-(void) showTrialExpiredActivateMessage: (SCAccount *) account {
	
	AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
	SCProfile *profile = appDelegate.currentProfile;
	
	NSString *message = nil;
	UIAlertView *alertView = nil;
	
	if (profile.profileId == account.masterProfileId) {
		message = [NSString stringWithFormat:@"Your trial period has expired. Please activate your account."];
		alertView = [[UIAlertView alloc] initWithTitle:@"Trial Mode " message:message delegate:self cancelButtonTitle:@"Quit" otherButtonTitles:@"Activate", nil];
	} else {
		message = [NSString stringWithFormat:@"Your trial period has expired. Please  ask the account owner to activate the account. The app will now terminate. Please restart the app after activation."];
		alertView = [[UIAlertView alloc] initWithTitle:@"Trial Mode " message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	}
	
	alertView.tag = kTrialExpiredAlertViewTag;
	
	[alertView show];
	[alertView release];
}


-(void) showDaysTrialProfileSatusMessage: (SCAccount *) account {
	
	AppSettingsItemRepository *appSettings = [[AppSettingsItemRepository alloc] init];
	NSDate *lastActivationWarningShownOn = [appSettings activateShownOn];
	NSDate *currentDate = [NSDate date];
	NSTimeInterval interval = [currentDate timeIntervalSinceDate:lastActivationWarningShownOn];
	NSLog(@"interval: %@, %@, %d", lastActivationWarningShownOn, currentDate, interval);
	BOOL showHomeScreen = NO;
	if(interval < 86400) { // (24 * 60 * 60) - seconds of day
		showHomeScreen = YES;
	} else {
		[appSettings updateActivateShownOn:currentDate];
	}

	[appSettings release];
	
	if (showHomeScreen) {
		[self showHomeScreen];
		return;
	}
	
	int daysTillValid = [account daysTillAccountExpiry];
	
	// Adding 1 below because current day has already started to the division by 86400 seconds
	// will return one day less.
	daysTillValid += 1; 
	
	NSString *message = nil;
	AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
	SCProfile *profile = appDelegate.currentProfile;
	
	if (daysTillValid == 1) {
		message = [NSString stringWithFormat:@"Today is the last day of your trial."];
	} else {
		message = [NSString stringWithFormat:@"%d more days are remaining.", daysTillValid];
	}
	
	UIAlertView *alertView = nil;
	
	
	if ((profile.profileId == account.masterProfileId)) {
		if (account.isActivated) {
			alertView = [[UIAlertView alloc] initWithTitle:@"Trial Mode " message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		} else {
			alertView = [[UIAlertView alloc] initWithTitle:@"Trial Mode " message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Activate", nil];
		}
	} else {
		message = [NSString stringWithFormat:@"%@ %@", message, @"The account owner can activate the subscription. "];
		alertView = [[UIAlertView alloc] initWithTitle:@"Trial Mode " message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	}
	
	alertView.tag = kProfileStatusAlertViewTag;
	[alertView show];
	[alertView release];
	
}

-(BOOL) hasAccountExpired:(SCAccount *) account {
	int daysTillValid = [account daysTillAccountExpiry];
	if (daysTillValid < 0) {
		return YES;
	} else {
		return NO;
	}
}

-(void) showAccountTrialMessage: (SCAccount *) account {
	
	if ([self hasAccountExpired:account]) {
		if (account.isActivated) {
			[self showLoginToWebAccountForTrialMessage: account];
		} else {
			[self showTrialExpiredActivateMessage:account];
		}
	} else {
		[self showDaysTrialProfileSatusMessage:account];
	}

}
*/
-(void) deleteAllData {
	
	AccountRepository *accountRepository = [[AccountRepository alloc] init];
	[accountRepository deleteExistingAccount];
	[accountRepository release];
	
	
	ProfileRepository *profileRepository = [[ProfileRepository alloc] init];
	[profileRepository deleteProfile];
	[profileRepository release];
	
	
	TripRepository *tripRepository = [[TripRepository alloc] init];
	[tripRepository deleteAllTrips];
	[tripRepository deleteAllJourneys];
	[tripRepository deleteAllWaypoints];
	[tripRepository deleteAllJourneyEvents];
	[tripRepository deleteAllInterruptions];
	
	[tripRepository clearSchoolProximityData];
	[tripRepository release];
	
	
	RuleRepository *ruleRepository = [[RuleRepository alloc] init];
	[ruleRepository deleteAllRules];
	[ruleRepository release];
	
	
	EmergencyContactRepository *emergencyContactRepository = [[EmergencyContactRepository alloc] init];
	[emergencyContactRepository deleteAllContacts];
	[emergencyContactRepository release];
	
	AppSettingsItemRepository *appSettingsItemRepository = [[AppSettingsItemRepository alloc] init];
	[appSettingsItemRepository updateGameplaySetting:YES];
	[appSettingsItemRepository release];
}

-(void) showSelectProfileController: (SCAccount *) account {
	SelectProfileViewController *modalController = [[SelectProfileViewController alloc] initWithProfiles:account];
	modalController.delegate = self;
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:modalController];
	navController.navigationBar.tintColor = [UIColor colorWithRed:.35 green:.43 blue:.58 alpha:1];
	[self presentModalViewController:navController animated:YES];
	[navController release];
	[modalController release];
}

-(void) showModalManageAccountProfilesViewController {
	ManageAccountProfilesViewController *manageAccountProfilesViewController = [[ManageAccountProfilesViewController alloc] init];
	
	UINavigationController *navController = [[UINavigationController alloc] 
											 initWithRootViewController:manageAccountProfilesViewController];
	navController.navigationBar.tintColor = [UIColor colorWithRed:.35 green:.43 blue:.58 alpha:1];
	
	[self presentModalViewController:navController animated:YES];
	[manageAccountProfilesViewController release];
	[navController release];
}

#pragma mark -
#pragma mark ActivateDeviceViewControllerDelegate

-(void) doneValidatingAccount: (SCAccount *) account {
	[self dismissModalViewControllerAnimated:YES];
	
	[self performSelector:@selector(showCreateProfileViewController:) withObject:account afterDelay:0.8];
}

#pragma mark -
#pragma mark LoginViewControllerDelegate

-(void) doneRetrievingAccount: (SCAccount *) account {
	self.retrievedAccount = account;
	[self dismissModalViewControllerAnimated:YES];
	[self performSelector:@selector(showSelectProfileController:) withObject:account afterDelay:0.8];
}

#pragma mark -
#pragma mark CreateProfileViewControllerDelegate

-(void) didCreateProfile {
	
	createdProfileInCurrentRun = YES;
	[self dismissModalViewControllerAnimated:YES];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate loadCurrentProfile];
	
	[self showHomeScreen];
}

#pragma mark -
#pragma mark SelectProfileViewControllerDelegate

-(void) doneSavingAccount {
	createdProfileInCurrentRun = YES;
	[self dismissModalViewControllerAnimated:YES];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate loadCurrentProfile];
	
	AppSettingsItemRepository *settingsRepository = [[AppSettingsItemRepository alloc] init];
	[settingsRepository updateProfileDownloadedOn:[NSDate date]];
	[settingsRepository release];
	
	[self showHomeScreen];
}

#pragma mark -
#pragma mark ModalViewControllerDelegate

-(void) modalViewDidHide {
	if (self.privacyPolicyViewController.userAcceptedPolicy) {
		
		switch (privacyPolicyShowedFor) {
			case PrivacyPolicyShowedForJoinButton:
				[self showJoinSafecellViewController];
				break;
			case PrivacyPolicyShowedForActivateButton:
				[self showActivateDeviceViewController];
				break;
			case PrivacyPolicyShowedForLoginButton:
				[self showLoginViewController];
				break;
		}
	}
	
	self.privacyPolicyViewController = nil;
}


#pragma mark -
#pragma mark AccountProxyDelegate

-(void) activationFailedWithMessage: (NSString *) message {
	[self hideHUD];
	
	if (message == nil) {
		message = @"Activation failed because of an unexpected error.";
	}
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Activation Status" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	alertView.tag = kExitAppAfterActivationAlertViewTag;
	[alertView show];
	[alertView release];	
}

-(void) activatedAccount: (SCActivation *) activation {
	[self hideHUD];
	AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	SCProfile *currentProfile = delegate.currentProfile;
	NSString *message = [NSString stringWithFormat:
						 @"An email containing further instructions has been sent to you. The app will now terminate." 
						 @"Please restart the app after you have completed activation procedure.", 
						 currentProfile.email];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Activation Email Sent" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	alertView.tag = kExitAppAfterActivationAlertViewTag;
	[alertView show];
	[alertView release];
}



-(void) receivedCheckedProfileAndAccount: (SCAccount *) account {
	NSLog(@"Account Id: %d", account.accountId);
	NSLog(@"is Activated: %d", account.isActivated);
	
	[self hideHUD];
	
	/*
	if ([account.accountStatus isEqualToString:@"ok"]) {
		
		if (account.isTrial) {
			[self showAccountTrialMessage: (SCAccount *) account];
			return;
		}
		
		if ([self hasAccountExpired:account]) {
			[self showLoginToWebAccountForRenewalMessage:account];
			return;
		}
		
		
	} else {
		//if ([self hasAccountExpired:account]) {
			
			if (account.isTrial) {
				[self showAccountTrialMessage: (SCAccount *) account];
				return;
			} else {
				[self showLoginToWebAccountForRenewalMessage:account];
				return;
			}
		//}
	}
	*/
	
	[self showHomeScreen];
}

-(void) checkCurrentProfileStatusFailed: (ASIHTTPRequest *) request {
	UIAlertView * alertView = nil;
	if (request.responseStatusCode == 404) {
		alertView = [[UIAlertView alloc] initWithTitle:@"Profile Not Found" message:@"Your profile was not found. It might have been deleted by the master account owner." delegate:self cancelButtonTitle:@"Quit" otherButtonTitles: @"Start Over", nil];
		alertView.tag = kProfileTerminatedAlertViewTag;
	} else if (request.responseStatusCode == 0) {
		alertView = [[UIAlertView alloc] initWithTitle:@"Account Sync" message:@"Account Sync failed because of a network error." delegate:self cancelButtonTitle:@"Quit" otherButtonTitles:@"Retry", nil];
		alertView.tag = kRequestFailedAlertViewTag;
	}  else if ((request.responseStatusCode == 400) && [[request responseString] equalsIgnoreCase:@"Invalid Device Key"]) {
		if ([self wasProfileDownloadedInLastTwentyFourHours]) {
			alertView = [[UIAlertView alloc] initWithTitle:@"Profile in Use" message:@"This profile is already in use on another device." delegate:self cancelButtonTitle:@"Quit" otherButtonTitles: DELETE_PROFILE_SHORT_OPTION, nil];
		} else {
			alertView = [[UIAlertView alloc] initWithTitle:@"Profile in Use" message:@"This profile is already in use on another device." delegate:self cancelButtonTitle:@"Quit" otherButtonTitles:MOVE_PROFILE_TO_THIS_DEVICE_OPTION, DELETE_PROFILE_OPTION, nil];
		}

		alertView.tag = kProfileInUseAlertViewTag;
	} else {
		alertView = [[UIAlertView alloc] initWithTitle:@"Account Sync" message:@"Account Sync failed because of an unexpected error." delegate:self cancelButtonTitle:@"Quit" otherButtonTitles:@"Retry", nil];
		alertView.tag = kRequestFailedAlertViewTag;
	}
	
	
	[alertView show];
	[alertView release];
}

-(void) activateAccountRequestFailed: (ASIHTTPRequest *) request {
	NSString *message = @"";
	if (request.responseStatusCode == 0) {
		message = @"Activation failed because of a network error.";
	} else {
		message = @"Activation failed because of an unexpected error.";
	}
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Activation Failed" message:message delegate:self cancelButtonTitle:@"Quit" otherButtonTitles:@"Retry", nil];
	alertView.tag = kActivationFailedAlertViewTag;
	[alertView show];
	[alertView release];
}

-(void) requestFailed: (ASIHTTPRequest *) request {
	[self hideHUD];
	
	NSString *operation = [[request userInfo] objectForKey:@"operation"];
	
	if([operation isEqualToString:@"checkCurrentProfileStatus"]) {
		[self checkCurrentProfileStatusFailed:request];
		return;
	}
	
	if ([operation isEqualToString:@"activateAccount"]) {
		[self activateAccountRequestFailed:request];
	}
}

#pragma mark -
#pragma mark UIAlertViewDelegate

-(void) requestFailedAlertView:(UIAlertView *) alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		exit(0);
	} else {
		[self showHUD];
		[accountProxy checkCurrentProfileStatus];
	}
}

-(void) profileStatusAlertView:(UIAlertView *) alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		[self showHomeScreen];
	} else {
		[self showSettingsScreen];
	}
}

-(void) trialExpiredAlertView:(UIAlertView *) alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		exit(0);
	} else {
		[self showModalManageAccountProfilesViewController];
		/*
		[self showHUD];
		[accountProxy activateAccount];
		 */
	}
}

-(void) ativationFailedAlertView:(UIAlertView *) alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		exit(0);
	} else {
		[self showHUD];
		[accountProxy activateAccount];
	}
}

-(void) profileTerminatedAlertView:(UIAlertView *) alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		exit(0);
	} else {
		NSString *message = @"This will erase all of the trip data on your phone. Are you sure you want to do this?";
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Start New Profile" message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
		alertView.tag = kDeleteDataBeforeNewProfileAletViewTag;
		[alertView show];
		[alertView release];
	}

}

-(void) deleteDataBeforeNewProfileAlertView:(UIAlertView *) alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		exit(0);
	} else {
		[self deleteAllData];
		[self showAccountButtons];
	}
}

-(void) profileInUseAlertView:(UIAlertView *) alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == alertView.cancelButtonIndex) {
		exit(0);
	} 
	
	NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
	
	if ([buttonTitle isEqualToString:MOVE_PROFILE_TO_THIS_DEVICE_OPTION]) {
		[self showLoginViewController];
		return;
	} else {
		[self deleteAllData];
		[self showAccountButtons];
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	switch (alertView.tag) {
		case kRequestFailedAlertViewTag:
			[self requestFailedAlertView:alertView didDismissWithButtonIndex:buttonIndex];
			break;
		case kProfileStatusAlertViewTag:
			[self profileStatusAlertView:alertView didDismissWithButtonIndex:buttonIndex];
			break;
		case kTrialExpiredAlertViewTag:
			[self trialExpiredAlertView:alertView didDismissWithButtonIndex:buttonIndex];
			break;
		case kActivationFailedAlertViewTag:
			[self ativationFailedAlertView:alertView didDismissWithButtonIndex:buttonIndex];
			break;
		case kProfileTerminatedAlertViewTag:
			[self profileTerminatedAlertView:alertView didDismissWithButtonIndex:buttonIndex];
			break;
		case kDeleteDataBeforeNewProfileAletViewTag:
			[self deleteDataBeforeNewProfileAlertView:alertView didDismissWithButtonIndex:buttonIndex];
			break;
		case kProfileInUseAlertViewTag:
			[self profileInUseAlertView:alertView didDismissWithButtonIndex:buttonIndex];
			break;
		case kExitAppAfterActivationAlertViewTag:
			exit(0);
	}
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
		if (buttonIndex != [actionSheet cancelButtonIndex]) {
			
			NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
			
			if ([buttonTitle isEqualToString:EXISTING_PROFILE_BUTTON_TITLE]) {
				[self showPrivacyPolicy:PrivacyPolicyShowedForLoginButton];
				return;
			}
			
				 
			if ([buttonTitle isEqualToString:NEW_PROFILE_BUTTON_TITLE]) {
				[self showPrivacyPolicy:PrivacyPolicyShowedForActivateButton];
				return;
			}
			
		}
}

@end
