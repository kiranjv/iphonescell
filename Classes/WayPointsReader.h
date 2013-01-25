//
//  WayPointsReader.h
//  safecell
//
//  Created by shail on 12/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCWaypoint;

@interface WayPointsReader : NSObject {
	NSFileHandle * fileHandle;
}

- (id) initWithFileHandle: (NSFileHandle *) wayPointFileHandle;
-(SCWaypoint *) readNextWayPoint;

@end
