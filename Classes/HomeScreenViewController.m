//
//  HomeViewController.m
//  safecell
//
//  Created by shail on 05/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "TripInfoTableCell.h"
#import "HeaderWithCenteredTitleForSection.h"
#import "SCTripJourney.h"
#import "SCProfile.h"
#import "SCWaypoint.h"
#import "WayPointsFileHelper.h"
#import "AddTripViewController.h"
#import "SelectWaypointsFileViewController.h"
#import "AppDelegate.h"
#import "TripRepository.h"
#import "NavBarHelper.h"
#import "TripLogViewController.h"
#import "ProfileRepository.h"
#import "InterruptionsHandler.h"
#import "FakeLocationManagerSettingsRepository.h"
#import "ImageUtils.h"
#import "LocationStripeController.h"
#import "AppSettingsItemRepository.h"
#import "UIUtils.h"
#import "UserDefaults.h"
#import "KeyUtils.h"
#import "JSONHelper.h"
#import <TargetConditionals.h>
#import "AlertHelper.h"

#import "iToast.h"
#import "WayPointsStore.h"
#import "WayPointsReader.h"


@implementation HomeScreenViewController

@synthesize lblUserName;
@synthesize lblLevelNo;
@synthesize lblTrips;
@synthesize lblGrade;
@synthesize lblTotalSafeMiles;
@synthesize userPhoto;
@synthesize tripsTable;
@synthesize selectPictureHelper;

@synthesize lblGradeTitle;
@synthesize lblTotalMilesTitle;

@synthesize tripsBackgroundImageView;
@synthesize gradeBackgroundImageView;
@synthesize milesBackgroundImageView;
@synthesize configSpeed,avg_Speed,distanceInKM,strengthText;
@synthesize splashDisplayValue,reloadTimer;

//-------------Track----------------
@synthesize wayPointsStore,rulesDownloadManager,schoolsDownloadManager,cllocationManager;

-(void) configureWaypointsStore {
	WayPointsStore *wps = [[WayPointsStore alloc] initWithCapacity:5];
	self.wayPointsStore = wps;
	[wps release];
}

-(void) configureWaypointsHelper {
	if (wayPointsFileHelper) {
		NSLog(@"WaypointsFileHelper already existed....");
		return;
	}
	
	if ([WayPointsFileHelper wayPointsFileExists]) {
		wayPointsFileHelper = [[WayPointsFileHelper alloc] initWithNewFile:NO];
	} else {
		wayPointsFileHelper = [[WayPointsFileHelper alloc] initWithNewFile:YES];
	}
}
-(void) startTracking {
AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.isTripStarted = NO;
	trackingg = YES;
    //[cllocationManager startUpdatingLocation];
	
}
-(void) configureRulesDownloadManager {
	if (!self.rulesDownloadManager) {
        
		RulesDownloadManager * rdm = [[RulesDownloadManager alloc] init];
		self.rulesDownloadManager = rdm;
		self.rulesDownloadManager.trackingViewController = trackingController;
		[rdm release];
	}
}

-(void) configureSchoolsDownloadManager {
	if (!self.schoolsDownloadManager) {
		SchoolsDownloadManager *sdm = [[SchoolsDownloadManager alloc] init];
		self.schoolsDownloadManager = sdm;
		self.schoolsDownloadManager.trackingViewController = trackingController;
		[sdm release];
	}
}

-(void) configureNotificationSoundsHelper {
	if (!notificationSoundsHelper) {
		notificationSoundsHelper = [[NotificationSoundsHelper alloc] init];
		AppSettingsItemRepository *appSettingsItemsRepository = [[AppSettingsItemRepository alloc] init];
		notificationSoundsHelper.playNotifications = [appSettingsItemsRepository areNotificationSoundsOn];
		[appSettingsItemsRepository release];
	}
}

-(void) cleanUpSchoolDownloadManager {
	if (schoolsDownloadManager) {
		[schoolsDownloadManager stopSchoolsDownload];
		[schoolsDownloadManager release];
		schoolsDownloadManager = nil;
	}
}

-(void) cleanUpRulesDownloadManager {
	if (rulesDownloadManager) {
		[rulesDownloadManager stopRulesDownload];
		[rulesDownloadManager release];
		rulesDownloadManager = nil;
	}
}
-(void) doneFilteringWaypoints {
	
	[self showAddTripViewController];
}
-(void) filterWaypoints {
	NSString *wayPointsFilePath = [WayPointsFileHelper wayPointsFilePath];
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:wayPointsFilePath];
	WayPointsReader *reader = [[WayPointsReader alloc] initWithFileHandle:fileHandle];
	WaypointFilter *waypointFilter = [[WaypointFilter alloc] init];
	NSMutableArray *waypointsArray = [[NSMutableArray alloc] initWithCapacity:100];
	
	SCWaypoint *waypoint = nil;
	
	while ((waypoint = [reader readNextWayPoint]) != nil) {
		waypoint = [waypointFilter filterWaypoint:waypoint];
		
		if (waypoint != nil) {
			[waypointsArray addObject:waypoint];
		} else {
			// NSLog(@"Filtered waypoint");
		}
	}
	
	[waypointFilter release];
	[reader release];
	
	WayPointsFileHelper *fileHelper = [[WayPointsFileHelper alloc] initWithNewFile:YES];
	
	for (SCWaypoint *tempWaypoint in waypointsArray) {
		[fileHelper writeWayPoint:tempWaypoint];
	}
	
	[fileHelper release];
	[waypointsArray release];
}

-(void) startFilteringWaypoints {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[self filterWaypoints];
	[self doneFilteringWaypoints];
	//[self performSelectorOnMainThread:@selector(doneFilteringWaypoints) withObject:nil waitUntilDone:NO];
	[pool release];
}


