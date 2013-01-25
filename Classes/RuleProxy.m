//
//  RulesProxy.m
//  safecell
//
//  Created by shail m on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RuleProxy.h"
#import "URLUtils.h"
#import "SCAccount.h"
#import "ASIHTTPRequest.h"
#import "JSONHelper.h"
#import "SCRule.h"
#import "FlurryAPI.h"
#import "NSString+Common.h"

@implementation RuleProxy

@synthesize delegate = _delegate;
@synthesize downloadRulesRequest;


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
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = currentLatitude;
	coordinate.longitude = currentLongitude;
	
	if ([[ReverseGeocoder sharedReverseGeocoder] isQuerying]) {
		return;
	}
	
	[[ReverseGeocoder sharedReverseGeocoder] registerAsDeledate:self];
	[[ReverseGeocoder sharedReverseGeocoder] startWithCoordinate:coordinate];
	NSLog(@"-----------------------------> Rule Proxy : Started GC");
}

-(void)startRequestWithGeocodedLocation:(MKPlacemark *)placemark {
	
	NSString *url = [NSString stringWithFormat:@"%@/rules?lat=%f&lng=%f&distance=%d", 
					 [Config baseURL], currentLatitude, currentLongitude, currentRadius];

	if (placemark != nil) {

		/*
		 SAMPLE IPHONE REVERSE GEOCODED ADDRESS DICTIONARY
		 City = Houston;
		 Country = "United States";
		 CountryCode = US;
		 FormattedAddressLines =     (
		 "8627 Plum Lake Dr",
		 "Houston, TX 77095",
		 USA
		 );
		 State = Texas;
		 Street = "8627 Plum Lake Dr";
		 SubAdministrativeArea = Harris;
		 SubThoroughfare = 8627;
		 Thoroughfare = "Plum Lake Dr";
		 ZIP = 77095;
		 
		 */		
		
		url = [url stringByAppendingFormat:@"&city=%@&county=%@&state=%@&country=%@", 
					EmptyIfNull([placemark.addressDictionary objectForKey:@"City"]),
					EmptyIfNull([placemark.addressDictionary objectForKey:@"SubAdministrativeArea"]),
					EmptyIfNull([placemark.addressDictionary objectForKey:@"State"]),
					EmptyIfNull([placemark.addressDictionary objectForKey:@"CountryCode"])
			   ]; 
	}

	url = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	
	self.downloadRulesRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	self.downloadRulesRequest.requestMethod = @"GET";
	
	NSString *apiKey = [SCAccount currentAccountAPIKey];
	
	[self.downloadRulesRequest addRequestHeader:@"x-api-key" value:apiKey];
	[self.downloadRulesRequest addRequestHeader:@"Content-Type" value:@"application/json"];
	
	
	[self.downloadRulesRequest setDelegate:self];
	self.downloadRulesRequest.userInfo = [NSDictionary dictionaryWithObject:@"downloadRules" forKey:@"operation"];	
	
	NSLog(@"GET Rules Data: %@", url);
	NSLog(@"x-api-key: %@", apiKey);
	NSLog(@"Content-Type: application/json");
	
	
	[self.downloadRulesRequest startAsynchronous];
}

-(void) downloadFailed:(ASIHTTPRequest *)request {
	self.downloadRulesRequest = nil;
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(rulesDownloadFailed)]) {
		[self.delegate rulesDownloadFailed];
	}
}

#pragma mark -
#pragma mark Public Methods

-(void) stopRulesDownload {
	if (self.downloadRulesRequest != nil) {
		downloadRulesRequest.delegate = nil;
		[downloadRulesRequest cancel];
		self.downloadRulesRequest = nil;
	}
}

-(void) downloadRulesForLatitude: (float) latitude longidute: (float) longitude distance: (int) radius {
	
	if (self.downloadRulesRequest != nil) {
		return;
	}
	
	if (failureTracker != nil) {
		[failureTracker release];
		failureTracker = nil;
	}
	
	currentLongitude = longitude;
	currentLatitude = latitude;
	currentRadius = radius;
	
	[self configureFailureTracker];
	[failureTracker start];
}

- (void) dealloc {
	[[ReverseGeocoder sharedReverseGeocoder] unregisterAsDelegate:self];
	[downloadRulesRequest release];
	[super dealloc];
}


#pragma mark -
#pragma mark Response Handler

-(void) handleDownloadRulesResponse:(NSString *) responseString {
	NSArray * responseArray = [JSONHelper arrayFromString:responseString];
			   
	NSMutableArray *rules = [[[NSMutableArray alloc] initWithCapacity:[responseArray count]] autorelease];
	
	for (NSDictionary * ruleDict in responseArray) {
		NSDictionary *dataDict = [ruleDict objectForKey:@"rule"];
		
		NSLog(@"dataDict: %@", dataDict);
		
		SCRule *rule = [SCRule ruleWithDictionary:dataDict];
		
		[rules addObject:rule];
	}
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(rulesDownloadFinished:)]) {
		[self.delegate rulesDownloadFinished:rules];
	}
}

#pragma mark -
#pragma mark ASIHTTPRequestDelegate

-(void) requestFinished:(ASIHTTPRequest *)request {
	NSLog(@"Retrieved %d bytes from the request for %@", [[request responseData] length], request.url);
	NSLog(@"%@", [request responseString]);
	
	NSString *operation = [[request userInfo] objectForKey:@"operation"];
	
	if(request.responseStatusCode == 200) {
		
		if([operation isEqualToString:@"downloadRules"]) {
			[self handleDownloadRulesResponse:[request responseString]];
		}
		
	} else {
		[self requestFailed:request];	
	}
	
	self.downloadRulesRequest = nil;
}

-(void) requestFailed:(ASIHTTPRequest *)request {	
	NSLog(@"REQUEST FAILED: %@", request.url);
	NSLog(@"Response Status: %d", request.responseStatusCode);
	NSLog(@"OPERATION: %@", [[request userInfo] objectForKey:@"operation"]);
	NSError *error = [request error];
	if (error) {
		NSLog(@"ERROR: %@", [request.error localizedDescription]);
	}
	
	self.downloadRulesRequest = nil;

	if (failureTracker) {
		[failureTracker failedForOnce:request];
	}
}

#pragma mark -
#pragma mark ReverseGeocoderDelegate methods

- (void)reverseGeocoder:(ReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	[[ReverseGeocoder sharedReverseGeocoder] unregisterAsDelegate:self];
	NSLog(@"-----------------------------> Rule Proxy : Successfully Reverse Geocoded");
	[self startRequestWithGeocodedLocation:placemark];
}

// There are at least two types of errors:
//   - Errors sent up from the underlying connection (temporary condition)
//   - Result not found errors (permanent condition).  The result not found errors
//     will have the domain MKErrorDomain and the code MKErrorPlacemarkNotFound
- (void)reverseGeocoder:(ReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	[[ReverseGeocoder sharedReverseGeocoder] unregisterAsDelegate:self];
	NSLog(@"-----------------------------> Rule Proxy : failed to Reverse Geocode");
	
	[FlurryAPI logEvent:@"Failed to reverse geocode" withParameters:
	 [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithFloat:geocoder.coordinate.latitude], @"latitude",
		[NSNumber numberWithFloat:geocoder.coordinate.longitude], @"longitude", nil]]; 
		 
	[self startRequestWithGeocodedLocation:nil];
	[geocoder release];
}


@end
