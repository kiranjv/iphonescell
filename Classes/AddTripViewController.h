//
//  AddTripViewController.h
//  safecell
//
//  Created by shail on 08/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkOperationDelegate.h"
#import "ModalViewControllerDelegate.h"
#import "Debug.h"
#import <MessageUI/MessageUI.h>
#import "EmailTripFileHelper.h"
#import "ProgressHUD.h"

@class SCTrip;
@class SCTripJourney;
@class TripInfoSection;
@class SaveTripSection;
@class ExistingTripsSection;
@class SubmitNewTripJourney;
@class RootViewController;


typedef enum _TripSaveResult {
	TripSaveResultInProcess,
	TripSaveResultSuccess,
	TripSaveResultFailedWithNetwokError,
	TripSaveResultFailedWithAppError,
	TripSaveResultCancelled
	
} TripSaveResult;


@protocol AddTripViewControllerDelegate<NSObject>
-(void) tripSavingFinished;
@end

@interface AddTripViewController : C1TableViewController<UIAlertViewDelegate, NetworkOperationDelegate, 
ModalViewControllerDelegate, MFMailComposeViewControllerDelegate> {
	SCTripJourney *journey;
	TripInfoSection *tripInfoSection;
	SaveTripSection *saveTripSection;
	
	SCTrip *selectedTrip;
	SubmitNewTripJourney *submitNewTripJourney;
	id<AddTripViewControllerDelegate> delegate;
	
	EmailTripFileHelper *emailTripFileHelper;
															
	int tripSavingSuccess;
															
	BOOL poppedMapDueToMemoryWarning;
	ProgressHUD *progressHUD;
}

@property (nonatomic, retain) SubmitNewTripJourney *submitNewTripJourney;
@property (nonatomic, retain) SCTripJourney *journey;
@property (nonatomic, retain) SCTrip *selectedTrip;
@property (nonatomic, assign) id<AddTripViewControllerDelegate> delegate;

-(void) setupTable;
-(TripInfoSection *) tripInfoSection;
-(SaveTripSection *) saveTripSection;


-(void) setUpNavigationBar;
-(void) saveTripButtonTapped: (id) sender;
-(BOOL) validateNameOfTrip;

-(void) clearPoppedMapWarningFlag;
-(void) setPoppedMapWarningFlag;

-(void) deleteLocalTripFiles;

@end