-(void) stopTracking {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
    appDelegate.isTripStarted = NO;
		
	if (trackingg) {
		trackingg = NO;
		tripFinishedd = YES;
		[appDelegate.interruptionsHandler stopTracking];
		[self performSelectorInBackground:@selector(startFilteringWaypoints) withObject:nil];
	} else {
		[self showAddTripViewController];
	}
}
- (void) configureLocationManager {
	if (self.cllocationManager) {
		NSLog(@"Location Manager already existed, no need to set it up....");
		return; //already set up
	}
    CLLocationManager *lManager = [[CLLocationManager alloc] init];
	self.cllocationManager = lManager;
	[lManager release];
	
	self.cllocationManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.cllocationManager.distanceFilter = 0;

    self.cllocationManager.delegate = self;
    [self.cllocationManager startUpdatingLocation];
}
-(void) updateSchoolStatusToActive {
	//self.schoolStatusLabel.textColor = [UIUtils colorFromHexColor:RULE_STATUS_ACTIVE_COLOR];
	//self.schoolStatusImageView.image = schoolActive;
	[notificationSoundsHelper enqueueSchoolActiveStatus:YES];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	//appDelegate.interruptionsHandler.schoolZoneActive = YES;
    appDelegate.interruptionsHandler.schoolZoneActive = @"VIOLATION";
}

-(void) updateSchoolStatusToInactive {
	//self.schoolStatusLabel.textColor = [UIUtils colorFromHexColor:RULE_STATUS_INACTIVE_COLOR];
	//self.schoolStatusImageView.image = schoolInactive;
	[notificationSoundsHelper enqueueSchoolActiveStatus:NO];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	//appDelegate.interruptionsHandler.schoolZoneActive = NO;
    appDelegate.interruptionsHandler.schoolZoneActive = @"VIOLATION";
}

#pragma mark -
#pragma mark AddTripViewControllerDelegate

-(void) tripSavingFinished {
	//[self dismissSelf];
}
#pragma mark -
#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
	
#ifndef USE_RECORDED_WAYPOINTS
	//Negative horizontal accuracy means the location update is invalid.
	if (newLocation.horizontalAccuracy < 0) {
		return;
	}
#endif

	SCWaypoint *waypoint = [[SCWaypoint alloc] initWithCLLocation:newLocation journeyId:kJourneyIdNotPersisted];
	@try
    {
        [wayPointsStore pushWayPoint:waypoint];
        [wayPointsFileHelper writePoint:waypoint];
    }
    @catch(NSException *exception)
    {
        NSLog(@"Caught exception: %@", exception);
    }
	//[wayPointsStore pushWayPoint:waypoint];
	//[wayPointsFileHelper writePoint:waypoint];
	
	BOOL fallsInSchoolZone = [schoolsDownloadManager waypoint:waypoint fallsInSchoolZoneRadius:5];
	
	if (fallsInSchoolZone) {
		[self updateSchoolStatusToActive];
	} else {
		[self updateSchoolStatusToInactive];
	}
	
	[rulesDownloadManager updateRulesStatusAsPerSchoolZone:fallsInSchoolZone];
	
	[rulesDownloadManager locationChangedtoWaypoint:waypoint];
	[schoolsDownloadManager locationChangedtoWaypoint:waypoint];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.interruptionsHandler.previousWaypoint = waypoint;
	
	
	[waypoint release];
}


//--------------------------------



