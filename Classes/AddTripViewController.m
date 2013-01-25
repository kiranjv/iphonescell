 //
//  AddTripViewController.m
//  safecell
//
//  Created by shail on 08/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddTripViewController.h"
#import "SCTripJourney.h"
#import "TripInfoSection.h"
#import "SaveTripSection.h"
#import "ExistingTripsSection.h"
#import "WayPointsFileHelper.h"
#import "SubmitNewTripJourney.h"
#import "TripRepository.h"
#import "SCTrip.h"
#import "SubmitNewTripJourneyResponseHandler.h"
#import "AppDelegate.h"
#import "InterruptionsFileHelper.h"
#import "TripRepository.h"
#import "NavBarHelper.h"
#import "AlertHelper.h"
#import "EmailTripFileHelper.h"
#import "UserDefaults.h"
#import "RootViewController.h"
#import "iToast.h"

enum {
	kTripNameAlertViewTag = 30001,
	kDeleteTripAlertViewTag = 30002,
	kRetrySavingTripAlertViewTag = 30003
};

@implementation AddTripViewController

@synthesize journey;
@synthesize submitNewTripJourney;
@synthesize delegate;

-(void) showHUD {
	if (progressHUD == nil) {
		progressHUD = [[ProgressHUD alloc] init];
	}
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[progressHUD showHUDWithLable:@"Uploading Trip..." inView:appDelegate.window];
}

-(void) hideHUD {
	[progressHUD hideHUD];
}

-(void) clearPoppedMapWarningFlag {
	poppedMapDueToMemoryWarning = NO;
}

-(void) setPoppedMapWarningFlag {
	poppedMapDueToMemoryWarning = YES;
}

-(void) fixInterruptionsIfRequired {
	for (SCInterruption *interruption in self.journey.interruptions) {
		if (interruption.endedAt == nil) {
			//interruption.endedAt = [interruption.startedAt addTimeInterval:1];
            interruption.endedAt = [interruption.startedAt dateByAddingTimeInterval:1];
			NSLog(@"Fixed Interruption with start time: %@", [interruption startedAt]);
		}
	}
}

-(id)initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
	if (self != nil) {
		
		reactToKeyboard = NO;
		
		[self setUpNavigationBar];
		
		SCTripJourney *latestTrip = [[SCTripJourney alloc] initWithCurrentWayPointsAndInterruptions];
		self.journey = latestTrip;		
		[journey release];
		
		[self fixInterruptionsIfRequired];
		
		[self setupTable];		
		
		emailTripFileHelper = [[EmailTripFileHelper alloc] init];
	}
	return self;
}

- (void)viewDidAppear:(BOOL)animated {
    
    UIAlertView * alertView;
   /*	if([self.journey.waypoints count] < 3) {
		NSLog(@"Journey had %d waypoint(s)", self.journey.waypoints.count);
		alertView = [[UIAlertView alloc] initWithTitle:@"The trip cannot be saved" 
															 message:@"The trip cannot be saved since it is very short." 
															delegate:nil 
												   cancelButtonTitle:@"OK" 
												   otherButtonTitles:nil];
		alertView.tag = kDeleteTripAlertViewTag;
		alertView.delegate = self;
		[alertView show];
		[alertView release];
	}*/
    if ([[journey milesString] floatValue] < 1.0 ) {
        
        NSLog(@"Journey had %d waypoint(s)", self.journey.waypoints.count);
        
       
        /*Code commented by kiran to display long toaster. Instead of alert dialog prompot*/
        
     /*   alertView = [[UIAlertView alloc] initWithTitle:@"The trip cannot be saved"
															 message:@"The trip cannot be saved since it is very short."
															delegate:nil
												   cancelButtonTitle:@"OK"
												   otherButtonTitles:nil];
		alertView.tag = kDeleteTripAlertViewTag;
		alertView.delegate = self;
       
		[alertView show];
		[alertView release]; */
        
        [self dismissSelf];
        [[[[iToast makeText:[NSString stringWithFormat:@"The trip cannot be saved since it is very short."]]setGravity:iToastGravityCenter] setDuration:iToastDurationTooLong] show];
      //  [self.navigationController dismissModalViewControllerAnimated:YES];
        

    }
    else{
        @try {
            [self performSelector:@selector(saveTripButtonTapped:)];
        }
        @catch (NSException *exception) {
            NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
        }
            
    }

	//[self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:2];
	if (poppedMapDueToMemoryWarning) {
		[self clearPoppedMapWarningFlag];
		SimpleAlertOK(@"Insufficient Memory", @"The map was closed because of insufficient memory.");
	}
}

