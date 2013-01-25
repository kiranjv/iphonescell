//
//  RulesProxy.h
//  safecell
//
//  Created by shail m on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "NetworkCallFailureTracker.h"
#import "ReverseGeocoder.h"

@protocol RuleProxyDelegate;

@interface RuleProxy : NSObject<ASIHTTPRequestDelegate, ReverseGeocoderDelegate> {
	NSObject<RuleProxyDelegate> *_delegate;
	ASIHTTPRequest *downloadRulesRequest;
	
	NetworkCallFailureTracker *failureTracker;
	
	float currentLongitude;
	float currentLatitude;
	int currentRadius;
}

@property (nonatomic, assign) NSObject<RuleProxyDelegate> * delegate;
@property (nonatomic, retain)  ASIHTTPRequest *downloadRulesRequest;

-(void) downloadRulesForLatitude: (float) latitude longidute: (float) longitude distance: (int) radius;
-(void) stopRulesDownload;

@end


@protocol RuleProxyDelegate 

@optional

-(void) rulesDownloadFinished: (NSArray *) rules;
-(void) rulesDownloadFailed;

@end