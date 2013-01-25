//
//  LicenseClassProxy.h
//  safecell
//
//  Created by Mobisoft Infotech on 8/23/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "NetworkCallFailureTracker.h"

@protocol LicenseClassProxyDelegate;


@interface LicenseClassProxy : NSObject {
	NSObject<LicenseClassProxyDelegate> *delegate;
	ASIHTTPRequest *licenseClassRequest;
	
	
	NetworkCallFailureTracker *failureTracker;
}

@property (nonatomic, assign) NSObject<LicenseClassProxyDelegate> * delegate;
@property (nonatomic, retain) ASIHTTPRequest *licenseClassRequest;


-(void) downloadLicenseClasses;

@end

@protocol LicenseClassProxyDelegate 

@optional

-(void) licenseClassesDownloadFinished: (NSArray *) licenses;
-(void) licenseClassesDownloadFailedWithNetworkError: (BOOL) networkError;

@end