-(void) setBackgroundImagesForStats {
	UIImage* tripsBackgroundImage = [[UIImage imageNamed:@"trip_checks_Backround.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	tripsBackgroundImageView.image = tripsBackgroundImage;
	
	UIImage* gradeBackgroundImage = [[UIImage imageNamed:@"trip_checks_Backround.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	gradeBackgroundImageView.image = gradeBackgroundImage;
	
	UIImage* milesBackgroundImage = [[UIImage imageNamed:@"trip_checks_Backround.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	milesBackgroundImageView.image = milesBackgroundImage;
}

-(void) adjustTableFrame {
	CGRect tableFrame = self.tripsTable.frame;
	tableFrame.size.height -= kLocationStripeHeight;
	self.tripsTable.frame = tableFrame;
}


-(void) showGradeStats {
	self.gradeBackgroundImageView.hidden = NO;
	self.lblGrade.hidden = NO;
	self.lblGradeTitle.hidden = NO;
	
	milesBackgroundImageView.frame = CGRectMake(231, 53, 86, 50);
	lblTotalSafeMiles.frame = CGRectMake(243, 58, 66, 22);
	lblTotalMilesTitle.frame = CGRectMake(236, 78, 77, 22);
}

-(void) hideGradeStats {
	self.gradeBackgroundImageView.hidden = YES;
	self.lblGrade.hidden = YES;
	self.lblGradeTitle.hidden = YES;
	
	milesBackgroundImageView.frame = CGRectMake(154, 53, 86, 50);
	lblTotalSafeMiles.frame = CGRectMake(166, 58, 66, 22);
	lblTotalMilesTitle.frame = CGRectMake(159, 78, 77, 22);
}

-(void) adjusDisplayAsPerGameplayStatus {
	if (gameplayStatus) {
		[self showGradeStats];
	} else {
		[self hideGradeStats];
	}
}

-(void) setGameplayStatus {
	AppSettingsItemRepository *appSettingsItemsRepository = [[AppSettingsItemRepository alloc] init];
	gameplayStatus = [appSettingsItemsRepository isGameplayOn];
	[appSettingsItemsRepository release];
}





-(SCProfile *) userProfile {
	return userProfile;
}

-(void) setUserProfile : (SCProfile *) profile {
	[userProfile release];
	userProfile = [profile retain];
	
	[self.userPhoto setImage:userProfile.userImage forState:UIControlStateNormal];
	self.lblUserName.text = [NSString stringWithFormat:@"%@ %@",userProfile.firstName,userProfile.lastName];
	self.lblLevelNo.text =[NSString stringWithFormat:@"Level %d",self.userProfile.levelNo];
    
	[self.tripsTable reloadData];
}

-(void) showProfileStats {
	TripRepository *tripRepository = [[TripRepository alloc] init];
	
	NSArray *journeys = [tripRepository journeysInAscendingOrder];
	int totalJourneys = [journeys count];
	NSLog(@"totalJourneys = %d",totalJourneys);
	int totalPoints = 0;
	int totalPositivePoints = 0;
	
	for (SCTripJourney* journey in journeys) {
		totalPoints += [journey tripPointsForDisplay];
		
		if (totalPoints < 0) {
			totalPoints = 0;
		}
		
		totalPositivePoints += [journey totalPositivePoints];
	}
	
	float ratio = 0;
	
	if (totalPositivePoints > 0) {
		ratio = ((float)totalPoints) / totalPositivePoints;
	}
    
	ratio = ratio * 100;
	int ratioInt = (int) round(ratio);
	
	if (ratioInt < 0) {
		ratioInt = 0;
	}
	
	self.lblTrips.text = [NSString stringWithFormat:@"%d", totalJourneys];
	
	if (totalPoints < 0) {
		totalPoints = 0;
	}
	
	self.lblTotalSafeMiles.text = [NSString stringWithFormat:@"%d",totalPoints];
	
	//if (totalPoints > 0) {
    self.lblTotalSafeMiles.textColor = [UIUtils colorFromHexColor:@"323232"];
    self.lblTotalMilesTitle.textColor = [UIUtils colorFromHexColor:@"323232"];
    //	} else {
    //		self.lblTotalSafeMiles.textColor = [UIUtils colorFromHexColor:@"FA0000"];
    //		self.lblTotalMilesTitle.textColor = [UIUtils colorFromHexColor:@"FA0000"];
    //	}
	
	if (totalJourneys == 0) {
		self.lblGrade.text = [NSString stringWithFormat:@"0%%"];
	} else {
		self.lblGrade.text = [NSString stringWithFormat:@"%d%%",ratioInt];
	}
	
	[tripRepository release];
}


/*
 -(void) showProfileStats {
 TripRepository *tripRepository = [[TripRepository alloc] init];
 
 //Following totalPositivePoints = total miles
 double totalMiles = [tripRepository totalPositivePoints];
 //int roundedMiles = (int) round(totalMiles);
 double totalPenaltyPoints = [tripRepository totalPenaltyPoints];
 
 NSLog(@"totalMiles: %f, totalPenaltyPoints: %f", totalMiles, totalPenaltyPoints);
 
 double safetyPoints = totalMiles + totalPenaltyPoints; //Penalty Pointes are always negative.
 int ratioInt;
 
 if (safetyPoints <= 0 || totalMiles <= 0) {
 ratioInt = 0;
 } else {
 double ratio = (safetyPoints / totalMiles);
 NSLog(@"Grade ratio: %f", ratio);
 ratio = ratio * 100;
 ratioInt = (int) round(ratio);
 }
 
 int totalJourneys = [tripRepository totalJourneys];
 
 int totalPoints = [tripRepository totalMiles];
 totalPoints = totalPoints + totalPenaltyPoints;
 
 if (totalPoints < 0) {
 totalPoints = 0;
 }
 
 [tripRepository release];
 
 self.lblTrips.text = [NSString stringWithFormat:@"%d", totalJourneys];
 self.lblTotalSafeMiles.text = [NSString stringWithFormat:@"%d",totalPoints];
 
 if (totalJourneys == 0) {
 self.lblGrade.text = [NSString stringWithFormat:@"0%%"];
 } else {
 self.lblGrade.text = [NSString stringWithFormat:@"%d%%",ratioInt];
 }
 }
 */

-(void) showAddTripViewController {
	AddTripViewController * addTripViewController = [[AddTripViewController alloc] initWithStyle:UITableViewStylePlain];
	addTripViewController.delegate = self;
	UINavigationController *navController = [[UINavigationController alloc]
											 initWithRootViewController:addTripViewController];
	
	//Hack to get the right tint color since DecorateNavBar(self); in AddTripViewController does nothing.
	navController.navigationBar.tintColor = [UIColor colorWithRed:.35 green:.43 blue:.58 alpha:1];
	
	[self presentViewController:navController animated:YES completion:nil];
	[addTripViewController release];
	[navController release];
}


#pragma mark -
#pragma mark Clean Up

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

/*- (void)dealloc {
	[lblUserName release];
	[lblLevelNo release];
	[lblTrips release];
	[lblGrade release];
	[lblTotalSafeMiles release];
	[userPhoto release];
	[tripsTable release];
	[userProfile release];
	[selectPictureHelper release];
	[profilePicHelper release];
	
	[lblGradeTitle release];
	[lblTotalMilesTitle release];
	
	[tripsBackgroundImageView release];
	[gradeBackgroundImageView release];
	[milesBackgroundImageView release];
    //  [reloadTimer release];
	[notificationSoundsHelper release];
    [wayPointsFileHelper release];
	[wayPointsStore release];
    [self cleanUpSchoolDownloadManager];
	[self cleanUpRulesDownloadManager];

    [super dealloc];
}*/

#pragma mark -
#pragma mark initialize

-(void)loadData {
	ProfileRepository *profileRepository = [[ProfileRepository alloc] init];
	SCProfile *user = [profileRepository currentProfile];
	[profileRepository release];
	
	user.levelNo = 14;
	
	TripRepository *tripRepository = [[TripRepository alloc] init];
	
	NSMutableArray *tableData = [tripRepository recentJourneys:5];
	
	user.trips = tableData;
	self.userProfile = user;
	
	[self showProfileStats];
	[tripRepository release];
}

-(void) showTrackingViewController {
    
    
	TrackingViewController * trackingViewController = [[TrackingViewController alloc] initWithNibName:@"TrackingViewController" bundle:nil];
	trackingViewController.delegate = self;
	//[self presentModalViewController:trackingViewController animated:YES];
    [self presentViewController:trackingViewController animated:YES completion:nil];
	[trackingViewController release];
}

//#ifdef USE_RECORDED_WAYPOINTS

-(void) showSelectWayPointFileViewController {
	if([SelectWaypointsFileViewController atleastOneRecordedWayPointsFilePresent]) {
		SelectWaypointsFileViewController *modalController = [[SelectWaypointsFileViewController alloc] initWithStyle:UITableViewStylePlain];
		modalController.delegate = self;
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:modalController];
		//[self presentModalViewController:navController animated:YES];
		[navController release];
		[modalController release];
	} else {
		UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"No Recordings Present" message:@"As of now the project doesn't contain any prerecorded trip file. Please either add at least one such file to the project or disable the FakeLocationManager." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
	}
}

//#endif

#pragma mark -
#pragma mark SelectWaypointsFileViewControllerDelegate

-(void) didFinishSelectingWayPointsFile: (NSString *) fileName {
	FakeLocationManagerSettingsRepository *settingsRepository = [[FakeLocationManagerSettingsRepository alloc] init];
	[settingsRepository setLastUsedDataFile: fileName];
	[settingsRepository release];
	
	[self dismissViewControllerAnimated:NO completion:nil];
	[self showTrackingViewController];
	//[self performSelector:@selector(showTrackingViewController) withObject:nil afterDelay:0.8];
}
#pragma mark -
#pragma mark Request delegate Methods

- (void)requestDidFail:(ASIHTTPRequest *)request {
    
	NSError *error = [request error];
	if (error) {
		NSLog(@"ERROR: %@", [request.error localizedDescription]);
	}
}
- (void)requestDidFinish:(ASIHTTPRequest *)request {
    
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    /*  NSLog(@"request userInfo is = %@",[request userInfo]);
     NSString *operation = [[request userInfo] objectForKey:@"operation"];
     NSLog(@"operation is = %@",operation);
     NSLog(@"Retrieved %d bytes from the request for %@", [[request responseData] length], request.url);*/
	//NSError *error;
	NSString *responseString = [request responseString];
	NSLog(@"Response: %@", responseString);
    // NSData *responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    //NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    NSDictionary *responseDict = [JSONHelper dictFromString: responseString];
    NSArray * configArray= [responseDict objectForKey:@"configurations"];
    
    NSArray *tsnSpeedArray = [[configArray objectAtIndex:0] objectForKey:@"TSN"];
    NSDictionary *speedNumerDic = [tsnSpeedArray objectAtIndex:0];
    NSLog(@"speedNumerDic = %@",speedNumerDic);
    NSString *speedFromConfidurations = [speedNumerDic objectForKey:@"value"];
    NSLog(@"speedFromConfidurations = %d", [speedFromConfidurations intValue] );
    configSpeed = [speedFromConfidurations intValue];
    appDelegate.tripStartTime = configSpeed;
    NSLog(@"startSpeed = %d",  appDelegate.tripStartTime );
   
    
    NSArray *controllerNumerArray = [[configArray objectAtIndex:0] objectForKey:@"CONTROLLERNUM"];
    NSDictionary *controllerNumerDic = [controllerNumerArray objectAtIndex:0];
    NSLog(@"controllerNumerDic = %@",controllerNumerDic);
    appDelegate.phoneNumber = [controllerNumerDic objectForKey:@"value"];
    NSLog(@"phoneNumber = %@", appDelegate.phoneNumber);
    
    
    NSArray *disableWebArray = [[configArray objectAtIndex:0] objectForKey:@"DWEB"];
    NSDictionary *dwv = [disableWebArray objectAtIndex:0];
    appDelegate.disableWebValue = [[dwv objectForKey:@"value"] intValue];
    NSLog(@"disableWebValue = %d", appDelegate.disableWebValue);

    
    NSArray *tripStopTime = [[configArray objectAtIndex:0] objectForKey:@"TST"];
    NSDictionary *stopTimeDic = [tripStopTime objectAtIndex:0];
    NSString *strStop = [NSString stringWithFormat:@"%@",[stopTimeDic objectForKey:@"value"]];
    appDelegate.tripStopTime = [strStop intValue];
    NSLog(@"stop time = %d", appDelegate.tripStopTime);
    
    NSArray *logWayPoints = [[configArray objectAtIndex:0] objectForKey:@"LOGWEBPOINTS"];
    NSDictionary *wayPntDic = [logWayPoints objectAtIndex:0];
    NSString *wpValue = [NSString stringWithFormat:@"%@",[wayPntDic objectForKey:@"value"]];
    appDelegate.logWayPointValue = [wpValue intValue];
    NSLog(@"logWayPointValue = %d", appDelegate.logWayPointValue);
   
    
    NSArray *display_Splash_Screen = [[configArray objectAtIndex:0] objectForKey:@"DISPLAY_SPLASH_SCREEN"];
    NSDictionary *dss = [display_Splash_Screen objectAtIndex:0];
    splashDisplayValue = [[NSString stringWithFormat:@"%@",[dss objectForKey:@"value"]] intValue];
    NSLog(@"display_Splash_Screen value = %d", splashDisplayValue);
    
    
}

#pragma mark - Configuration Settings
-(void)getConfigurations{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@"masterrrrr = %d",appDelegate.masterProfileKeyValue);
    NSString *master = [NSString stringWithFormat:@"http://www.safecellapp.mobi/api/%d/configcompany/%d",1,appDelegate.masterProfileKeyValue];
    
    NSURL *awesomeURL = [NSURL URLWithString:master];
    NSURLRequest *awesomeRequest = [NSURLRequest requestWithURL:awesomeURL];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
  
    
    NSData *receivedData = [NSURLConnection  sendSynchronousRequest:awesomeRequest
                                                 returningResponse:&response error:&error];

    /* Code changed by kiran to make http request asyncronus*/
    /*NSData *receivedData = [NSURLConnection sendSynchronousRequest:awesomeRequest
                                                 returningResponse:&response error:&error];
    */
    
    
    if (receivedData == nil) {
        NSLog(@"Configuration recieved data: %@ ", receivedData);
        NSLog(@"Applying Default Vaues");
        configSpeed = 5;
        appDelegate.tripStartTime = configSpeed;
        appDelegate.phoneNumber = @"";
        appDelegate.disableWebValue = 1;
        appDelegate.tripStopTime = 2;
        appDelegate.logWayPointValue = 1;
        splashDisplayValue = 1;

        return;
    }
    
    if ([response statusCode] == 200) {
        
        NSLog(@"receivedData = %@",receivedData);
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:&error];
        NSArray * configArray= [responseDict objectForKey:@"configurations"];
        
        NSArray *tsnSpeedArray = [[configArray objectAtIndex:0] objectForKey:@"TSN"];
        NSDictionary *speedNumerDic = [tsnSpeedArray objectAtIndex:0];
        NSLog(@"speedNumerDic = %@",speedNumerDic);
        NSString *speedFromConfidurations = [speedNumerDic objectForKey:@"value"];
        NSLog(@"speedFromConfidurations = %d", [speedFromConfidurations intValue] );
        configSpeed = [speedFromConfidurations intValue];
        NSLog(@"configSpeed = %d", configSpeed );
        appDelegate.tripStartTime = configSpeed;
        NSLog(@"startSpeed = %d",  appDelegate.tripStartTime );

        
        NSArray *controllerNumerArray = [[configArray objectAtIndex:0] objectForKey:@"CONTROLLERNUM"];
        NSDictionary *controllerNumerDic = [controllerNumerArray objectAtIndex:0];
        NSLog(@"controllerNumerDic = %@",controllerNumerDic);
        appDelegate.phoneNumber = [controllerNumerDic objectForKey:@"value"];
        NSLog(@"phoneNumber = %@", appDelegate.phoneNumber);
        
        
        NSArray *disableWebArray = [[configArray objectAtIndex:0] objectForKey:@"DWEB"];
        NSDictionary *dwv = [disableWebArray objectAtIndex:0];
        appDelegate.disableWebValue = [[dwv objectForKey:@"value"] intValue];
        NSLog(@"disableWebValue = %d", appDelegate.disableWebValue);
        
        
        NSArray *tripStopTime = [[configArray objectAtIndex:0] objectForKey:@"TST"];
        NSDictionary *stopTimeDic = [tripStopTime objectAtIndex:0];
        NSString *strStop = [NSString stringWithFormat:@"%@",[stopTimeDic objectForKey:@"value"]];
        appDelegate.tripStopTime = [strStop intValue];
        NSLog(@"stop time = %d", appDelegate.tripStopTime);
        
        NSArray *logWayPoints = [[configArray objectAtIndex:0] objectForKey:@"LOGWEBPOINTS"];
        NSDictionary *wayPntDic = [logWayPoints objectAtIndex:0];
        NSString *wpValue = [NSString stringWithFormat:@"%@",[wayPntDic objectForKey:@"value"]];
        appDelegate.logWayPointValue = [wpValue intValue];
        NSLog(@"logWayPointValue = %d", appDelegate.logWayPointValue);
        
        
        NSArray *display_Splash_Screen = [[configArray objectAtIndex:0] objectForKey:@"DISPLAY_SPLASH_SCREEN"];
        NSDictionary *dss = [display_Splash_Screen objectAtIndex:0];
        splashDisplayValue = [[NSString stringWithFormat:@"%@",[dss objectForKey:@"value"]] intValue];
        NSLog(@"display_Splash_Screen value = %d", splashDisplayValue);
    }
    else{
        NSLog(@"Applying Default Vaues");
        configSpeed = 5;
        appDelegate.tripStartTime = configSpeed;
        appDelegate.phoneNumber = @"";
        appDelegate.disableWebValue = 1;
        appDelegate.tripStopTime = 2;
        appDelegate.logWayPointValue = 1;
        splashDisplayValue = 1;
    }
    /*
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:master]];
	[request setTimeOutSeconds:60];
	[request addRequestsetHeader:@"Content-Type" value:@"application/json"];
	
	request.userInfo = [NSDictionary dictionaryWithObject:@"activateAccount" forKey:@"operation"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestDidFinish:)];
	[request setDidFailSelector:@selector(requestDidFail:)];
	[request setRequestMethod:@"POST"];
	NSLog(@"Activate Account: %@", master);
	NSLog(@"Content-Type: application/json");
     
	[request startSynchronous];*/
    
    
    
    
}
#pragma mark -
#pragma mark View Life Cycle

- (void)viewDidLoad {
    [self getConfigurations];
    [PSLocationManager sharedLocationManager].delegate = self;
    [[PSLocationManager sharedLocationManager] prepLocationUpdates];
    [[PSLocationManager sharedLocationManager] startLocationUpdates];
    capacityArray = [[NSMutableArray alloc]initWithCapacity:2];
	//[self getConfigurations];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate configureLocationUpdateRelatedObjects];
	self.navigationItem.title = @"Home";
	DecorateNavBarWithLogo(self);
	self.tripsTable.backgroundColor = [UIColor clearColor];
	
	profilePicHelper = [[ProfilePicHelper alloc] init];
	UIImage *profileImage = [profilePicHelper profilePic];
	[userPhoto setBackgroundImage:profileImage forState:UIControlStateNormal];
	
	[self setBackgroundImagesForStats];
    
    [self configureWaypointsHelper];
    [self configureWaypointsStore];
    if (!tripFinishedd) {
		NSLog(@"Start Tracking Trip....");
		[self startTracking];
        
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate.interruptionsHandler startTracking];
		

	}
    [self configureRulesDownloadManager];
	[self configureSchoolsDownloadManager];
	[self configureNotificationSoundsHelper];
	
	[self.rulesDownloadManager useRulesFromDB];
	[self.rulesDownloadManager updateRulesStatusAsPerSchoolZone:NO];


	
	[self loadData];
	[self adjustTableFrame];
    [super viewDidLoad];
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.lblUserName =nil;
	self.lblLevelNo =nil;
	self.lblTrips =nil;
	self.lblGrade =nil;
	self.lblTotalSafeMiles =nil;
	self.userPhoto =nil;
	self.tripsTable =nil;
    
}

- (void)viewWillAppear: (BOOL)animated {
	[self setGameplayStatus];
	[self adjusDisplayAsPerGameplayStatus];
	[self loadData];
	[self.tripsTable reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
//    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString* termsAndCond = [documentsPath stringByAppendingPathComponent:@"terms_of_service.html"];
//    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:termsAndCond];
//    
//    if (fileExists) {
//        
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        [fileManager removeItemAtPath:termsAndCond error:NULL];
//    }
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if ([app.isSaveTrip equalsIgnoreCase:@"YES"]) {
        NSLog(@"Call to save trip from home screen view");
        [cllocationManager stopUpdatingLocation];
		
		self.cllocationManager.delegate = nil;
		self.cllocationManager = nil;
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app stopLocationHelper];
        
		[wayPointsFileHelper closeWayPointFile];
		[wayPointsFileHelper archiveWayPointsFile];
		
		
		[self cleanUpRulesDownloadManager];
		[self cleanUpSchoolDownloadManager];
	
		[notificationSoundsHelper cleanUpBeforeStoppingTrip];
        
		[self stopTracking];
        app.isSaveTrip = @"NO";
        
    }
    
    reloadTimer = [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(startBasedOnSpeed) userInfo:nil repeats:YES];
    
    UIAlertView *alert;
    if ([app.profileStatusCheck isEqualToString:@"closed"]) {
        
        alert = [[UIAlertView alloc]initWithTitle:@"Your account is inactive. Please call customer service at 1-800-XXX-XXXX to active you account or go to www.safecellapp.mobi with controller account and edit your profile." message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel", nil];
        [alert show];
        //[future release];
        [alert release];
    }
    int licence =[SCProfile daysTillAccountExpiry];
    if (licence <= 2) {
        
        if (licence > 0) {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
            [offsetComponents setDay:licence+1];
            NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
            NSLog(@"2 nextDate %@", nextDate);
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"EEE, dd/MM/yyyy"];
            NSString *modifiedStr = [formatter stringFromDate:nextDate];
            NSString *licenceStr = [NSString stringWithFormat:@"You SafeCell license is about to expire on %@. Please log on the www.safecellapp.mobi with your userid and password and extend the license, otherwise you will not be able to use this application",modifiedStr];
            //SimpleAlertOK(licenceStr, @"");
            [[[[iToast makeText:[NSString stringWithFormat:@"%@",licenceStr]]setGravity:iToastGravityCenter] setDuration:iToastDurationLong] show];
            //[modifiedStr release];
            //[formatter release];
            //[nextDate release];
            //[offsetComponents release];
            //[gregorian release];
        }
        
        
        
        else if (licence == 0){
            
            NSString *future = [NSString stringWithFormat:@"You are authorize to use the application from %@",app.futuredateString];
            alert = [[UIAlertView alloc]initWithTitle:future message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            //[future release];
            [alert release];
        }
        else{
            NSString *expireStr = [NSString stringWithFormat:@"You SafeCell license expired on %@. Please log on the www.safecellapp.mobi with your userid and password and renew the license",app.strExpiredDate];
            alert = [[UIAlertView alloc]initWithTitle:expireStr message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
        }
        
    }
    
	/*AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
     
     if(appDelegate.interruptionsHandler.continueTrackingAction == kContinueTrackingActionTrackJourney) {
     [self performSelector:@selector(showTrackingViewController) withObject:nil afterDelay:0.4];
     return;
     }
     
     if (appDelegate.interruptionsHandler.continueTrackingAction == kContinueTrackingActionSaveJourney) {
     [self performSelector:@selector(showAddTripViewController) withObject:nil afterDelay:0.4];
     return;
     }*/
    //[self performSelector:@selector(refreshData)];
    //[self switchToBackgroundMode:YES];
    
    
}


#pragma mark Alert View Delegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"] || [title isEqualToString:@"Cancel"] )
    {
        //[[PSLocationManager sharedLocationManager] resetLocationUpdates];
       // [[PSLocationManager sharedLocationManager] stopLocationUpdates];
        ProfileRepository *profileRepository = [[ProfileRepository alloc] init];
        [profileRepository deleteProfile];
        [profileRepository release];
        //[self.parentViewController dismissViewControllerAnimated:YES completion:nil];
        //        loginViewController = [[LoginViewController alloc] initWithStyle:UITableViewStyleGrouped];
        //        loginViewController.delegate = self;
        //        UINavigationController *navController = [[UINavigationController alloc]
        //                                                 initWithRootViewController:loginViewController];
        //        [self presentViewController:navController animated:YES completion:nil];
        //        [loginViewController release];
        SplashScreenViewController *spc = [[SplashScreenViewController alloc] initWithNibName:@"SplashScreenViewController" bundle:nil];
        
        [self presentViewController:spc animated:YES completion:nil];
        [spc release];
        
        
    }
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if(buttonIndex == 1) {
		
        [cllocationManager stopUpdatingLocation];
		
		self.cllocationManager.delegate = nil;
		self.cllocationManager = nil;
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [app stopLocationHelper];
				
		[wayPointsFileHelper closeWayPointFile];
		[wayPointsFileHelper archiveWayPointsFile];
		
		
		[self cleanUpRulesDownloadManager];
		[self cleanUpSchoolDownloadManager];
		
		[notificationSoundsHelper cleanUpBeforeStoppingTrip];
        
        
		[self stopTracking];

	}
}

#pragma mark - Background Running

/*-(void)refreshData{
 
 AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
 [appDelegate stopLocationHelper]; //We will start this again when we are done with saving trip
 //[appDelegate startLocationHelper];
 NSString *tripGUID = [KeyUtils GUID];
 [UserDefaults setValue:tripGUID forKey:kTripGUID];
 
 #ifdef USE_RECORDED_WAYPOINTS
 [self showSelectWayPointFileViewController];
 #else
 [self showTrackingViewController];
 #endif
 
 
 #if TARGET_IPHONE_SIMULATOR
 
 // Simulator specivirfic code
 [self showSelectWayPointFileViewController];
 
 #else // TARGET_OS_IPHONE
 
 // Device specific code
 [self showTrackingViewController];
 
 #endif // TARGET_IPHONE_SIMULATOR
 
 }*/

- (void)switchToBackgroundMode:(BOOL)background
{
    
    //reloadTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
}
-(void)saveTripMethod{
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (appdelegate.speedValue < appdelegate.tripStartTime) {
        
        if (appdelegate.logWayPointValue == 1) {
            
            [savingTimer invalidate];
            savingTimer = nil;
            //UIAlertView *alert;
            //[self alertView:alert didDismissWithButtonIndex:1];
            [self performSelector:@selector(alertView:didDismissWithButtonIndex:) withObject:nil afterDelay:2];

        }
        
    }
        
}
-(void)stopTripBasedOnSpeed{
    
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
   
    if (appdelegate.speedValue < appdelegate.tripStartTime) {
        
        [tripStopTimer invalidate];
        tripStopTimer = nil;
        savingTimer = [NSTimer scheduledTimerWithTimeInterval:appdelegate.tripStopTime * 60 target:self selector:@selector(saveTripMethod) userInfo:nil repeats:YES];
        
        
    }else{
        // stop the 60 seconds timer
        if ([savingTimer isValid]) {
            
            [savingTimer invalidate];
            savingTimer = nil;
            tripStopTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(stopTripBasedOnSpeed) userInfo:nil repeats:YES];
        }
        
    }
    

}
//Trip Starts Based on Speed
-(void)startBasedOnSpeed{
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app stopLocationHelper];
    
    NSLog(@"[configSpeed intValue] = %d",configSpeed );
    //[[[[iToast makeText:[NSString stringWithFormat:@" calculatedSpeed and distanse %d,%.2f",app.speedValue,app.totalMiles]]setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
    // && ([splashDisplay isEqualToString:@"1"])
    
    if ( (app.speedValue > configSpeed) && (app.totalMiles > 0.4) ) {
        
        app.isTripStarted = YES;
        
        
      //  [[[[iToast makeText:[NSString stringWithFormat:@"Trip speed raised to configured speed."]]setGravity:iToastGravityCenter] setDuration:iToastDurationShort] show];
        if (splashDisplayValue == 1) {
            
//            [[[[iToast makeText:[NSString stringWithFormat:@"Starting trip with splash display."]]setGravity:iToastGravityCenter] setDuration:iToastDurationShort] show];
           // [app stopLocationHelper];
            [reloadTimer invalidate];
            reloadTimer = nil;
            [self performSelector:@selector(startNewTripButtonTapped:)];
        }
        else{
            
            [self configureLocationManager];
//            [[[[iToast makeText:[NSString stringWithFormat:@" Trip Starts with no splash display "]]setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
            [reloadTimer invalidate];
            reloadTimer = nil;
            NSString *tripGUID = [KeyUtils GUID];
            [UserDefaults setValue:tripGUID forKey:kTripGUID];
            
            tripStopTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(stopTripBasedOnSpeed) userInfo:nil repeats:YES];
                       
        }
       
        
    }
    
}
#pragma mark -
#pragma mark Actions

