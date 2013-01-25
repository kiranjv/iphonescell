//
//  ReachabilityDelegate.h
//  safecell
//
//  Created by Mobisoft Infotech on 8/4/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface ReachabilityChecker : NSObject<UIAlertViewDelegate> {
	Reachability* hostReach;
	
	NetworkStatus netStatus;
}

@property(nonatomic, readonly) NetworkStatus netStatus;

-(void) showNoNetworkMessageForApp: (NSString *) appName;

@end
