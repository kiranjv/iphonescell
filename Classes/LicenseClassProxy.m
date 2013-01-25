//
//  LicenseClassProxy.m
//  safecell
//
//  Created by Mobisoft Infotech on 8/23/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "LicenseClassProxy.h"
#import "SCLicenseClass.h"
#import "JSONHelper.h"


@implementation LicenseClassProxy

@synthesize delegate;
@synthesize licenseClassRequest;


-(void) configureFailureTracker {
	if (failureTracker) {
		[failureTracker release];
		failureTracker = nil;
	}
	failureTracker = [[NetworkCallFailureTracker alloc] initWithRetriesAllowed:3];
	[failureTracker trackResponseCodesWithTotalCount:1, 0];
	[failureTracker addTarget:self startRequestSelector:@selector(startRequest) requestFinallyFailedSelector:@selector(downloadFailed:)];
}

-(void) startRequest {
	NSString *url = [NSString stringWithFormat:@"%@/license_classes", [Config baseURL]];
	
	self.licenseClassRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	self.licenseClassRequest.requestMethod = @"GET";
	
	[self.licenseClassRequest addRequestHeader:@"Content-Type" value:@"application/json"];
	
	
	[self.licenseClassRequest setDelegate:self];
	
	self.licenseClassRequest.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
											@"downloadLicenseClasses", @"operation", nil];	
	
	NSLog(@"GET License Data: %@", url);
	
	NSLog(@"Content-Type: application/json");
	
	
	[self.licenseClassRequest startAsynchronous];
}

-(void) downloadFailed:(ASIHTTPRequest *)request {
	if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(licenseClassesDownloadFailedWithNetworkError:)]) {
		
		
        if (request.responseStatusCode == 0) {
			[self.delegate licenseClassesDownloadFailedWithNetworkError: YES];
		} else {
			[self.delegate licenseClassesDownloadFailedWithNetworkError: NO];
		}
	}
}

-(void) downloadLicenseClasses {
	if(failureTracker) {
		[failureTracker release];
		failureTracker = nil;
		
		self.licenseClassRequest.delegate = nil;
		[self.licenseClassRequest cancel];
		self.licenseClassRequest = nil;
	}
	
	[self configureFailureTracker];
	[failureTracker start];
}

#pragma mark -
#pragma mark Clean Up

- (void) dealloc {
	self.licenseClassRequest = nil;
	[super dealloc];
}

#pragma mark -
#pragma mark Response Handler 

-(void) handleResponse: (NSString *) responseString {
	NSArray * responseArray = [JSONHelper arrayFromString:responseString];
	
	NSMutableArray *licenseClasses = [[[NSMutableArray alloc] initWithCapacity:[responseArray count]] autorelease];
    
	
	for (NSDictionary * dict in responseArray) {
		SCLicenseClass *licenseClass = [SCLicenseClass licenseClassFromDictionary:dict];
		[licenseClasses addObject:licenseClass];
	}
	
	if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(licenseClassesDownloadFinished:)]) {
		[self.delegate licenseClassesDownloadFinished:licenseClasses];
	}
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate

-(void) requestFailed:(ASIHTTPRequest *)request {
	NSLog(@"REQUEST FAILED: %@", request.url);
	NSLog(@"OPERATION: %@", [[request userInfo] objectForKey:@"operation"]);
	NSError *error = [request error];
	if (error) {
		NSLog(@"ERROR: %@", [request.error localizedDescription]);
	}
	
	if (failureTracker) {
		[failureTracker failedForOnce:request];
	}
}

-(void) requestFinished:(ASIHTTPRequest *)request {
	NSLog(@"Retrieved %d bytes from the request for %@", [[request responseData] length], request.url);
	NSLog(@"Response: %@", [request responseString]);
	
	if(request.responseStatusCode == 200) {
		[self handleResponse:[request responseString]];
	} else {
		[self requestFailed:request];	
	}
	
	self.licenseClassRequest = nil;
	
}

@end
