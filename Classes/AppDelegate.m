//
//  safecellAppDelegate.m
//  safecell
//
//  Created by Ben Scheirman on 3/16/10.
//  Copyright ChaiONE 2010. All rights reserved.
//

#import "AppDelegate.h"
#import "BundleUtils.h"
#import "DatabaseMigrator.h"
#import "AbstractRepository.h"
#import "ProfileRepository.h"
#import "ResourceManager.h"
#import "RuleRepository.h"
#import "FlurryAPI.h"
#import "UncaughtExceptionHandler.h"
#import <unistd.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "HomeScreenViewController.h"
#import "WayPointsFileHelper.h"
#import "AddTripViewController.h"

#define CURRENT_SCHEMA_VERSION 18

static const int kDefaultImageViewTag = 12567;

@implementation AppDelegate

@synthesize currentSpeed;
@synthesize window;
@synthesize viewController;

@synthesize rootController;

@synthesize currentProfile;
@synthesize interruptionsHandler;
@synthesize locationHelper;
@synthesize reachabilityCheckTimer;
@synthesize managerCheckingValue,masterProfileKeyValue;
@synthesize strStartDate,licenseSubsription,strEndDate,strExpiredDate;
@synthesize futuredateString,phoneNumber,speedValue,totalMiles,tripStopTime;
@synthesize currentLatValue,currentLongValue,profileStatusCheck;
@synthesize disableWebValue,logWayPointValue,is_abandon_trip;
@synthesize tripStartTime;
@synthesize isTripStarted;
@synthesize is_AppBackground;
@synthesize isSaveTrip;


-(void)calculateSpeed :(CLLocation *)location{
    
    
}
-(void) startLocationHelper {
	if (!locationHelper) {
		locationHelper = [[LocationHelper alloc] init];
	}
	[locationHelper startUpdatingLocation];
}

-(void) stopLocationHelper {
	[locationHelper stopUpdatingLocation];
}

-(void) createLocationStripe {
	locationStripeController = [[LocationStripeController alloc] init];
}

-(void) configureLocationUpdateRelatedObjects {	
	if (locationStripeController == nil) {
		[self createLocationStripe];
		[self addLocationStripe];
		[self startLocationHelper];
	}
}

-(void) copyResourcesToDocumentsDir {
	ResourceManager *resourceManager = [[ResourceManager alloc] init];
	[resourceManager copyResourcesToDocumentsDirectory];	
	[resourceManager release];
}

-(void) initializeDatabase {
	DatabaseMigrator *dbMigrator = [[DatabaseMigrator alloc] initWithDatabaseFile:[AbstractRepository databaseFilename]];
	
	//for development only - toggle this to force the new database over
	//dbMigrator.overwriteDatabase = YES;
	
	[dbMigrator moveDatabaseToUserDirectoryIfNeeded];
	[dbMigrator migrateToVersion:CURRENT_SCHEMA_VERSION];
	[dbMigrator release];
}

-(void) addLocationStripe {
	CGRect frame = locationStripeController.view.frame;
	frame.origin.y = 419;
	locationStripeController.view.frame = frame;
	[self.rootController.tabBarController.view addSubview:locationStripeController.view];
}

-(void) loadTabBar: (int) showIndex {	
	rootController = [[RootViewController alloc] init];
	[[NSBundle mainBundle] loadNibNamed:@"TabBar" owner:rootController options:nil];
	rootController.tabBarController.selectedIndex = showIndex;
	[window addSubview:rootController.tabBarController.view];
}

-(void) loadCurrentProfile {
	ProfileRepository *profileRepository = [[ProfileRepository alloc] init];
	self.currentProfile = [profileRepository currentProfile];
	
	if(self.currentProfile.appVersion != [BundleUtils bundleVersion]) {
		//update the version # of the device we're using
		self.currentProfile.appVersion = [BundleUtils bundleVersion];
		NSLog(@"Updating the version # on the profile to %@", currentProfile.appVersion);
		[profileRepository saveProfile:self.currentProfile];
	}

	[FlurryAPI setUserID:[NSString stringWithFormat:@"Profile: %d", currentProfile.profileId]];
	[profileRepository release];
}

