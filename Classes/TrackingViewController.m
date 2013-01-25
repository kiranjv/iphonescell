							//
//  TrackingViewController.m
//  safecell
//
//  Created by shail on 06/05/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "TrackingViewController.h"
#import "AppDelegate.h"
#import "SCWaypoint.h"
#import "SCTripJourney.h"
#import "WayPointsFileHelper.h"
#import "WayPointsStore.h"
#import "InterruptionsHandler.h"
#import "AddTripViewController.h"
#import "WayPointsReader.h"
#import "NavBarHelper.h"
#import "UIUtils.h"
#import "SCSchool.h"
#import "AppSettingsItemRepository.h"
#import "WaypointMapViewController.h"
#import "JSONHelper.h"
#import "GoogleMap.h"
#import "iToast.h"


@implementation TrackingViewController
@synthesize myMapView;
@synthesize btnMap;
@synthesize delegate;
@synthesize stopTripTimer;
@synthesize destinationCityArray;

@synthesize pauseStartTrackingButton;
@synthesize trackingStatusMessageImageView;
@synthesize locationManager;

@synthesize phoneStatusImageView;
@synthesize smsStatusImageView;
@synthesize schoolStatusImageView;

@synthesize phoneStatusLabel;
@synthesize smsStatusLabel;
@synthesize schoolStatusLabel;
@synthesize rulesDownloadManager, schoolsDownloadManager, wayPointsStore;
@synthesize citynamearray,latarray,longarray;
@synthesize currentLocationStr,txtTo;
@synthesize timerForSavingTrip;

static const NSInteger kStopTripNoButton = 0;
static const NSInteger kStopTripYesButton = 1;

static const NSInteger kWayPointsStoreSize = 5;

static NSString *RULE_STATUS_ACTIVE_COLOR = @"D20300";
static NSString *RULE_STATUS_INACTIVE_COLOR = @"A4A4A4";

static const float kSchoolCheckRadius = 0.3;

-(void) showHUD {
	if (progressHUD == nil) {
		progressHUD = [[ProgressHUD alloc] init];
	}
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[progressHUD showHUDWithLable:@"Analyzing Trip…" inView:appDelegate.window animated: YES];
}

-(void) hideHUD {
	[progressHUD hideHUD];
}

-(void) createRuleStatusImages {
	phoneActive = [[UIImage imageNamed:@"phone-active.png"] retain];
	phoneInactive = [[UIImage imageNamed:@"phone-inactive.png"] retain];
	
	smsActive = [[UIImage imageNamed:@"sms-active.png"] retain];
	smsInactive = [[UIImage imageNamed:@"sms-inactive.png"] retain];
	
	schoolActive = [[UIImage imageNamed:@"school-active.png"] retain];
	schoolInactive = [[UIImage imageNamed:@"school-inactive.png"] retain];
}

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

