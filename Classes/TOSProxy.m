//
//  POSProxy.m
//  safecell
//
//  Created by Mobisoft Infotech on 9/16/10.
//  Copyright 2010 Mobisoft Infotech. All rights reserved.
//

#import "TOSProxy.h"
#import "JSONHelper.h"


@implementation TOSProxy

@synthesize TOSRequest, delegate;


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
	NSString *url = [NSString stringWithFormat:@"%@/site_settings", [Config baseURL]];
	
	self.TOSRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	self.TOSRequest.requestMethod = @"GET";
	
	[self.TOSRequest addRequestHeader:@"Content-Type" value:@"application/json"];
	
	
	[self.TOSRequest setDelegate:self];
	
	self.TOSRequest.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
										 @"downloadTOS", @"operation", nil];	
	
	NSLog(@"GET License Data: %@", url);
	
	NSLog(@"Content-Type: application/json");
	
	
	[self.TOSRequest startAsynchronous];
}

-(void) downloadFailed:(ASIHTTPRequest *)request {
	if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(tosDownloadFailedWithNetworkError:)]) {
		
		if (request.responseStatusCode == 0) {
			[self.delegate tosDownloadFailedWithNetworkError: YES];
		} else {
			[self.delegate tosDownloadFailedWithNetworkError: NO];
		}
	}
}

-(void) downloadTOS {
	if(failureTracker) {
		[failureTracker release];
		failureTracker = nil;
		
		self.TOSRequest.delegate = nil;
		[self.TOSRequest cancel];
		self.TOSRequest = nil;
	}
	
	[self configureFailureTracker];
	[failureTracker start];
}

#pragma mark -
#pragma mark Clean Up

- (void) dealloc {
	self.TOSRequest = nil;
	[failureTracker release];
	[super dealloc];
}

#pragma mark -
#pragma mark Response Handler 

-(void) handleResponse: (NSString *) responseString {
	NSArray * responseArray = [JSONHelper arrayFromString:responseString];
	
	NSDictionary *tosDict = [responseArray objectAtIndex:0];
	
	NSString *tosHTML = [tosDict objectForKey:@"value"];
	
	if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(tosDownloadFinished:)]) {
		[self.delegate tosDownloadFinished:tosHTML];
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
	
	self.TOSRequest = nil;	
}

@end