-(void) addEmailTripButton {
	if(ALLOW_TRIP_EMAIL) {
		UIBarButtonItem *emailButton = [[UIBarButtonItem alloc] initWithTitle:@"Email Trip" 
																	   style:UIBarButtonItemStyleBordered 
																	  target:self 
																	  action:@selector(emailTripButtonTapped)];
		self.navigationItem.leftBarButtonItem = emailButton;
		[emailButton release];
	}
}
-(void) cancelButtonTapped :(id)sender{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    //[self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    [appDelegate loadTabBar:0];
    
}
-(void) addSaveTripButton {
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] 
								   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
								   target:self 
								   action:@selector(saveTripButtonTapped:)]; 
	self.navigationItem.rightBarButtonItem = saveButton; 
	[saveButton release]; 
}
-(void) addCancelButton {
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
								   initWithBarButtonSystemItem:UIBarButtonSystemItemReply
								   target:self
								   action:@selector(cancelButtonTapped:)];
	self.navigationItem.leftBarButtonItem = saveButton;
	[saveButton release];
}


-(void) setUpNavigationBar {
	self.navigationItem.title = @"Add Trip";
	self.navigationItem.hidesBackButton = YES;
	
	DecorateNavBar(self);
	
	//[self addSaveTripButton];
	[self addEmailTripButton];
    [self addCancelButton];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {	
	[journey release];
	[selectedTrip release];
	[tripInfoSection release];
	[saveTripSection release];
	[submitNewTripJourney release];
	
	[emailTripFileHelper release];

    [super dealloc];
}

-(void) setupTable {
	[self addSection:[self tripInfoSection]];
	[self addSection:[self saveTripSection]];
}

-(TripInfoSection *) tripInfoSection {
	
	if(!tripInfoSection) {
		tripInfoSection = [[TripInfoSection alloc] initWithTrip:journey parentViewController:self];
	}
	
	return tripInfoSection;
}

-(SaveTripSection *) saveTripSection {
	if(!saveTripSection) {
		saveTripSection = [[SaveTripSection alloc] initWithoutSetup];
		saveTripSection.parentViewController = self;
		[saveTripSection setupSection];
	}

	return saveTripSection;
}

-(SCTrip *) selectedTrip {
	return selectedTrip;
}

-(void) setSelectedTrip: (SCTrip *) aTrip  {
	[selectedTrip release];
	selectedTrip = [aTrip retain];
	
	if(aTrip != nil) {
		[saveTripSection setNewTripTitle:selectedTrip.name];
	}
}

-(BOOL) validateNameOfTrip {
	NSString * nameOfTrip = [saveTripSection tripTitle];
	
	if(nameOfTrip != nil) {
		nameOfTrip = [nameOfTrip stringByStrippingWhitespace];
	}
	
	if((nameOfTrip == nil) || [nameOfTrip length] == 0) {
		UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Specify Trip Title" message:@"Please either specify a new trip title or select an existing trip. " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		alertView.tag = kTripNameAlertViewTag;
		[alertView show];
		[alertView release];
		return NO;
	} else {
		return YES;
	}
}
 
-(void) deleteLocalTripFiles {
	NSLog(@"Deleting local waypoint files...");
	WayPointsFileHelper *wayPointsFileHelper = [[WayPointsFileHelper alloc] initWithNewFile:NO];
	[wayPointsFileHelper deleteWayPointsFile];
	[wayPointsFileHelper deleteWayPointsZipFile];
	[wayPointsFileHelper release];
	
	NSLog(@"Deleting local interruption files...");
	InterruptionsFileHelper *interruptionsFileHelper = [[InterruptionsFileHelper alloc] initWithNewFile:NO];
	[interruptionsFileHelper deleteInterruptionsFile];
	[interruptionsFileHelper release];
	
	NSLog(@"Deleting school proximity data...");
	TripRepository *tripRepository = [[TripRepository alloc] init];
	[tripRepository clearSchoolProximityData];
	[tripRepository release];
}

-(void) dismissSelf {
	AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
	appDelegate.interruptionsHandler.continueTrackingAction = kContinueTrackingActionNone;
	[appDelegate.interruptionsHandler setTrackingStateOff];
	
	[UserDefaults setValue:@"" forKey:kTripGUID];
	[self deleteLocalTripFiles];	
	
	if (self.delegate && [delegate respondsToSelector:@selector(tripSavingFinished)]) { //Tracking View
		//[self.parentViewController dismissModalViewControllerAnimated:YES];
		[self.delegate tripSavingFinished];
        [appDelegate loadTabBar:0];
	} else {
		[self.parentViewController dismissViewControllerAnimated:YES completion:nil]; //Home Screen
	}
	
    appDelegate.isTripStarted = NO;
    
	[appDelegate startLocationHelper]; //This was stopped when we started the trip
    //[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Actions

-(void) saveTripButtonTapped: (id) sender {
	
	if(![self validateNameOfTrip]) {
		return;
	}
	
	NSString * nameOfTrip = [saveTripSection tripTitle];
	
	if( (self.selectedTrip != nil) && ([nameOfTrip isEqualToString:self.selectedTrip.name])) {
		self.journey.tripName = self.selectedTrip.name;
	} else {
		self.journey.tripName = nameOfTrip;
	}
	
	//[self persistJourney];	
	
	SubmitNewTripJourney * submitDialog = [[SubmitNewTripJourney alloc] init];
	self.submitNewTripJourney = submitDialog;
	[submitDialog release];
	
	submitNewTripJourney.netWorkDelegate = self;
	submitNewTripJourney.tripJourney = self.journey;
	tripSavingSuccess = TripSaveResultInProcess;
	[self showHUD];
	[submitDialog postTrip];
}

-(void) emailTripButtonTapped {
	if([MFMailComposeViewController canSendMail]) {
		MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
		controller.mailComposeDelegate = self;
		[controller setSubject:@"Safecell App: Trip File"];
		[controller setMessageBody:@"Find the file attched." isHTML:NO];
		
		[emailTripFileHelper prepareEmailTripZipFile];
		NSData *tripData = [emailTripFileHelper emailTripZipFileData];
		
		[controller addAttachmentData:tripData mimeType:@"application/zip" fileName:kTripEmailZipFileName];
		
		[self presentViewController:controller animated:YES completion:nil];
		[controller release];	
	}
}

#pragma mark -
#pragma mark NetworkOperationDelegate Methods 

-(void) doneUploadingRequest {
	[progressHUD setLabel:@"  Scoring Trip...  "];
}

-(void) networkOperationSucceeded: (NSString *) responseString {
	SubmitNewTripJourneyResponseHandler *responseHandler = [[SubmitNewTripJourneyResponseHandler alloc] init];
	responseHandler.jsonResponse = responseString;
	[responseHandler process];
	[responseHandler release];
	tripSavingSuccess = TripSaveResultSuccess;
	[self hideHUD];
	[self modalViewDidHide];
}

-(void) networkOperationFailedWithStatusCode: (int) statusCode {
	if (statusCode == 0) {
		tripSavingSuccess = TripSaveResultFailedWithNetwokError;
	} else {
		tripSavingSuccess = TripSaveResultFailedWithAppError;
	}
	[self hideHUD];
	[self modalViewDidHide];
}

#pragma mark -
#pragma mark ModalViewControllerDelegate Methods 

-(void) modalViewDidHide {	
	switch (tripSavingSuccess) {
		case TripSaveResultSuccess:
			[self dismissSelf];
			break;
		case TripSaveResultFailedWithAppError:
		{
			if (ALLOW_DELETE_TRIP) {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Trip Saving Failed" message:@"Trip saving failed because of an unexpected error." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Abandon Trip", nil];
				alertView.tag = kRetrySavingTripAlertViewTag;
				[alertView show];
				[alertView release];
			} else {
				SimpleAlertOK(@"Trip Saving Failed", @"Trip saving failed because of an unexpected error. Please try to save the trip again.");
			}
		}
			break;
		case TripSaveResultFailedWithNetwokError:
		{
			if (ALLOW_DELETE_TRIP) {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Trip Saving Failed" message:@"Trip saving failed because of a network error." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Abandon Trip", nil];
				alertView.tag = kRetrySavingTripAlertViewTag;
				[alertView show];
				[alertView release];
			} else {
				SimpleAlertOK(@"Trip Saving Failed", @"Trip saving failed because of a network error. Please try to save the trip again.");
			}
		}
			break;
	}
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	switch (alertView.tag) {
		case kDeleteTripAlertViewTag:
			[self dismissSelf];
		break;
		case kRetrySavingTripAlertViewTag:
			if (buttonIndex == 1) {
				[self deleteLocalTripFiles];
				[self dismissSelf];
			}

		break;
	}
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller 
		  didFinishWithResult:(MFMailComposeResult)result 
						error:(NSError*)error {
	[emailTripFileHelper deleteEmailTripRelatedFiles];
	[self  dismissViewControllerAnimated:YES completion:nil];
}

@end