-(void) dismissSelf {
	[self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) createImageAssets {
	trackingOnMessageImage = [[UIImage imageNamed:@"tracking_on_message.png"] retain];
	trackingPausedMessageImage = [[UIImage imageNamed:@"tracking_paused_message.png"] retain];
	
	pauseButtonImage = [[UIImage imageNamed:@"pause_button.png"] retain];
	startButtonImage = [[UIImage imageNamed:@"start_button.png"] retain];
	
	[self createRuleStatusImages];
}

-(void) configureRulesDownloadManager {
	if (!self.rulesDownloadManager) {
		RulesDownloadManager * rdm = [[RulesDownloadManager alloc] init];
		self.rulesDownloadManager = rdm;
		self.rulesDownloadManager.trackingViewController = self;
		[rdm release];
	}
}

-(void) configureSchoolsDownloadManager {
	if (!self.schoolsDownloadManager) {
		SchoolsDownloadManager *sdm = [[SchoolsDownloadManager alloc] init];
		self.schoolsDownloadManager = sdm;
		self.schoolsDownloadManager.trackingViewController = self;
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
#pragma mark - Message Delegate Methods

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;    
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
    [controller release];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	[self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");  
    else 
        NSLog(@"Message failed");
}


-(void)abundantButtonClicked{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.is_abandon_trip = TRUE;
    
    [self performSelector:@selector(alertView:didDismissWithButtonIndex:) withObject:nil afterDelay:0];
    
    /*AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@"pho = %@",appDelegate.phoneNumber);
    [self sendSMS:@"Body of SMS From iPhone..." recipientList:[NSArray arrayWithObjects:appDelegate.phoneNumber, nil]];*/
   /* AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.logWayPointValue == 1) {
    
        [self alertView:alert didDismissWithButtonIndex:kStopTripYesButton];
    }*/

     //[self performSelector:@selector(alertView:didDismissWithButtonIndex:) withObject:nil afterDelay:2];
   
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (void)fetchedLatLong:(NSData *)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray *items = [json objectForKey:@"results"];
    
    NSArray *items1 = [items valueForKey:@"geometry"];
    NSArray *items2 = [items1 valueForKey:@"location"];
    
    NSString *latlongstr = [NSString stringWithFormat:@"%@",[items2 objectAtIndex:0]];
    latlongstr = [latlongstr stringByReplacingOccurrencesOfString:@" " withString:@""];
    latlongstr = [latlongstr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    latlongstr = [latlongstr stringByReplacingOccurrencesOfString:@"}" withString:@""];
    
    NSArray *latlngarr = [latlongstr componentsSeparatedByString:@";"];
    NSString *lat = [NSString stringWithFormat:@"%@",[latlngarr objectAtIndex:0]];
    lat = [lat stringByReplacingOccurrencesOfString:@"{lat=\"" withString:@""];
    lat = [lat stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSString *lng = [NSString stringWithFormat:@"%@",[latlngarr objectAtIndex:1]];
    lng = [lng stringByReplacingOccurrencesOfString:@"lng=\"" withString:@""];
    lng = [lng stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    [latarray addObject:lat];
    [longarray addObject:lng];
    
    NSLog(@"lat = %@ , long = %@",latarray,longarray);
}

-(void)googleMap{
    
    if (txtTo.text == nil || [txtTo.text isEqualToString:@""]) {
        return;
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    currentLocationStr = nil;
    [citynamearray removeAllObjects];
    [latarray removeAllObjects];
    [longarray removeAllObjects];
    NSLog(@"to value = %@ ",txtTo.text);
    //[citynamearray addObject:txtFrom.text];
    [citynamearray addObject:txtTo.text];
    NSLog(@"citynamearray = %@",citynamearray);
    
    for (int i = 0; i < [citynamearray count]; i++)
    {
        NSString *urlpath = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true",[[citynamearray objectAtIndex:i]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURL *path = [NSURL URLWithString:urlpath];
        NSData* data = [NSData dataWithContentsOfURL:path];
        [self performSelectorOnMainThread:@selector(fetchedLatLong:) withObject:data waitUntilDone:YES];
    }
    
    GoogleMap *_Controller	= [[GoogleMap alloc]initWithNibName:@"GoogleMap" bundle:nil];
   
    //btnMap.frame = CGRectMake(189, 366, 111, 37);
    
    

    //_Controller.startPoint = [NSString stringWithFormat:@"%@,%@",[latarray objectAtIndex:0],[longarray objectAtIndex:0]];
    currentLocationStr = [NSString stringWithFormat:@"%@,%@",appDelegate.currentLatValue,appDelegate.currentLongValue];
    _Controller.startPoint = currentLocationStr;
    NSLog(@"_Controller.startPoint = %@",_Controller.startPoint);
    NSMutableArray *DestinationCityArray = [[NSMutableArray alloc]init];
    // NSString *endPoint = [NSString stringWithFormat:@"%@,%@",[latarray objectAtIndex:1],[longarray objectAtIndex:1]];
    NSString *endPoint = [NSString stringWithFormat:@"%@,%@",[latarray objectAtIndex:0],[longarray objectAtIndex:0]];
    [DestinationCityArray addObject:endPoint];
    _Controller.destination = DestinationCityArray;
    _Controller.travelMode	= UICGTravelModeDriving;
    //_Controller.imgString = @"userimage.png";
    //UINavigationController *navController = [[UINavigationController alloc] 
    //initWithRootViewController:_Controller];
   // [self presentModalViewController:_Controller animated:YES];
    
    
    [self presentViewController:_Controller animated:YES completion:nil];
    //[self.navigationController pushViewController:_Controller animated:YES];
     //[alertWindow removeWithZoomOutAnimation:1.0 option:curveValues[selectedCurveIndex]];
    
    [alertWindow removeFromSuperview];
    [DestinationCityArray release];
    [_Controller release];
}
-(void)cancelbuttonClicked:(id)sender{
    
    [alertWindow removeFromSuperview];
}
-(void)routeMap:(id)sender{
    
    
    alertWindow = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; // you must release the window somewhere, when you do not need it anymore
    alertWindow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    alertView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 420)];
    alertView.backgroundColor = [UIColor grayColor];
    alertView.center = CGPointMake(alertWindow.frame.size.width/2, alertWindow.frame.size.height/2);
    alertView.layer.cornerRadius = 10.0;
    alertView.layer.borderWidth = 1.0;
    alertView.layer.borderColor = [[UIColor whiteColor]CGColor];
    [alertView bringSubviewToFront:alertWindow];

    
    UILabel *to = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, 60, 21)];
    to.text = @"To :";
    to.backgroundColor = [UIColor clearColor];
    [alertView addSubview:to];
    
    txtTo = [[UITextField alloc]initWithFrame:CGRectMake(85, 15, 170, 30)];
    txtTo.borderStyle = UITextBorderStyleRoundedRect;
    txtTo.textColor = [UIColor redColor];
    txtTo.placeholder = @"Enter a city";
    txtTo.delegate = self;
    //[txtTo becomeFirstResponder];
   // [txtTo bringSubviewToFront:alertView];
    [alertView addSubview:txtTo];
    
    
    UIButton *btnGo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnGo.frame = CGRectMake(10, 130, 150, 37);
    [btnGo setTitle:@"Show Path" forState:UIControlStateNormal];
    [btnGo addTarget:self action:@selector(googleMap) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:btnGo];
    [alertWindow addSubview:alertView];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnCancel.frame = CGRectMake(190, 130, 80, 37);
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(cancelbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:btnCancel];
    [alertWindow addSubview:alertView];
    
    [self.view addSubview:alertWindow];
    //[alertWindow addSubviewWithZoomInAnimation:alertView duration:1.0 option:curveValues[selectedCurveIndex]];
    //[alertWindow setHidden:NO];

}

- (void)viewDidLoad {
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //stopTripTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(stopTrip) userInfo:nil repeats:YES];
    
	citynamearray = [[NSMutableArray alloc]init];
    latarray = [[NSMutableArray alloc]init];
    longarray =[[NSMutableArray alloc]init];

    btnMap = [UIButton buttonWithType:UIButtonTypeCustom];
   btnMap.enabled = YES;
    btnMap.frame = CGRectMake(189, 366, 111, 37);
    [btnMap setBackgroundImage:[UIImage imageNamed:@"button_green.png"] forState:UIControlStateNormal];
    [btnMap setTitle:@"Map" forState:UIControlStateNormal];
	[btnMap.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[btnMap setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[btnMap addTarget:self action:@selector(routeMap :) forControlEvents:UIControlEventTouchUpInside];
    [btnMap addTarget:self action:@selector(btnMapButtonTapped :) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnMap];
    /* commented by kiran on Jan 21 2013 based on client requirement */
  /*
    btnAbundant = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAbundant.frame = CGRectMake(50, 413, 180, 34);
    [btnAbundant setBackgroundImage:[UIImage imageNamed:@"submit_nor.png"] forState:UIControlStateNormal];
    [btnAbundant setTitle:@"Request trip trunOff" forState:UIControlStateNormal];
	[btnAbundant.titleLabel setFont:[UIFont fontWithName:@"Trebuchet MS" size:15]];
	[btnAbundant setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAbundant addTarget:self action:@selector(abundantButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    btnAbundant.enabled = NO;
    [self.view addSubview:btnAbundant];
   */
    
	[self createImageAssets];
	[self configureLocationManager];
	[self configureWaypointsHelper];
	[self configureWaypointsStore];
	
	[self configureRulesDownloadManager];
	[self configureSchoolsDownloadManager];
	[self configureNotificationSoundsHelper];
	
	[self.rulesDownloadManager useRulesFromDB];
	[self.rulesDownloadManager updateRulesStatusAsPerSchoolZone:NO];
	
	if (!tripFinished) {		
		NSLog(@"Start Tracking Trip....");
		[self startTracking];

		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		[appDelegate.interruptionsHandler startTracking];
		
#ifdef DEBUG 
		//[self addDebugUI];
#endif	
	}	
}
-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.is_abandon_trip = FALSE;
    
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.disableWebValue == 0) {
        
        btnMap.enabled = YES;
    }
    else{
        
        btnMap.enabled = NO;
    }
    
    [super viewDidAppear:animated];
}

-(void) configureWaypointsStore {
	WayPointsStore *wps = [[WayPointsStore alloc] initWithCapacity:kWayPointsStoreSize];
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


- (void) configureLocationManager {
	if (self.locationManager) {
		NSLog(@"Location Manager already existed, no need to set it up....");
		return; //already set up
	}
/*
#ifdef USE_RECORDED_WAYPOINTS
	self.locationManager = [[[FakeLocationManager alloc] init] autorelease];
#else
	CLLocationManager *lManager = [[CLLocationManager alloc] init];
	self.locationManager = lManager;
	[lManager release];
	
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.locationManager.distanceFilter = 0;
#endif
	self.locationManager.delegate = self;*/
    
#if TARGET_IPHONE_SIMULATOR
    
    // Simulator specific code
   self.locationManager = [[[FakeLocationManager alloc] init] autorelease];
    
#else // TARGET_OS_IPHONE
    
    // Device specific code
    CLLocationManager *lManager = [[CLLocationManager alloc] init];
	self.locationManager = lManager;
	[lManager release];
	
	self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	self.locationManager.distanceFilter = 0;
    
#endif // TARGET_IPHONE_SIMULATOR
    self.locationManager.delegate = self;
}

- (void)viewDidUnload {	
	[trackingOnMessageImage release];
	trackingOnMessageImage = nil;
	
	[trackingPausedMessageImage release];
	trackingPausedMessageImage = nil;
	
	[pauseButtonImage release];
	pauseButtonImage = nil;
	
	[startButtonImage release];
	startButtonImage = nil;
	
	self.delegate = nil;
	
	self.ruleMessage = nil;
	
	self.pauseStartTrackingButton = nil;
	self.trackingStatusMessageImageView = nil;
	
	self.phoneStatusImageView = nil;
	self.smsStatusImageView = nil;
	self.schoolStatusImageView = nil;
	
	self.phoneStatusLabel = nil;
	self.smsStatusLabel = nil;
	self.schoolStatusLabel = nil;
}

-(void) setSchoolZoneWarning {
	self.ruleMessage = @"You are currently near a school zone. Please watch posted speeds and rules.";
}

-(void) clearSchoolZoneWarning {
	self.ruleMessage = @"";
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

/*- (void)dealloc {
	
	[self cleanUpSchoolDownloadManager];
	[self cleanUpRulesDownloadManager];
	
	[notificationSoundsHelper release];
	
	[progressHUD release];
	
	[trackingOnMessageImage release];
	[trackingPausedMessageImage release];
	
	[pauseButtonImage release];
	[startButtonImage release];
	
	[delegate release];
	
	[pauseStartTrackingButton release];
	[trackingStatusMessageImageView release];
	
	[wayPointsFileHelper release];
	[wayPointsStore release];

	
	[emergencyNumbersHelper release];
	
	[phoneStatusImageView release];
	[smsStatusImageView release];
	[schoolStatusImageView release];
	
	[phoneStatusLabel release];
	[smsStatusLabel release];
	[schoolStatusLabel release];
	
	[phoneActive release];
	[phoneInactive release];
	
	[smsActive release];
	[smsInactive release];
	
	[schoolActive release];
	[schoolInactive release];
	[stopTripTimer release];
	
	
#ifdef DEBUG	
	[debugController release];
	[debugConsole release];
	[emailWaypointsFileSwitch release];	
	[raceToEndButton release];
#endif
	
    [super dealloc];
}*/

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
	
	[self showHUD];
	[self filterWaypoints];
	
	[self performSelectorOnMainThread:@selector(doneFilteringWaypoints) withObject:nil waitUntilDone:NO];
	[pool release];
}

-(void) doneFilteringWaypoints {
	[self hideHUD];
	[self showAddTripViewController];	
}


-(void) startTracking {
	tracking = YES;
	[locationManager startUpdatingLocation];
	[self.pauseStartTrackingButton setImage:pauseButtonImage forState:UIControlStateNormal];
	self.trackingStatusMessageImageView.image = trackingOnMessageImage;
}

-(void) pauseTracking {
	tracking = NO;
	[locationManager stopUpdatingLocation];
	[self.pauseStartTrackingButton setImage:startButtonImage forState:UIControlStateNormal];
	self.trackingStatusMessageImageView.image = trackingPausedMessageImage;
}

-(void) stopTracking {	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (paused) { //User presses Stop Button in paused state
		tracking = YES;
		paused = NO;
		[appDelegate.interruptionsHandler trackingResumed];
	}
	
	if (tracking) {
		tracking = NO;
		tripFinished = YES;
		[appDelegate.interruptionsHandler stopTracking];
		[self performSelectorInBackground:@selector(startFilteringWaypoints) withObject:nil];
	} else {
		[self showAddTripViewController];
	}
}

-(NSString *) ruleMessage {
	return ruleMessage;
}

-(void) setRuleMessage:(NSString *) newMessage {
	[ruleMessage release];
	ruleMessage = [newMessage retain];
}
/*
-(EmergencyNumbersHelper *) emergencyNumbersHelper {
	if (emergencyNumbersHelper == nil) {
		emergencyNumbersHelper = [[[EmergencyNumbersHelper alloc] init] retain];
	}
	
	return emergencyNumbersHelper;
}*/

#pragma mark -
#pragma mark Status Updates

-(void) updatePhoneStatusToActive {
	self.phoneStatusLabel.textColor = [UIUtils colorFromHexColor:RULE_STATUS_ACTIVE_COLOR];
	self.phoneStatusImageView.image = phoneActive;
	[notificationSoundsHelper enqueuePhoneActiveStatus:YES];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.interruptionsHandler.phoneRuleActive = YES;
}

-(void) updatePhoneStatusToInactive {
	self.phoneStatusLabel.textColor = [UIUtils colorFromHexColor:RULE_STATUS_INACTIVE_COLOR];
	self.phoneStatusImageView.image = phoneInactive;
	[notificationSoundsHelper enqueuePhoneActiveStatus:NO];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.interruptionsHandler.phoneRuleActive = NO;
}


-(void) updateSMSStatus:(BOOL) smsStatus playNotifySound:(BOOL) notifySound {
	if (smsStatus) {
		self.smsStatusLabel.textColor = [UIUtils colorFromHexColor:RULE_STATUS_ACTIVE_COLOR];
		self.smsStatusImageView.image= smsActive;
	} else {
		self.smsStatusLabel.textColor = [UIUtils colorFromHexColor:RULE_STATUS_INACTIVE_COLOR];
		self.smsStatusImageView.image= smsInactive;
	}
	
	if (notifySound) {
		[notificationSoundsHelper enqueueSMSActiveStatus:smsStatus];
	}
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.interruptionsHandler.smsRuleActive = smsStatus;
}

-(void) updateSchoolStatusToActive {
	self.schoolStatusLabel.textColor = [UIUtils colorFromHexColor:RULE_STATUS_ACTIVE_COLOR];
	self.schoolStatusImageView.image = schoolActive;
	[notificationSoundsHelper enqueueSchoolActiveStatus:YES];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	//appDelegate.interruptionsHandler.schoolZoneActive = YES;
    appDelegate.interruptionsHandler.schoolZoneActive = @"VIOLATION";
}
	
-(void) updateSchoolStatusToInactive {
	self.schoolStatusLabel.textColor = [UIUtils colorFromHexColor:RULE_STATUS_INACTIVE_COLOR];
	self.schoolStatusImageView.image = schoolInactive;
	[notificationSoundsHelper enqueueSchoolActiveStatus:NO];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	//appDelegate.interruptionsHandler.schoolZoneActive = NO;
    appDelegate.interruptionsHandler.schoolZoneActive = @"VIOLATION";
}



-(void) receivedNewSchools {
	BOOL schoolZoneStatus = NO;
	
	if ((self.schoolsDownloadManager.schoolsArr != nil) && (rulesDownloadManager.lastknownWaypoint != nil)) {
		schoolZoneStatus = [self.schoolsDownloadManager waypoint:rulesDownloadManager.lastknownWaypoint fallsInSchoolZoneRadius:kSchoolCheckRadius];
	}
	

	if(schoolZoneStatus) {
		[self updateSchoolStatusToActive];
	} else {
		[self updateSchoolStatusToInactive];
	}

	
	[self.rulesDownloadManager updateRulesStatusAsPerSchoolZone:schoolZoneStatus];
	
#ifdef DEBUG
	NSMutableString *schoolsStr = [[NSMutableString alloc] initWithCapacity:200];
	
	NSDate *date = [NSDate date];
	
	[schoolsStr appendString:[date description]];
	[schoolsStr appendString:@"\n-----------------------------------------"];
	int i = 0;
	
	NSMutableArray *schoolsArr = [[NSMutableArray alloc] initWithCapacity: self.schoolsDownloadManager.schoolsArr.count];
	
	for (SCSchool *school in self.schoolsDownloadManager.schoolsArr ) {
		[schoolsArr addObject:school.name];
	}
	
	[schoolsArr sortUsingSelector:@selector(caseInsensitiveCompare:)];
	
	for (NSString *schoolName in schoolsArr) {
		i++;
		[schoolsStr appendFormat:@"\n%d. %@", i, schoolName];
	}
	[schoolsStr appendString:@"\n=========================================\n"];
	
	debugController.schoolsView.text = [NSString stringWithFormat:@"%@%@", debugController.schoolsView.text, schoolsStr];
	
	NSRange range = NSMakeRange([debugController.schoolsView.text length] - 2, 1);
	
	[debugController.schoolsView scrollRangeToVisible:range];
	
	[schoolsStr release];
	[schoolsArr release];
#endif
}

-(void) receivedNewRules {
	
	BOOL schoolZoneStatus = NO;
	
	if ((self.schoolsDownloadManager.schoolsArr != nil) && (rulesDownloadManager.lastknownWaypoint != nil)) {
		schoolZoneStatus = [self.schoolsDownloadManager waypoint:rulesDownloadManager.lastknownWaypoint fallsInSchoolZoneRadius:kSchoolCheckRadius];
	}
	
	if(schoolZoneStatus) {
		[self updateSchoolStatusToActive];
	} else {
		[self updateSchoolStatusToInactive];
	}
	
	[self.rulesDownloadManager updateRulesStatusAsPerSchoolZone:schoolZoneStatus];
	
#ifdef DEBUG
	NSMutableString *rulesStr = [[NSMutableString alloc] initWithCapacity:200];
	
	NSDate *date = [NSDate date];
	
	[rulesStr appendString:[date description]];
	[rulesStr appendString:@"\n-----------------------------------------"];
	int i = 0;
	
	for (SCRule *rule in [self.rulesDownloadManager rules] ) {
		i++;
		[rulesStr appendFormat:@"\n%d. %@ %@", i, rule.ruleType, [rule ruleDescription]];
	}
	
	[rulesStr appendString:@"\n=========================================\n"];
	
	debugController.rulesView.text = [NSString stringWithFormat:@"%@%@", debugController.rulesView.text, rulesStr];
	
	NSRange range = NSMakeRange([debugController.rulesView.text length] - 2, 1);
	
	[debugController.rulesView scrollRangeToVisible:range];
	
	[rulesStr release];
#endif
}

#pragma mark Action Sheet Delegate Method
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (( (buttonIndex - 1) > ([emergencyContacts count] - 1)) //cancel is the first button
		|| 
		(buttonIndex == [actionSheet cancelButtonIndex])) {		
		return;
	}else{
        
        if ([[[emergencyContacts objectAtIndex:buttonIndex - 1]objectForKey:@"inbound"] isEqualToString:@"true"]) {
           
            [self performSelector:@selector(alertView:didDismissWithButtonIndex:) withObject:nil afterDelay:0];
           // [self alertView:alertVi didDismissWithButtonIndex:kStopTripYesButton];
            
            NSString *dialerURL = [NSString stringWithFormat:@"tel://%@", [[emergencyContacts objectAtIndex:buttonIndex - 1]objectForKey:@"pno"]];
            NSLog(@"dialerURL = %@",dialerURL);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialerURL]];
        }
        
        
        
    
    }
	
	
}

#pragma mark -
#pragma mark Actions

-(IBAction) stopButtonTapped: (id) sender {	
	alert = [[UIAlertView alloc] initWithTitle:@"Stop Tracking?" message:@"Do you really want to stop this trip?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[alert show];
	[alert release];	
}

-(IBAction) pauseStartTrackingButtonTapped: (id) sender {
   // [self dismissViewControllerAnimated:YES completion:nil];
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	if(tracking) {
		[self pauseTracking];	
		paused = YES;
		[appDelegate.interruptionsHandler trackingPaused];
	} else {
		[self startTracking];
		paused = NO;
		[appDelegate.interruptionsHandler trackingResumed];
	}
}

-(IBAction) btnMapButtonTapped:(id)sender {
    NSLog(@"Mapp button tapped");
    
    UIApplication *ourApplication = [UIApplication sharedApplication];
    
    NSString *ourPath = @"comgooglemaps://";
    
    NSURL *ourURL = [NSURL URLWithString:ourPath];
    
    if ([ourApplication canOpenURL:ourURL]) {
        
        [ourApplication openURL:ourURL];
        
    }
    
    else {
        
        //Display error
        NSLog(@"Problem to display maps");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Receiver Not Found" message:@"The Receiver App is not installed. It must be installed to send text." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        [alertView release];
        
    }
    
    
    
}

-(IBAction) placeEmergencyCallButtonTapped: (id) sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@"appDelegate.managerCheckingValu = %d",appDelegate.managerCheckingValue);
	NSString *master = [NSString stringWithFormat:@"http://www.safecellapp.mobi/api/%d/emergencynum/%d",1,appDelegate.masterProfileKeyValue];
    NSURL *url = [NSURL URLWithString:master];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    NSString *resString = [[NSString alloc]initWithData:responseData encoding:NSASCIIStringEncoding];
    NSLog(@"resString = %@",resString);
    
    emergencyContacts = [[NSMutableArray alloc]init];
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]init];
    
    if ([responseData length]!= 0) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        NSArray *array = [responseDict objectForKey:@"emergencynumbers"];
        NSLog(@"array = %@",array);
        for (int i = 0; i< [array count]; i++) {
            
            NSDictionary *dic = [array objectAtIndex:i];
            [mutDic setObject:[dic objectForKey:@"name"] forKey:@"cname"];
            [mutDic setObject:[dic objectForKey:@"value"] forKey:@"pno"];
            [mutDic setObject:[dic objectForKey:@"inbound"] forKey:@"inbound"];
            NSDictionary *dicFinal = [mutDic copy];
            [emergencyContacts addObject:dicFinal];
            [dicFinal release];
        }

    }
    else{
        [mutDic setObject:@"Emergency" forKey:@"cname"];
        [mutDic setObject:@"911" forKey:@"pno"];
        [mutDic setObject:@"true" forKey:@"inbound"];
        NSDictionary *emergencyDic = [mutDic copy];
        [emergencyContacts addObject:emergencyDic];
        [emergencyDic release];
    }
       
    NSLog(@"mutArray = %@",emergencyContacts);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Emergency Call List" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    for (int i = 0; i< [emergencyContacts count]; i++) {
		[actionSheet addButtonWithTitle:[[emergencyContacts objectAtIndex:i]objectForKey:@"cname"]]; 
	}
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
    [actionSheet release];
    //[emergencyContacts release];
    //[mutDic release];
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
    latitudeStr = [ NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    longitudeStr = [ NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    NSLog(@" trak %@,%@",latitudeStr,longitudeStr);
	destinationCityArray = [[NSArray alloc]initWithObjects:latitudeStr ,longitudeStr, nil];
	SCWaypoint *waypoint = [[SCWaypoint alloc] initWithCLLocation:newLocation journeyId:kJourneyIdNotPersisted];
	
	[wayPointsStore pushWayPoint:waypoint];
	[wayPointsFileHelper writeWayPoint:waypoint];
	
	BOOL fallsInSchoolZone = [schoolsDownloadManager waypoint:waypoint fallsInSchoolZoneRadius:kSchoolCheckRadius];
	
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
	
#ifdef DEBUG
	NSLog(@"wayPoint: %@", [waypoint JSONRepresentation]);
	[debugController logWaypoint:waypoint];
#endif
	
    /* Code edited by kiran. Instead of stopTrip method and it's timmer*/
    /* Moniter current trip speed and start auto trip stop timer for configured speed*/
    
    
    NSLog(@"Trip start speed: %d, Current speed: %d, Trip stop time: %d: ", appDelegate.tripStartTime, appDelegate.speedValue, appDelegate.tripStopTime);
    
    if(appDelegate.isTripStarted) {
    
    if (appDelegate.speedValue < appDelegate.tripStartTime) {
        /*start atuotripstop  timer if not exist */
        if(timerForSavingTrip == nil && ![timerForSavingTrip isValid] ) {
        
        [[[[iToast makeText:[NSString stringWithFormat:@"Starting AutoTripStop timer."]]setGravity:iToastGravityBottom] setDuration:iToastDurationLong] show];
        NSLog(@"Auto trip stop timer started.");
        timerForSavingTrip = [NSTimer scheduledTimerWithTimeInterval:appDelegate.tripStopTime * 60 target:self selector:@selector(tripSaveToServer) userInfo:nil repeats:NO];
        }
        
        
    } // end of speed lessthan config value. 
    else{
        if ([timerForSavingTrip isValid]) {
            [[[[iToast makeText:[NSString stringWithFormat:@"Canceling AutoTripStop timer."]]setGravity:iToastGravityBottom] setDuration:iToastDurationLong] show];
            NSLog(@"Auto trip stop timer Cancled.");
            
            [timerForSavingTrip invalidate];
            timerForSavingTrip = nil;
            
        }
        
    }
    } //end of isTripStarted if condition
    
    
    
    
    
    
    
    
    
	[waypoint release];
}


#pragma mark -
#pragma mark FakeLocationManagerDelegate
-(void) reachedToEndofRecordedWayPointsFile {
	[self stopButtonTapped:nil];
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if(buttonIndex == kStopTripYesButton) {
		
		[locationManager stopUpdatingLocation];	
		
		self.locationManager.delegate = nil;
		self.locationManager = nil;
		
		[wayPointsFileHelper closeWayPointFile];
		[wayPointsFileHelper archiveWayPointsFile];		
		
		
		[self cleanUpRulesDownloadManager];
		[self cleanUpSchoolDownloadManager];
		
		[notificationSoundsHelper cleanUpBeforeStoppingTrip];
	
	
#ifdef DEBUG
	
		if([MFMailComposeViewController canSendMail]) {
			if(emailWaypointsFileSwitch.on) {
				MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
				controller.mailComposeDelegate = self;
				[controller setSubject:@"Safecell App: WayPoints File"];
				[controller setMessageBody:@"Find the file attched." isHTML:NO];
				
				NSData *wayPointsZipData = [wayPointsFileHelper wayPointsZipFileData];
				
				[controller addAttachmentData:wayPointsZipData mimeType:@"application/zip" fileName:kWayPointZipFileName];
				
				[self presentViewController:controller animated:YES completion:nil];
				[controller release];	
			} else {
				[self stopTracking];
				return;
			}
		} else {
			[self stopTracking];
			return;
		}
#else
		[self stopTracking];
#endif	
	}
}

-(void)tripSaveToServer{
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSLog(@"Trip save to server.");

    
    if (appdelegate.speedValue < appdelegate.tripStartTime) {
        
        if (appdelegate.logWayPointValue == 1) {
            
            [stopTripTimer invalidate];
            stopTripTimer = nil;
            //UIAlertView *alert;
            //[self alertView:alert didDismissWithButtonIndex:1];
            [self performSelector:@selector(alertView:didDismissWithButtonIndex:) withObject:nil afterDelay:2];
            
        }
        
    }
    
}


-(void)stopTrip
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@"Trip start speed: %d, Current speed: %d, Trip stop time: %d: ", appdelegate.tripStartTime, appdelegate.speedValue, appdelegate.tripStopTime);
    
    if (appdelegate.speedValue < appdelegate.tripStartTime) {
        [[[[iToast makeText:[NSString stringWithFormat:@" Auto trip stop timer started."]]setGravity:iToastGravityTop] setDuration:iToastDurationNormal] show];
        NSLog(@"Auto trip stop timer started.");
        [stopTripTimer invalidate];
        stopTripTimer = nil;
        timerForSavingTrip = [NSTimer scheduledTimerWithTimeInterval:appdelegate.tripStopTime * 60 target:self selector:@selector(tripSaveToServer) userInfo:nil repeats:YES];
        
        
    }else{
        // stop the 60 seconds timer
        if ([timerForSavingTrip isValid]) {
            [[[[iToast makeText:[NSString stringWithFormat:@" Auto trip stop timer cancled."]]setGravity:iToastGravityTop] setDuration:iToastDurationNormal] show];
            NSLog(@"Auto trip stop timer Cancled.");
            [timerForSavingTrip invalidate];
            timerForSavingTrip = nil;
            stopTripTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(stopTrip) userInfo:nil repeats:YES];
        }
        
    }

    /*AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (appdelegate.speedValue < 5) {
       
        if (appdelegate.logWayPointValue == 1) {
            
            [stopTripTimer invalidate];
            stopTripTimer = nil;
            [self alertView:alert didDismissWithButtonIndex:kStopTripYesButton];
        }
        
        
    }*/
}
#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller 
		  didFinishWithResult:(MFMailComposeResult)result 
						error:(NSError*)error {
	[self dismissViewControllerAnimated:NO completion:nil];
	[self stopTracking];
   
}