-(IBAction) startNewTripButtonTapped: (id) sender {
    
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate stopLocationHelper]; //We will start this again when we are done with saving trip
	//[appDelegate startLocationHelper];
	NSString *tripGUID = [KeyUtils GUID];
	[UserDefaults setValue:tripGUID forKey:kTripGUID];
    //[self showTrackingViewController];
    /* #ifdef USE_RECORDED_WAYPOINTS
     [self showSelectWayPointFileViewController];
     #else
     [self showTrackingViewController];
     #endif*/
    
#if TARGET_IPHONE_SIMULATOR
    
    // Simulator specific code
    [self showSelectWayPointFileViewController];
    //[self showTrackingViewController];
    
#else // TARGET_OS_IPHONE
    
    // Device specific code
    [self showTrackingViewController];
    
#endif // TARGET_IPHONE_SIMULATOR
    
    
}

-(IBAction) userProfileButtonTapped: (id) sender {
	SelectPictureHelper *pictureHelper = [[SelectPictureHelper alloc] init];
	self.selectPictureHelper = pictureHelper;
	[pictureHelper release];
	
	self.selectPictureHelper.delegate = self;
	[self.selectPictureHelper selectPictureFor:self];
}

#pragma mark -
#pragma mark TrackingViewControllerDelegate methods

