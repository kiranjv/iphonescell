//
//  TripProxy.h
//  safecell
//
//  Created by Mobisoft Infotech on 7/19/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkCallFailureTracker.h"

@protocol TripProxyDelegate;

@interface TripProxy : NSObject<ASIHTTPRequestDelegate> {
	NetworkCallFailureTracker *getTripsFailureTracker;
	NSObject<TripProxyDelegate> *delegate;
}

@property (nonatomic, assign) NSObject<TripProxyDelegate> *delegate;

-(void) getTripsForProfile: (int) profileId apiKey:(NSString *) apiKey;

@end

@protocol TripProxyDelegate

@optional
-(void) receivedTrips: (NSArray *) trips;

@required
-(void) requestFailed: (ASIHTTPRequest *) request;

@end