#pragma mark -
#pragma mark AddTripViewControllerDelegate

-(void) tripSavingFinished {
	[self dismissSelf];
}

#pragma mark -
#pragma mark Debug Mode Methods

#ifdef DEBUG

-(void) addEmailLabel {
	UILabel * emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 420, 140, 25)];
	emailLabel.text = @"Email WayPoints";
	emailLabel.backgroundColor = [UIColor clearColor];
	emailLabel.font = [UIFont boldSystemFontOfSize:12];
	[debugController.view addSubview:emailLabel];
	[emailLabel release];
}

-(void) addEmailWaypointsFileSwitch {
	emailWaypointsFileSwitch = [[UISwitch alloc]  initWithFrame:CGRectMake(150, 420, 200, 30)];
	emailWaypointsFileSwitch.on = NO;
	[debugController.view addSubview:emailWaypointsFileSwitch];
}

-(void) addShowDebugButton {
	UIButton *debugButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	debugButton.frame = CGRectMake(300, 10, 15, 15);
	[debugButton addTarget:self action:@selector(showDebug) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:debugButton];
}

-(void)showDebug {
	[self.view addSubview:debugController.view];
}

-(void) addRaceToEndButton {
	
	raceToEndButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	raceToEndButton.frame = CGRectMake(5, 20, 100, 38);
	[raceToEndButton setTitle:@"Race to End" forState:UIControlStateNormal];
	[raceToEndButton addTarget:self action:@selector(raceToEndTapped) forControlEvents:UIControlEventTouchUpInside];

	[debugController.view addSubview:raceToEndButton];
}

-(void) addDebugUI {		
	
	debugController = [[DebugTrackingInformationController alloc] initWithNibName:@"DebugTrackingInformationController" bundle:nil];
	
	int count = [wayPointsFileHelper countWaypointsInFile];	
	
	debugController.numWaypoints = count;
	
	[self addShowDebugButton];
	[self addEmailLabel];
	[self addEmailWaypointsFileSwitch];		
	
#ifdef USE_RECORDED_WAYPOINTS
	[self addRaceToEndButton];
#endif
	
	
}

-(void)raceToEndTapped {
	raceToEndButton.enabled = NO;
	FakeLocationManager * manager = (FakeLocationManager *) locationManager;
	manager.raceToEnd = YES;
}

#endif


@end