-(void) trackingViewFinishedTracking {
	//[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark TableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
	HeaderWithCenteredTitleForSection *headerView = [[[HeaderWithCenteredTitleForSection alloc] initWithFrame:CGRectMake(0, 0, 320, 28)]autorelease];
	headerView.title = @"RECENT TRIPS";
    
    
	return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 28.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 43.0f;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	int rowCount = [userProfile.trips count];
	
	if(rowCount == 0) {
		return 1;
	} else {
		return rowCount;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	UITableViewCell * cell = nil;
	
	if([userProfile.trips count] == 0) {
		cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleDefault
				 reuseIdentifier:@"UITableViewCell"] autorelease];
		cell.textLabel.text = @"You haven't taken any trips yet.";
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		CGRect textLabelFrame = CGRectMake(0, 0, 320, 43);
		cell.textLabel.frame = textLabelFrame;
		cell.backgroundView = [[[UIView alloc] initWithFrame:cell.bounds] autorelease];
		cell.backgroundView.backgroundColor = [UIColor whiteColor];
	} else {
		static NSString *strCellIdentifier = @"TripInfoTableCell";
		
		TripInfoTableCell *tripInfoTableCell = (TripInfoTableCell*)[tableView dequeueReusableCellWithIdentifier:strCellIdentifier];
		
		if (tripInfoTableCell == nil) {
			tripInfoTableCell = [[[TripInfoTableCell alloc]
                                  initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:strCellIdentifier] autorelease];
		}
		
		NSInteger section = [indexPath section];
		
		if(section == 0) {
			tripInfoTableCell.tripObject = [userProfile.trips objectAtIndex:[indexPath row]];
		} else {
			tripInfoTableCell.tripObject = [userProfile.trips objectAtIndex:[indexPath row] + 1];
		}
		
		
		if (gameplayStatus) {
			[tripInfoTableCell showPoints];
		} else {
			[tripInfoTableCell hidePoints];
		}
		
		
		cell = tripInfoTableCell;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
		CGRect frame = 	cell.accessoryView.frame ;
		frame.origin.x = 200;
		cell.accessoryView.frame = frame;
	}
    
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if([userProfile.trips count] > 0) {
		SCTripJourney *tripObject = [userProfile.trips objectAtIndex:[indexPath row]];
		TripLogViewController *tripLogViewController = [[TripLogViewController alloc] initWithStyle:UITableViewStylePlain withJourney:tripObject];
		[self.navigationController pushViewController:tripLogViewController animated:YES];
		[tripLogViewController release];
	}
}

