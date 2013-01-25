//
//  WayPointsFileHelper.h
//  safecell
//
//  Created by shail on 07/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kWayPointFileName @"waypoints.json"
#define kWayPointZipFileName @"waypoints.zip"

@class SCWaypoint;
@class WayPointsReader;

@interface WayPointsFileHelper : NSObject {
	NSFileHandle * fileHandle;
	WayPointsReader * wayPointsReader;
}

- (id) initWithNewFile: (BOOL) createNew;

+(NSString *) wayPointsFilePath;
+(BOOL) wayPointsFileExists;

+(NSString *) wayPointsZipFilePath;
+(BOOL) wayPointsZipFileExists;

-(void) createWayPointsFile;
-(void) closeWayPointFile;

-(void) writeWayPoint: (SCWaypoint *) wayPoint;
-(void) writePoint: (SCWaypoint *) wayPoint ;
-(SCWaypoint *) readNextWayPoint;

-(NSString *) wayPointFileContents;

-(BOOL) archiveWayPointsFile;
-(NSData *) wayPointsZipFileData;

-(void) deleteWayPointsFile;
-(void) deleteWayPointsZipFile;

-(int) countWaypointsInFile;

@end
