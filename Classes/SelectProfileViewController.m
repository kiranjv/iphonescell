//
//  SelectProfileViewController.m
//  safecell
//
//  Created by Mobisoft Infotech on 7/19/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "SelectProfileViewController.h"
#import "ProfileListSection.h"
#import "SCProfile.h"
#import "AlertHelper.h"
#import "AppDelegate.h"
#import "AccountRepository.h"
#import "ProfileRepository.h"
#import "TripRepository.h"
#import "SCTripJourney.h"
#import "SCJourneyEvent.h"
#import "LoginViewController.h"

@implementation SelectProfileViewController


@synthesize selectedProfile;
@synthesize account;
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

-(ProfileListSection *) profileListSection {	
	if(!profileListSection) {
		profileListSection = [[ProfileListSection alloc] initWithoutSetup];
		profileListSection.parentViewController = self;
		[profileListSection setupSection];
	}
	
	return profileListSection;
}
-(void)cancel {
	[self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}
/*-(void)licenceValidation{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSDateFormatter *tempFormatter = [[[NSDateFormatter alloc]init]autorelease];
    [tempFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *strdate = [tempFormatter stringFromDate:appDelegate.strStartDate];
    NSDate *startdate = [tempFormatter dateFromString:strdate];
    NSLog(@"startdate ==%@",startdate);
    
    NSDateFormatter *tempFormatter1 = [[[NSDateFormatter alloc]init]autorelease];
     [tempFormatter1 setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
     NSDate *toDate = [tempFormatter1 dateFromString:@"15-01-2013 09:00:00"];
     NSLog(@"toDate ==%@",toDate);
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    //[df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    [df setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *dateString = [df stringFromDate:currentDate];
    NSDate *toDate = [df dateFromString:dateString];
    NSLog(@"dateString is = %@",dateString);
    int i = [startdate timeIntervalSince1970];
    int j = [toDate timeIntervalSince1970];
    double X = j-i;
    int days=(int)((double)X/(3600.0*24.00));
    int years = days/365;
    NSLog(@"Total Days Between::%d",days);
    NSLog(@"Total years Between::%d",years);
    if (days == appDelegate.licenseSubsription*365) {
		
		alert = [[UIAlertView alloc]initWithTitle:@"License Invalid" message:@"Your License was Expired" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
	}

}*/
/*- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"])
    {
        [self cancel];
    }
    
}*/
-(void)createRetrieveButtonFooter {
    
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
	[button setTitle:@"Retrieve Trip Data" forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	//set action of the button
	[button addTarget:self action:@selector(useSelectedPrfoile)
	 forControlEvents:UIControlEventTouchUpInside];
	
	
	//add the button to the view
	[footerView addSubview:button];
	
	
	C1TableSection *lastSection = [self.sections lastObject];
	lastSection.footerView = footerView;
	
	[footerView release];
    
   // [self licenceValidation];
}

-(void) setupTable {
	[self addSection:[self profileListSection]];
	[self createRetrieveButtonFooter];
}

-(void) setupNavigationBar {
	DecorateNavBarWithLogo(self);
	self.navigationItem.title = @"Select Profile";
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
										  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
										  target:self action:@selector(cancel)] autorelease];
}

-(void) updateSelectedProfileWithNewDeviceKey {
	[self.selectedProfile assignUniqueDeviceKey];
	self.selectedProfile.apiKey = self.account.apiKey;
	[accountProxy updateProfile:self.selectedProfile];
}


-(void) useSelectedPrfoile {
	
        
    if (self.selectedProfile == nil) {
		SimpleAlertOK(@"Select Profile", @"Select a profile to fetch associated trip data from the server.");
		return;
	}
	
	[self showHUD];
	[self updateSelectedProfileWithNewDeviceKey];
}


-(id)initWithProfiles: (SCAccount *) accountObj {
    //AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self != nil) {		
		
		proxy = [[TripProxy alloc] init];
		proxy.delegate = self;
		
		accountProxy = [[AccountProxy alloc] init];
		accountProxy.delegate = self;
		
		[self setupNavigationBar];
		self.account = accountObj;
		[self setupTable];		
	}
    /*int licence =[SCProfile daysTillAccountExpiry];
    if (licence > 0) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setDay:licence];
        NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
        NSLog(@"2 nextDate %@", nextDate);
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        NSString *modifiedStr = [formatter stringFromDate:nextDate];
        NSString *licenceStr = [NSString stringWithFormat:@"You SafeCell license will expire on %@. Please log on the www.safecellapp.mobi with your userid and password and renew the license",modifiedStr];
        SimpleAlertOK(licenceStr, @"");
    }
    else if (licence == 0){
        
        NSString *future = [NSString stringWithFormat:@"You are authorize to use the application from %@",app.futuredateString];
        alert = [[UIAlertView alloc]initWithTitle:future message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        //[future release];
    }
    else{
        alert = [[UIAlertView alloc]initWithTitle:@"Your license has expired" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
    }*/
    
	return self;
}


- (void) dealloc {
	proxy.delegate = nil;
	[proxy release];
	
	accountProxy.delegate = nil;
	[accountProxy release];
	
	[account release];
	[selectedProfile release];
	[profileListSection release];
	[super dealloc];
}

#pragma mark -
#pragma mark TripProxyDelegate

-(void) updatedProfile: (SCProfile *) profile {
	[proxy getTripsForProfile:selectedProfile.profileId apiKey:account.apiKey];
}


-(void) receivedTrips: (NSArray *) trips {
	[self hideHUD];
	NSLog(@"count: %d", trips.count);
	
	AccountRepository *accountRepository = [[AccountRepository alloc] init];
	[accountRepository saveAccount:self.account];
	[accountRepository release];
	
	
	ProfileRepository *profileRepository =  [[ProfileRepository alloc] init];
	[profileRepository saveProfile:self.selectedProfile];
	[profileRepository release];
	
	TripRepository *tripRepository = [[TripRepository alloc] init];
	for (SCTrip *trip in trips) {
		[tripRepository saveTrip:trip];
		
		for (SCTripJourney *journey in trip.trips) {
			[tripRepository saveJourney:journey];
			
			for (SCJourneyEvent *event in journey.journeyEvents) {
				[tripRepository saveJourneyEvent:event];
			}
		}
		
	}
	[tripRepository release];
	
	if ((delegate != nil) && [delegate respondsToSelector:@selector(doneSavingAccount)]) {
		[delegate doneSavingAccount];
	}
}

-(void) requestFailed: (ASIHTTPRequest *) request {
	[self hideHUD];
	
	NSString *operation = [[request userInfo] objectForKey:@"operation"];
	
	if([operation isEqualToString:@"getProfile"] || [operation isEqualToString:@"updateProfile"]) {
		
		if ([operation isEqualToString:@"getProfile"]) {
			NSLog(@"Get Profile failed.");
		} else {
			NSLog(@"Update Profile failed.");
		}
		
		if (request.responseStatusCode == 0) {
			SimpleAlertOK(@"Profile Retrieval Failed", @"The profile retrieval failed because of a network error.");
		} else {
			SimpleAlertOK(@"Profile Retrieval Failed", @"The profile retrieval failed because of an unexpected error.");
		}
	}
}

@end