-(void) setupInterruptionsHandler {
	InterruptionsHandler *handler = [[InterruptionsHandler alloc] init];
	self.interruptionsHandler = handler;
	[handler release];
}

-(void) cleanUpRules {
	RuleRepository *ruleRepository = [[RuleRepository alloc] init];
	[ruleRepository cleanUpRules];	
	[ruleRepository release];
}

-(void) configureAudioSession {
	AudioSessionInitialize (NULL, NULL, NULL, NULL);
	UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof (sessionCategory), &sessionCategory);
	OSStatus propertySetError = 0;
	UInt32 allowMixing = true;
	propertySetError |= AudioSessionSetProperty(kAudioSessionProperty_OtherMixableAudioShouldDuck, sizeof(allowMixing), &allowMixing);
}

-(void) performPostReachabilityCheckStartUp {
	if( getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled") ) {
		NSLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
	}
	
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	
	[self initializeDatabase];
   // [self isTripDataExist];
	[self copyResourcesToDocumentsDir];
	[self cleanUpRules];
	[self setupInterruptionsHandler];	
	[self.interruptionsHandler applicationDidFinishLaunching];
	[self configureAudioSession];
	// --------------- changes made ------------------
	[window addSubview:viewController.view];
	
	if (![window isKeyWindow]) {
		[window makeKeyAndVisible];
	}
}

-(void) isTripDataExist {
    NSLog(@"isTripdataExist metod");
    WayPointsFileHelper *wayPointsFileHelper = [[WayPointsFileHelper alloc] initWithNewFile:NO];
    int count = [wayPointsFileHelper countWaypointsInFile];	
    [wayPointsFileHelper release];
    NSLog(@"total points in journey= %d",count);
    NSString *stringData = [NSString stringWithFormat:@"Came from switch off. PRevious trip total points:%d", count];
   // [ self showAlertView: stringData];
    if (count > 5) {
        NSLog(@"Activating falg to add trip view data to save server");
        self.isSaveTrip = @"YES";
        NSLog(@"isSaveTrip status:%@",isSaveTrip);
        
//               AddTripViewController * addTripViewController = [[AddTripViewController alloc] initWithStyle:UITableViewStylePlain];
//        [addTripViewController saveTripButtonTapped];
////        addTripViewController.delegate = self;
//        UINavigationController *navController = [[UINavigationController alloc]
//                                                 initWithRootViewController:addTripViewController];
//        
//        //Hack to get the right tint color since DecorateNavBar(self); in AddTripViewController does nothing.
//        navController.navigationBar.tintColor = [UIColor colorWithRed:.35 green:.43 blue:.58 alpha:1];
//        
//        [self presentViewController:navController animated:YES completion:nil];
//        
//        [addTripViewController release];
//        [navController release];
    }
    
   
    
 
}

-(void) showWaitingForReachabilityMessage {
	if (waitingForInternetView) {
		return;
	}
	UIImageView * imageView =  [[UIImageView alloc] initWithFrame: window.bounds];
	imageView.image = [UIImage imageNamed:@"Default.png"];
	
	UILabel *waitingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, 300, 70)];
	waitingLabel.textAlignment = UITextAlignmentCenter;
	waitingLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.2];
	waitingLabel.layer.cornerRadius = 10;
	waitingLabel.textColor = [UIColor whiteColor];
	waitingLabel.text = @"Waiting on an internet connection...\n              ";
	waitingLabel.numberOfLines = 2;
	
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	CGRect rect = spinner.frame;
	spinner.frame = CGRectMake(waitingLabel.frame.size.width / 2 - rect.size.width / 2, 40, rect.size.width, rect.size.height);
	[spinner startAnimating];
	[waitingLabel addSubview:spinner];
	
	[imageView addSubview:waitingLabel];
	[waitingLabel release];
	[spinner release];
	
	
	[window addSubview:imageView];
	[window makeKeyAndVisible];	
	waitingForInternetView = imageView;
	[imageView release];
}

