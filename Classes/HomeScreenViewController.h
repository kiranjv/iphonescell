//
//  HomeViewController.h
//  safecell
//
//  Created by shail on 05/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackingViewController.h"
#import "SelectWaypointsFileViewController.h"
#import "SelectPictureHelper.h"
#import "ProfilePicHelper.h"
#import "LoginViewController.h"
#import "PSLocationManager.h"
#import "SplashScreenViewController.h"
#import "ProfileRepository.h"

#import "RulesDownloadManager.h"
#import "SchoolsDownloadManager.h"
#import "NotificationSoundsHelper.h"
#import "AddTripViewController.h"

@class SCProfile;
@class LoginViewController;
@class SplashScreenViewController;
@class WayPointsStore;
@class WayPointsFileHelper;

@interface HomeScreenViewController : UIViewController <UITableViewDataSource, SelectWaypointsFileViewControllerDelegate,
UITableViewDelegate, TrackingViewControllerDelegate, SelectPictureHelperDelegate,LoginViewControllerDelegate,PSLocationManagerDelegate,CLLocationManagerDelegate,AddTripViewControllerDelegate> {
	UILabel *lblUserName;
	UILabel *lblLevelNo;
	UILabel *lblTrips;
	UILabel *lblGrade;
	UILabel *lblTotalSafeMiles;
    
	UILabel *lblGradeTitle;
	UILabel *lblTotalMilesTitle;
	
	UIImageView *tripsBackgroundImageView;
	UIImageView *gradeBackgroundImageView;
	UIImageView *milesBackgroundImageView;
	
	UIButton *userPhoto;
	UITableView *tripsTable;
	
	SCProfile *userProfile;
    LoginViewController *loginViewController;
    
	SelectPictureHelper* selectPictureHelper;
	ProfilePicHelper *profilePicHelper;
	BOOL gameplayStatus;
    NSTimer *reloadTimer;
    NSTimer *tripStopTimer;
    NSString *phoneNumber;
    int configSpeed;
    float avg_Speed;
	float distanceInKM;
    int capacity;
    NSMutableArray *capacityArray;
    NSString *strengthText;
    int splashDisplayValue;
    
    WayPointsFileHelper *wayPointsFileHelper;
    WayPointsStore *wayPointsStore;
    BOOL tripFinishedd;
    BOOL trackingg;
    RulesDownloadManager *rulesDownloadManager;
	SchoolsDownloadManager *schoolsDownloadManager;
    TrackingViewController *trackingController;
    NotificationSoundsHelper *notificationSoundsHelper;
    CLLocationManager *cllocationManager;
    NSTimer *savingTimer;
}

/*@property (nonatomic,retain) NSTimer *reloadTimer;
@property (nonatomic,assign) int splashDisplayValue;
@property (nonatomic,retain) NSString *strengthText;
@property (nonatomic,retain) IBOutlet UILabel *lblUserName;
@property (nonatomic,retain) IBOutlet UILabel *lblLevelNo;
@property (nonatomic,retain) IBOutlet UILabel *lblTrips;
@property (nonatomic,retain) IBOutlet UILabel *lblGrade;
@property (nonatomic,retain) IBOutlet UILabel *lblTotalSafeMiles;
@property (nonatomic,retain) IBOutlet UIButton *userPhoto;
@property (nonatomic,retain) IBOutlet UITableView *tripsTable;

@property (nonatomic,retain) IBOutlet UILabel *lblGradeTitle;
@property (nonatomic,retain) IBOutlet UILabel *lblTotalMilesTitle;

@property (nonatomic,retain) IBOutlet UIImageView *tripsBackgroundImageView;
@property (nonatomic,retain) IBOutlet UIImageView *gradeBackgroundImageView;
@property (nonatomic,retain) IBOutlet UIImageView *milesBackgroundImageView;
@property (nonatomic,assign) int configSpeed;
@property (nonatomic,assign) float avg_Speed;
@property (nonatomic,assign) float distanceInKM;
@property (nonatomic,retain) SCProfile *userProfile;
@property (nonatomic,retain) SelectPictureHelper* selectPictureHelper;

@property(nonatomic, retain) WayPointsStore *wayPointsStore;
@property(nonatomic, retain) RulesDownloadManager *rulesDownloadManager;
@property(nonatomic, retain) SchoolsDownloadManager *schoolsDownloadManager;
@property(nonatomic, retain) CLLocationManager *cllocationManager;*/
@property (nonatomic,strong) NSTimer *reloadTimer;
@property (nonatomic,assign) int splashDisplayValue;
@property (nonatomic,strong) NSString *strengthText;
@property (nonatomic,strong) IBOutlet UILabel *lblUserName;
@property (nonatomic,strong) IBOutlet UILabel *lblLevelNo;
@property (nonatomic,strong) IBOutlet UILabel *lblTrips;
@property (nonatomic,strong) IBOutlet UILabel *lblGrade;
@property (nonatomic,strong) IBOutlet UILabel *lblTotalSafeMiles;
@property (nonatomic,strong) IBOutlet UIButton *userPhoto;
@property (nonatomic,strong) IBOutlet UITableView *tripsTable;

@property (nonatomic,strong) IBOutlet UILabel *lblGradeTitle;
@property (nonatomic,strong) IBOutlet UILabel *lblTotalMilesTitle;

@property (nonatomic,strong) IBOutlet UIImageView *tripsBackgroundImageView;
@property (nonatomic,strong) IBOutlet UIImageView *gradeBackgroundImageView;
@property (nonatomic,strong) IBOutlet UIImageView *milesBackgroundImageView;
@property (nonatomic,assign) int configSpeed;
@property (nonatomic,assign) float avg_Speed;
@property (nonatomic,assign) float distanceInKM;
@property (nonatomic,strong) SCProfile *userProfile;
@property (nonatomic,strong) SelectPictureHelper* selectPictureHelper;

@property(nonatomic, strong) WayPointsStore *wayPointsStore;
@property(nonatomic, strong) RulesDownloadManager *rulesDownloadManager;
@property(nonatomic, strong) SchoolsDownloadManager *schoolsDownloadManager;
@property(nonatomic, strong) CLLocationManager *cllocationManager;



-(void)switchToBackgroundMode:(BOOL)background;
-(void) loadData;
-(void) showAddTripViewController;
-(void) showTrackingViewController;
-(void)startBasedOnSpeed;

-(IBAction) startNewTripButtonTapped: (id) sender;
-(IBAction) userProfileButtonTapped: (id) sender;

@end
