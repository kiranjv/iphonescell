//
//  TrackingViewController.h
//  safecell
//
//  Created by shail on 06/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Debug.h"
#import "FakeLocationManager.h"
#import "RulesDownloadManager.h"
#import "SchoolsDownloadManager.h"
#import "WaypointFilter.h"
#import "EmergencyNumbersHelper.h"
#import "AddTripViewController.h"
#import "ProgressHUD.h"
#import "NotificationSoundsHelper.h"
#import <MapKit/MapKit.h> 

#ifdef DEBUG 
#import <MessageUI/MessageUI.h>
#import "DebugTrackingInformationController.h"
#endif

@class WayPointsFileHelper;
@class WayPointsStore;
@class GoogleMap;

@protocol TrackingViewControllerDelegate<NSObject>

-(void) trackingViewFinishedTracking;

@end


@interface TrackingViewController : UIViewController<CLLocationManagerDelegate, UIAlertViewDelegate, 
													MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate, AddTripViewControllerDelegate,
													FakeLocationManagerDelegate,UIActionSheetDelegate,UITextFieldDelegate, MKMapViewDelegate> {
	id<TrackingViewControllerDelegate> delegate;
                                                        
                                                        
    IBOutlet MKMapView* myMapView;
                                                        
	
    NSArray *destinationCityArray; 
                                                        NSString *latitudeStr;
                                                        NSString *longitudeStr;
                                                        NSString *oldLatitudeStr;
                                                        NSString *oldLongitudeStr;
                                                        UITextField *txtTo;
    UIButton *btnMap;
    UIButton *btnAbundant;
    UIImage *trackingOnMessageImage;
	UIImage *trackingPausedMessageImage;
	
	UIImage *pauseButtonImage;
	UIImage *startButtonImage;
	
	BOOL tracking;
	BOOL paused;
	NSString *ruleMessage;	
	UIButton* pauseStartTrackingButton;
	UIImageView* trackingStatusMessageImageView;
														
	UIImageView *phoneStatusImageView;
	UIImageView *smsStatusImageView;
	UIImageView *schoolStatusImageView;
	
	UILabel *phoneStatusLabel;
	UILabel *smsStatusLabel;
	UILabel *schoolStatusLabel;
                                                        UIView *alertWindow;
                                                        UIView *alertView;
                                                        NSMutableArray *emergencyContacts;
	
	CLLocationManager *locationManager;
	WayPointsFileHelper *wayPointsFileHelper;
	WayPointsStore *wayPointsStore;
	
														
	RulesDownloadManager *rulesDownloadManager;
	SchoolsDownloadManager *schoolsDownloadManager;
	
	EmergencyNumbersHelper *emergencyNumbersHelper;
														
	UIImage *phoneActive;
	UIImage *phoneInactive;
	
	UIImage *smsActive;
	UIImage *smsInactive;
	
	UIImage *schoolActive;
	UIImage *schoolInactive;
	ProgressHUD *progressHUD;
	BOOL tripFinished;	
														
	NotificationSoundsHelper *notificationSoundsHelper;
                                                        NSMutableArray *citynamearray;
                                                        NSMutableArray *latarray,*longarray;
                                                        NSString *currentLocationStr;
                                                        UIAlertView *alert;
                                                        NSTimer *stopTripTimer;
                                                        NSTimer *timerForSavingTrip;
														
#ifdef DEBUG
	UITextView * debugConsole;
	UISwitch * emailWaypointsFileSwitch;
	UIButton * raceToEndButton;
	DebugTrackingInformationController *debugController;
#endif
}
/*@property(nonatomic, retain) NSTimer *stopTripTimer;
@property(nonatomic, retain) id<TrackingViewControllerDelegate> delegate;
@property(nonatomic, retain) NSString *ruleMessage;
@property(nonatomic, retain) IBOutlet UIButton* pauseStartTrackingButton;
@property(nonatomic, retain) IBOutlet UIImageView* trackingStatusMessageImageView;

@property(nonatomic, retain) IBOutlet UIImageView *phoneStatusImageView;
@property(nonatomic, retain) IBOutlet UIImageView *smsStatusImageView;
@property(nonatomic, retain) IBOutlet UIImageView *schoolStatusImageView;

@property(nonatomic, retain) IBOutlet UILabel *phoneStatusLabel;
@property(nonatomic, retain) IBOutlet UILabel *smsStatusLabel;
@property(nonatomic, retain) IBOutlet UILabel *schoolStatusLabel;

@property(nonatomic, retain) CLLocationManager *locationManager;

@property(nonatomic, retain) RulesDownloadManager *rulesDownloadManager;
@property(nonatomic, retain) SchoolsDownloadManager *schoolsDownloadManager;
@property(nonatomic, retain) WayPointsStore *wayPointsStore;

@property(nonatomic, retain) NSArray *destinationCityArray;

@property (nonatomic,retain) NSMutableArray *citynamearray;
@property (nonatomic,retain) NSMutableArray *latarray,*longarray;
@property (nonatomic,retain) NSString *currentLocationStr;*/
@property(nonatomic, strong) NSTimer *stopTripTimer;
@property(nonatomic, strong) NSTimer *timerForSavingTrip;
@property(nonatomic, strong) id<TrackingViewControllerDelegate> delegate;
@property(nonatomic, strong) NSString *ruleMessage;
@property(nonatomic, strong) IBOutlet UIButton* pauseStartTrackingButton;
@property(nonatomic, strong) IBOutlet UIImageView* trackingStatusMessageImageView;