#pragma mark -
#pragma mark SelectPictureHelperDelegate

-(void) didFinishPickingImageWithInfo: (NSDictionary *) imageInfo {
	UIImage *selectedImage = [imageInfo objectForKey:@"UIImagePickerControllerEditedImage"];
	
	UIImage *profileImage = [ImageUtils scaleAndCropImage:selectedImage maxWidth:kProfilePicWidth maxHeight:kProfilePicHeight];
	[userPhoto setBackgroundImage:profileImage forState:UIControlStateNormal];
	
	[profilePicHelper writeProfilePic:profileImage];
}
#pragma mark PSLocationManagerDelegate

- (void)locationManager:(PSLocationManager *)locationManager signalStrengthChanged:(PSLocationManagerGPSSignalStrength)signalStrength {
    
    if (signalStrength == PSLocationManagerGPSSignalStrengthWeak) {
        strengthText = NSLocalizedString(@"Weak", @"");
    } else if (signalStrength == PSLocationManagerGPSSignalStrengthStrong) {
        strengthText = NSLocalizedString(@"Strong", @"");
    } else {
        strengthText = NSLocalizedString(@"...", @"");
    }
    
    
}

- (void)locationManagerSignalConsistentlyWeak:(PSLocationManager *)locationManager {
    // self.strengthLabel.text = NSLocalizedString(@"Consistently Weak", @"");
    NSLog(@"Signal Strength = %@",NSLocalizedString(@"Consistently Weak", @""));
}

- (void)locationManager:(PSLocationManager *)locationManager distanceUpdated:(CLLocationDistance)distance {
    if ([strengthText isEqualToString:@"Strong"]) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.totalMiles = 0;
        NSString *str = [NSString stringWithFormat:@"%.2f %@", distance, NSLocalizedString(@"meters", @"")];
        NSLog(@"distanceUpdated = %@",str);
        appDelegate.totalMiles = distance/1000;
    }
    
    
}
- (void)locationManager:(PSLocationManager *)locationManager waypoint:(CLLocation *)waypoint calculatedSpeed:(double)calculatedSpeed{
    
    if ([strengthText isEqualToString:@"Strong"]) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.speedValue = 0;
        
       //[[[[iToast makeText:[NSString stringWithFormat:@" AvgSpeed :%.2f",calculatedSpeed]]setGravity:iToastGravityTop] setDuration:500] show];
        appDelegate.speedValue = (int)calculatedSpeed;
    }
    
}

- (void)locationManager:(PSLocationManager *)locationManager error:(NSError *)error {
    // location services is probably not enabled for the app
    //self.strengthLabel.text = NSLocalizedString(@"Unable to determine location", @"");
}


@end
