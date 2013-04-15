//
//  safecellAppDelegate.h
//  safecell
//
//  Created by Ben Scheirman on 3/16/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "SCProfile.h"
#import "LocationStripeController.h"
#import "InterruptionsHandler.h"
#import "LocationHelper.h"
#import "ReachabilityChecker.h"

#define kSettingsTabIndex 3

#define kTripGUID @"tripGUID"
#define kAccountGUID @"accountGUID"

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UIViewController *viewController;
	
	RootViewController *rootController;
	
	SCProfile *currentProfile;
	LocationStripeController *locationStripeController;
	InterruptionsHandler *interruptionsHandler;
	LocationHelper *locationHelper;
	ReachabilityChecker *reachabilityChecker;
	
	UIView *waitingForInternetView;
	
	NSTimer *reachabilityCheckTimer;
    
    NSInteger managerCheckingValue;
    NSInteger masterProfileKeyValue;
    NSDate *strStartDate;
    NSDate *strEndDate;
    NSDate *strExpiredDate;
    int licenseSubsription;
    NSString *futuredateString;
    NSString *phoneNumber;
    int speedValue;
    NSString *currentLatValue;
    NSString *currentLongValue;
    float totalMiles;
    int tripStopTime;
    int tripStartTime;
    NSString *profileStatusCheck;
    int disableWebValue;
    int logWayPointValue;
    BOOL is_abandon_trip;
    BOOL isTripStarted;
    BOOL isMapInterruption;
    NSString *is_AppBackground;
    int currentSpeed;
    NSString *isSaveTrip;
}
@property (nonatomic, strong) NSString *isSaveTrip;
@property (nonatomic, strong) NSString *is_AppBackground;
@property (nonatomic, assign) int currentSpeed;
@property (nonatomic, assign) BOOL is_abandon_trip;
@property (nonatomic, assign) BOOL isTripStarted;
@property (nonatomic, assign) BOOL isMapInterruption;
@property (nonatomic, assign) int disableWebValue;
@property (nonatomic, assign) int logWayPointValue;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *viewController;
@property (nonatomic, readonly) RootViewController *rootController;
@property (nonatomic, readonly) LocationHelper *locationHelper;
@property (nonatomic, assign) NSInteger managerCheckingValue;
@property (nonatomic, assign) NSInteger masterProfileKeyValue;
@property (nonatomic, assign) int licenseSubsription;
@property (nonatomic, assign) int speedValue;
@property (nonatomic, assign) float totalMiles;
@property (nonatomic, assign) int tripStopTime;
@property (nonatomic, assign) int tripStartTime;

@property (nonatomic, retain) SCProfile *currentProfile;
@property (nonatomic, retain) InterruptionsHandler *interruptionsHandler;
@property (nonatomic, retain) NSTimer *reachabilityCheckTimer;
@property (nonatomic, strong) NSDate *strStartDate;
@property (nonatomic, strong) NSDate *strEndDate;
@property (nonatomic, strong) NSString *futuredateString;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *currentLatValue;
@property (nonatomic, strong) NSString *currentLongValue;
@property (nonatomic, strong) NSString *profileStatusCheck;
@property (nonatomic, strong) NSDate *strExpiredDate;


-(void) initializeDatabase;
-(void) loadTabBar: (int) showIndex;
-(void) loadCurrentProfile;
-(void) startLocationHelper;
-(void) stopLocationHelper;
-(void) createLocationStripe;
-(void) addLocationStripe;

-(void) configureLocationUpdateRelatedObjects;

-(void)calculateSpeed :(CLLocation *)location;

@end