-(void) removeWaitingForReachabilityMessage {
	UIView *defaultImage = [window viewWithTag:kDefaultImageViewTag];
	
	if (defaultImage) {
		[defaultImage removeFromSuperview];
	}
}

-(void) startReachabilityCheckTimer {
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1
													  target:self
													selector:@selector(verifyReachabilityAndStartup)
													userInfo:nil
													 repeats:NO];
	
	self.reachabilityCheckTimer = timer;
}

-(void) stopReachabilityCheckTimer {
	if (self.reachabilityCheckTimer != nil) {
		[self.reachabilityCheckTimer invalidate];
		self.reachabilityCheckTimer = nil;
	}
}

- (void)dealloc {
	[self stopReachabilityCheckTimer];
	[reachabilityChecker release];
	[locationHelper release];
	[interruptionsHandler release];
	[locationStripeController release];
	[currentProfile release];
    [viewController release];
	[rootController release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIApplicationDelegate


- (void)verifyReachabilityAndStartup {
	if (!reachabilityChecker) {
		reachabilityChecker = [[ReachabilityChecker alloc] init];
	}
	
	if (reachabilityChecker.netStatus == NotReachable) {
		if (waitingForInternetView == nil) {
			[self showWaitingForReachabilityMessage];
		}
		
		[self startReachabilityCheckTimer];
		
		return;
	} 
	
	[self stopReachabilityCheckTimer];
	[self removeWaitingForReachabilityMessage];
	[self performPostReachabilityCheckStartUp];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    NSLog(@"applicationDidFinishLaunching");
    self.is_AppBackground = @"FALSE";
    self.isSaveTrip = @"NO";
    NSLog(@"is_AppBackground: %@",is_AppBackground);

	[FlurryAPI startSessionWithLocationServices:@"KWS5PU6MCA9YZ9NBUFWU"];
	InstallUncaughtExceptionHandler();
	[self verifyReachabilityAndStartup];	
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	NSLog(@"applicationDidBecomeActive");
    NSLog(@"is_AppBackground: %@",is_AppBackground);
    
    if ([self.is_AppBackground equalsIgnoreCase:@"FALSE"]) {
        NSLog(@"Application came from switch off");
       
        [self isTripDataExist];
    }
    else {
        NSLog(@"Application came from background");
       
      // [ self showAlertView:@"came from background"];
         self.is_AppBackground = @"FALSE";
    }
    if (isTripStarted) {
        [self.interruptionsHandler applicationDidBecomeActive];
    }
	
}

- (void)applicationWillResignActive:(UIApplication *)application {
	NSLog(@"applicationWillResignActive");
    NSLog(@"is_AppBackground value: %@",is_AppBackground);
    self.is_AppBackground = @"TRUE";
    NSLog(@"is_AppBackground changed to: %@",is_AppBackground);
    if (isTripStarted) {
    [self.interruptionsHandler applicationWillResignActive];
    }
    }

- (void)applicationWillTerminate:(UIApplication *)application {
	NSLog(@"applicationWillTerminate: %@", self.interruptionsHandler);
	[self.interruptionsHandler applicationWillTerminate];
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    //HomeScreenViewController *mainViewController = [[HomeScreenViewController alloc]init] ;
    //[mainViewController switchToBackgroundMode:YES];
    UILocalNotification *noti = [[UILocalNotification alloc]init];
    NSArray *oldNotifications = [application scheduledLocalNotifications];
    
    if ([oldNotifications count] > 0) {
        [application cancelAllLocalNotifications];
    }
    
    if (noti == nil)
        return;

	noti.fireDate = [[NSDate date]dateByAddingTimeInterval:3];
	noti.timeZone = [NSTimeZone systemTimeZone];
	noti.alertBody = @" running in background";
	//noti.applicationIconBadgeNumber = 1;
    //noti.applicationIconBadgeNumber 
    //[[UIApplication sharedApplication]scheduleLocalNotification:noti];
    [noti release];

}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    HomeScreenViewController *mainViewController = [[HomeScreenViewController alloc]init] ;
//    [mainViewController switchToBackgroundMode:YES];
}

-(void) showAlertView:( NSString *) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end
