//
//  WayPointsFileHelper.m
//  safecell
//
//  Created by shail on 07/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WayPointsFileHelper.h"
#import "SCWaypoint.h"
#import "SBJSON.h"
#import "ZipArchive.h"
#import "WayPointsReader.h"

@implementation WayPointsFileHelper

- (id) initWithNewFile: (BOOL) createNew
{
	self = [super init];
	if (self != nil) {
		
		if(createNew) {
			[self createWayPointsFile];
		}
		
		NSString * wayPointFilePath = [WayPointsFileHelper wayPointsFilePath];
		NSLog(@"wayPointFilePath: %@", wayPointFilePath);
		fileHandle = [[NSFileHandle fileHandleForUpdatingAtPath:wayPointFilePath] retain];
		wayPointsReader = [[WayPointsReader alloc] initWithFileHandle:fileHandle];
	}
	return self;
}

+(NSString *) wayPointsFilePath {
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString * wayPointFilePath = [documentsDirectory stringByAppendingPathComponent:kWayPointFileName];
	return wayPointFilePath;
}

+(BOOL) wayPointsFileExists {
	NSFileManager *fileManager = [NSFileManager defaultManager];	
	NSString * wayPointFilePath = [WayPointsFileHelper wayPointsFilePath];	
	
	if([fileManager fileExistsAtPath:wayPointFilePath]) {
		return YES;
	} else {
		return NO;
	}
}

+(NSString *) wayPointsZipFilePath {
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString * wayPointZipFilePath = [documentsDirectory stringByAppendingPathComponent:kWayPointZipFileName];
	return wayPointZipFilePath;
}

+(BOOL) wayPointsZipFileExists {
	NSFileManager *fileManager = [NSFileManager defaultManager];	
	NSString * wayPointZipFilePath = [WayPointsFileHelper wayPointsZipFilePath];	
	
	if([fileManager fileExistsAtPath:wayPointZipFilePath]) {
		return YES;
	} else {
		return NO;
	}
}

-(void) createWayPointsFile {	
	NSFileManager *fileManager = [NSFileManager defaultManager];	
	NSString * wayPointFilePath = [WayPointsFileHelper wayPointsFilePath];
	if([WayPointsFileHelper wayPointsFileExists]) {
		BOOL deleted = [fileManager removeItemAtPath:wayPointFilePath error:NULL];
		assert(deleted == YES);
	}
	
	[fileManager createFileAtPath:wayPointFilePath contents:[@"" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];	
}

-(void) closeWayPointFile {
	[fileHandle closeFile];
}
-(void) writePoint: (SCWaypoint *) wayPoint {
    @try {
		[fileHandle seekToEndOfFile];
	} @catch(NSException* exception) {
		NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
	}
	
	unsigned long long seekPoint = [fileHandle offsetInFile];
    NSLog (@"Offset = %llu", [fileHandle offsetInFile]);
	
	if(seekPoint > 0) {
		[fileHandle writeData:[@"," dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	NSString *json = [wayPoint JSONRepresentation];
    
	[fileHandle writeData:[json dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void) writeWayPoint: (SCWaypoint *) wayPoint {
	@try {
		[fileHandle seekToEndOfFile];
	} @catch(NSException* exception) {
		NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
	}
	
	unsigned long long seekPoint = [fileHandle offsetInFile];
    NSLog (@"Offset = %llu", [fileHandle offsetInFile]);
	
	if(seekPoint > 0) {
		[fileHandle writeData:[@"," dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	NSString *json = [wayPoint JSONRepresentation];
    NSLog(@"Way point JSONRepresentation = %@",json);
	[fileHandle writeData:[json dataUsingEncoding:NSUTF8StringEncoding]];
}

-(SCWaypoint *) readNextWayPoint {
	return [wayPointsReader readNextWayPoint];
}

-(NSString *) wayPointFileContents {
	NSString *wayPointFilePath = [WayPointsFileHelper wayPointsFilePath];
	NSString *wayPointsFileContents = [NSString stringWithContentsOfFile:wayPointFilePath 
																encoding:NSUTF8StringEncoding 
																   error:nil];
	return wayPointsFileContents;
}

- (void) dealloc
{
	[self closeWayPointFile];
	[fileHandle release];
	[wayPointsReader release];
	[super dealloc];
}

-(BOOL) archiveWayPointsFile {	
	
	[self deleteWayPointsZipFile];
	
	NSString *wayPointZipFilePath = [WayPointsFileHelper wayPointsZipFilePath];
	
	ZipArchive* za = [[ZipArchive alloc] init];
	[za CreateZipFile2:wayPointZipFilePath];
	NSString *waypointsFilePath = [WayPointsFileHelper wayPointsFilePath]; 
	
	[za addFileToZip:waypointsFilePath newname:kWayPointFileName];
	
	BOOL result = YES;
	if( ![za CloseZipFile2] )
	{
		result = NO;
	}
	[za release];
	
	return result;
}

-(NSData *) wayPointsZipFileData {
	NSString *wayPointZipFilePath = [WayPointsFileHelper wayPointsZipFilePath];
	
	if([WayPointsFileHelper wayPointsZipFileExists]) {
		
		NSFileHandle *zipFileHandle = [NSFileHandle fileHandleForReadingAtPath:	wayPointZipFilePath];
		NSData * zipFileData = [zipFileHandle readDataToEndOfFile];
		return zipFileData;
	} else {
		return nil;
	}
	
}

-(void) deleteWayPointsFile {
	if([WayPointsFileHelper wayPointsFileExists]) {
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString * wayPointFilePath = [WayPointsFileHelper wayPointsFilePath];	
		[fileManager removeItemAtPath:wayPointFilePath error:NULL];
	}
}

-(void) deleteWayPointsZipFile {
	if([WayPointsFileHelper wayPointsZipFileExists]) {
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *wayPointZipFilePath = [WayPointsFileHelper wayPointsZipFilePath];
		[fileManager removeItemAtPath:wayPointZipFilePath error:NULL];
	}
}

-(int) countWaypointsInFile {
	[fileHandle seekToFileOffset:0];
	
	int count = 0;
	SCWaypoint *waypoint = nil;
	
	while ((waypoint = [self readNextWayPoint]) != nil) {
		++count;
	}
	
	NSLog(@"Count: %d", count);
	
	return count;
}



@end
