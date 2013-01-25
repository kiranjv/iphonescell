//
//  POSProxy.h
//  safecell
//
//  Created by Mobisoft Infotech on 9/16/10.
//  Copyright 2010 Mobisoft Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "NetworkCallFailureTracker.h"

@protocol TOSProxyDelegate;

@interface TOSProxy : NSObject {
	NSObject<TOSProxyDelegate> *delegate;
	ASIHTTPRequest *TOSRequest;
	
	
	NetworkCallFailureTracker *failureTracker;
}

@property (nonatomic, assign) NSObject<TOSProxyDelegate> * delegate;
@property (nonatomic, retain) ASIHTTPRequest *TOSRequest;

-(void) downloadTOS;

@end

@protocol TOSProxyDelegate 

@optional

-(void) tosDownloadFinished: (NSString *) tosHTML;
-(void) tosDownloadFailedWithNetworkError: (BOOL) networkError;

@end
