#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "NetworkOperationDelegate.h"
#import "ModalViewController.h"
#import "NetworkCallFailureTracker.h"

#define kInvaidResponseStatusMessage @"Invalid Response Status"

@class SCTripJourney;
@class ASIFormDataRequest;

@interface SubmitNewTripJourney : NSObject <ASIHTTPRequestDelegate, ASIProgressDelegate> {
	
	SCTripJourney *tripJourney;
	NSObject<NetworkOperationDelegate> *netWorkDelegate;
	
	NetworkCallFailureTracker *failureTracker;
	
	int uploadSize;
	
	int uploadedDataSize;
	int receivedDataSize;
	
	BOOL uploadDone;
}

@property(nonatomic, retain) SCTripJourney *tripJourney;
@property(nonatomic, assign) NSObject<NetworkOperationDelegate> *netWorkDelegate;


-(void) startAsynchronous;

-(NSString *) buildURL;
-(void) postTrip;



@end
