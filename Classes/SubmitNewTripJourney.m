//
//  SubmitNewTripJourney.m
//  safecell
//
//  Created by shail on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SubmitNewTripJourney.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "SCTripJourney.h"
#import "SCProfile.h"
#import "FileUtils.h"
#import "FlurryAPI.h"
#import "ServerDateFormatHelper.h"

@implementation SubmitNewTripJourney

@synthesize tripJourney;
@synthesize netWorkDelegate;


-(void) configureFailureTracker {
	if (failureTracker) {
		[failureTracker release];
		failureTracker = nil;
	}
	failureTracker = [[NetworkCallFailureTracker alloc] initWithRetriesAllowed:3];
	[failureTracker trackResponseCodesWithTotalCount:1, 0];
	[failureTracker addTarget:self startRequestSelector:@selector(startAsynchronous) requestFinallyFailedSelector:@selector(requestFailedAfterRetries:)];
}

- (id) init {
	self = [super init];
	if (self != nil) {
		uploadedDataSize = 0;
		receivedDataSize = 0;
		
		uploadDone = NO;
	}
	return self;
}


-(void) startAsynchronous {
	
	NSURL *url = [NSURL URLWithString:[self buildURL]];
	ASIFormDataRequest *formDataRequest = [ASIFormDataRequest requestWithURL:url];
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[formDataRequest addRequestHeader:@"x-api-key" value:appDelegate.currentProfile.apiKey];
	[formDataRequest addRequestHeader:@"Content-Type" value:@"application/json"];
	// [formDataRequest addRequestHeader:@"Content-Encoding" value:@"gzip"];
	[formDataRequest setTimeOutSeconds:60];
	formDataRequest.shouldCompressRequestBody = YES;
	
	NSLog(@"url: %@", url);
	NSLog(@"x-api-key: %@", appDelegate.currentProfile.apiKey);
	NSLog(@"Content-Type: application/json");
	// NSLog(@"json = %@", [tripJourney JSONRepresentation]);
	NSLog(@"waypoint count: %d", [tripJourney.waypoints count]);
	NSLog(@"Request TimeOut: %f", formDataRequest.timeOutSeconds);
	
	NSData *tripData = [[tripJourney JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
	uploadSize = [tripData length];
	NSLog(@"uplaod size: %d", (uploadSize / 1024));
	NSLog(@"trip data: %@", [tripJourney JSONRepresentation]);
	[formDataRequest appendPostData:tripData];
	//formDataRequest.showAccurateProgress = YES;
	[formDataRequest setUploadProgressDelegate:self];
	[formDataRequest setDownloadProgressDelegate:self];
	[formDataRequest setDelegate:self];
	[formDataRequest startAsynchronous];	
}

-(NSString *) buildURL {
    
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];	
	NSString * url = [NSString stringWithFormat:@"%@/trips?account_id=%d&profile_id=%d", 
					  [Config baseURL], appDelegate.currentProfile.accountId, appDelegate.currentProfile.profileId];
	
		
	return url;
}

-(void) postTrip {
	[self configureFailureTracker];
	[failureTracker start];
}

-(void) requestFailedAfterRetries: (ASIHTTPRequest *) request {
	if(netWorkDelegate && [netWorkDelegate respondsToSelector:@selector(networkOperationFailedWithStatusCode:)]) {
		[netWorkDelegate networkOperationFailedWithStatusCode:[request responseStatusCode]];
	}
}


#pragma mark -
#pragma mark Clean Up

- (void) dealloc {	
	[failureTracker release];
	[tripJourney release];
	[super dealloc];
}

#pragma mark -
#pragma mark Upload Progress Delegate

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes {
	if (!uploadDone) {
		if(netWorkDelegate && [netWorkDelegate respondsToSelector:@selector(doneUploadingRequest)]) {
			[netWorkDelegate doneUploadingRequest];
			uploadDone = YES;
		}
	}
	
	receivedDataSize += bytes;

}

- (void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes {
	
	if (uploadDone) {
		return;
	}
	
	if (bytes < 0) {
		uploadedDataSize = 0;
	}
	
	uploadedDataSize += bytes;
	
	if (uploadedDataSize == uploadSize) {
		if(netWorkDelegate && [netWorkDelegate respondsToSelector:@selector(doneUploadingRequest)]) {
			[netWorkDelegate doneUploadingRequest];
			uploadDone = YES;
		}
	}
}

-(void) logTripSaveFailureToFlurry: (int) statusCode {
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];	
	NSNumber *accountId = [NSNumber numberWithInt:appDelegate.currentProfile.accountId];
	NSNumber *profileId = [NSNumber numberWithInt: appDelegate.currentProfile.profileId];
	NSString *name = [NSString stringWithFormat:@"%@ %@", appDelegate.currentProfile.firstName, appDelegate.currentProfile.lastName];
	NSDate *now = [NSDate date];
	NSString *utcDate = [ServerDateFormatHelper formattedDateForJSON:now];
	
	NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
								accountId, @"accountId",
								profileId, @"profileId",
								name, @"name",
								utcDate, @"timestamp", nil
								];
	
	switch (statusCode) {
		case 500:
			[FlurryAPI logEvent:@"Trip Save Failed : 500 Internal Server error" withParameters:parameters];
			break;
		case 502:
			[FlurryAPI logEvent:@"Trip Save Failed : 502 App Failed To Respond" withParameters:parameters];
			break;
		case 504:
			[FlurryAPI logEvent:@"Trip Save Failed : 504 Backlog Too Deep" withParameters:parameters];
		case 422:
			[FlurryAPI logEvent:@"Trip Save Failed : 422 Maintenance Mode" withParameters:parameters];
		case 503:
			[FlurryAPI logEvent:@"Trip Save Failed : 503 Heroku Ouchie Page" withParameters:parameters];
			break;
		default:
			[FlurryAPI logEvent:[NSString stringWithFormat:@"Trip Save Failed : %d Unexpected Error", statusCode] withParameters:parameters];
			break;
	}
	
	NSLog(@"Logged Trip Save Failure to Flurry");
}
-(void)dismissAlertView:(UIAlertView *)alertView{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
#pragma mark -
#pragma mark ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request {	
	
    UIAlertView *alertView = nil;
    
	NSString *response = [request responseString];	
	NSLog(@"Response: %@", response);
	
	if(request.responseStatusCode != 200) {
		[self requestFailed:request];
	} else {
		if(netWorkDelegate && [netWorkDelegate respondsToSelector:@selector(networkOperationSucceeded:)]) {
			[netWorkDelegate networkOperationSucceeded:response];
            alertView = [[UIAlertView alloc] initWithTitle:@"The trip  is saved"
                                                   message:@"The trip saved successfully."
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:nil];
			
            [alertView show];
            [alertView release];

		}
        [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:5];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSLog(@"Response Code: %d", request.responseStatusCode);
	[self logTripSaveFailureToFlurry:request.responseStatusCode];
	
	NSError *error = [request error];
	if (error) {
		NSLog(@"Failed: %@", [error localizedDescription]);
	}
	[failureTracker failedForOnce:request];
}

@end
