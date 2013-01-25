//
//  WayPointsStore.h
//  safecell
//
//  Created by shail on 07/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCWaypoint;

@interface WayPointsStore : NSObject {
	int capacity;
	NSMutableArray *dataStore;
    BOOL isTripStarted;
}

@property (nonatomic,assign)  BOOL isTripStarted;
- initWithCapacity: (int) maxSize;
-(void) pushWayPoint: (SCWaypoint *) wayPoint;
-(float) averageSpeed;

@end