@property(nonatomic, strong) IBOutlet UIImageView *phoneStatusImageView;
@property(nonatomic, strong) IBOutlet UIImageView *smsStatusImageView;
@property(nonatomic, strong) IBOutlet UIImageView *schoolStatusImageView;

@property(nonatomic, strong) IBOutlet UILabel *phoneStatusLabel;
@property(nonatomic, strong) IBOutlet UILabel *smsStatusLabel;
@property(nonatomic, strong) IBOutlet UILabel *schoolStatusLabel;

@property(nonatomic, strong) CLLocationManager *locationManager;

@property(nonatomic, strong) RulesDownloadManager *rulesDownloadManager;
@property(nonatomic, strong) SchoolsDownloadManager *schoolsDownloadManager;
@property(nonatomic, strong) WayPointsStore *wayPointsStore;

@property(nonatomic, strong) NSArray *destinationCityArray;

@property (nonatomic,strong) NSMutableArray *citynamearray;
@property (nonatomic,strong) NSMutableArray *latarray,*longarray;
@property (nonatomic,strong) NSString *currentLocationStr;
@property (nonatomic,strong) UITextField *txtTo;
@property (nonatomic, strong) IBOutlet UIButton *btnMap;

@property (nonatomic, retain) IBOutlet MKMapView* myMapView;

-(void)displayMYMap;



-(void) dismissSelf;

-(void) startTracking;
-(void) pauseTracking;
-(void) stopTracking;

-(void) configureLocationManager;
-(void) configureWaypointsHelper;
-(void) configureWaypointsStore;

-(void) setSchoolZoneWarning;
-(void) clearSchoolZoneWarning;


-(void) updatePhoneStatusToActive;
-(void) updatePhoneStatusToInactive;

-(void) updateSMSStatus:(BOOL) smsStatus playNotifySound:(BOOL) notifySound;

-(void) updateSchoolStatusToActive;
-(void) updateSchoolStatusToInactive;

-(IBAction) stopButtonTapped: (id) sender;
-(IBAction) pauseStartTrackingButtonTapped: (id) sender;
-(IBAction) placeEmergencyCallButtonTapped: (id) sender;
-(IBAction) btnMapButtonTapped:(id)sender;

-(void) receivedNewRules;
-(void) receivedNewSchools;

#ifdef DEBUG
-(void) addDebugUI;
-(void)raceToEndTapped;
#endif


@end
