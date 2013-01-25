//
//  SchoolProxy.m
//  safecell
//
//  Created by shail m on 6/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SchoolProxy.h"
#import "ASIHTTPRequest.h"
#import "JSONHelper.h"
#import "SCSchool.h"

@implementation SchoolProxy

@synthesize delegate = _delegate;
@synthesize downloadSchoolsRequest;
@synthesize currentWaypoint;


-(void) stopSchoolsDownload {
	if (self.downloadSchoolsRequest != nil) {
		downloadSchoolsRequest.delegate = nil;
		[self.downloadSchoolsRequest cancel];
		self.downloadSchoolsRequest = nil;
	}
	
}

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
	NSString *url = [NSString stringWithFormat:@"%@/schools?lat=%f&lng=%f&distance=%f", 
					 [Config baseURL], self.currentWaypoint.latitude, self.currentWaypoint.longitude, currentRadius];
	
	self.downloadSchoolsRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	self.downloadSchoolsRequest.requestMethod = @"GET";
	
	NSString *apiKey = [SCAccount currentAccountAPIKey];
	
	[self.downloadSchoolsRequest addRequestHeader:@"x-api-key" value:apiKey];
	[self.downloadSchoolsRequest addRequestHeader:@"Content-Type" value:@"application/json"];
	
	
	[self.downloadSchoolsRequest setDelegate:self];
	
	self.downloadSchoolsRequest.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
											@"downloadSchools", @"operation", 
											self.currentWaypoint, @"waypoint", nil];	
	
	NSLog(@"GET Schools Data: %@", url);
	NSLog(@"x-api-key: %@", apiKey);
	NSLog(@"Content-Type: application/json");

	
	[self.downloadSchoolsRequest startAsynchronous];
}

-(void) downloadFailed:(ASIHTTPRequest *)request {
	self.downloadSchoolsRequest = nil;
}

-(void) downloadSchoolsForWaypoint: (SCWaypoint *) waypoint distance: (float) radius {
	
	if (self.downloadSchoolsRequest != nil) {
		[failureTracker release];
		failureTracker = nil;
		
		[self.downloadSchoolsRequest cancel];
		self.downloadSchoolsRequest = nil;
		
		NSLog(@"Cancelled Previous Schools Download");
	}
	
	
	self.currentWaypoint = waypoint;
	currentRadius = radius;
	
	[self configureFailureTracker];
	[failureTracker start];
}

- (void) dealloc {
	[currentWaypoint release];
	[downloadSchoolsRequest release];
	[super dealloc];
}


#pragma mark -
#pragma mark Response Handler

-(void) handleDownloadSchoolsResponse:(NSString *) responseString forWaypoint: (SCWaypoint *) waypoint {
	NSArray * responseArray = [JSONHelper arrayFromString:responseString];
	
	NSMutableArray *schools = [[[NSMutableArray alloc] initWithCapacity:[responseArray count]] autorelease];
	
	for (NSDictionary * schoolDict in responseArray) {
		NSDictionary *dataDict = [schoolDict objectForKey:@"school"];
		
		SCSchool *school = [SCSchool schoolWithDictionary:dataDict];
		
		[schools addObject:school];
	}
		
	if(self.delegate && [self.delegate respondsToSelector:@selector(schoolsDownloadFinished:forWaypoint:)]) {
		[self.delegate schoolsDownloadFinished:schools forWaypoint: waypoint];
	}
}



#pragma mark -
#pragma mark ASIHTTPRequestDelegate

-(void) requestFinished:(ASIHTTPRequest *)request {
	NSLog(@"Retrieved %d bytes from the request for %@", [[request responseData] length], request.url);
	NSLog(@"%@", [request responseString]);
	
	NSDictionary *userInfo = [request userInfo];
	NSString *operation = [userInfo objectForKey:@"operation"];
	
	if(request.responseStatusCode == 200) {
		
		if([operation isEqualToString:@"downloadSchools"]) {
			SCWaypoint *waypoint = [userInfo objectForKey:@"waypoint"];
			
			[self handleDownloadSchoolsResponse:[request responseString] forWaypoint:waypoint];
		}
		
	} else {
		[self requestFailed:request];	
	}
	
	self.downloadSchoolsRequest = nil;
}

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


@end
