//
//  WaypointsFilesSection.m
//  safecell
//
//  Created by shail on 14/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WaypointsFilesSection.h"
#import "WayPointFileCellController.h"
#import "SelectWaypointsFileViewController.h"
#import "AppDelegate.h"
#import "FakeLocationManagerSettingsRepository.h"

@implementation WaypointsFilesSection

@synthesize selectedFile;

- (id) init {
	self = [super init];
	if (self != nil) {
		[self populateWaypointFiles];
		[self setupSection];
	}
	return self;
}

-(void) populateWaypointFiles {
	NSString *strResourcePath = [[NSBundle mainBundle] resourcePath];	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSArray *dirContents = [fileManager contentsOfDirectoryAtPath:strResourcePath error:nil];
	
	fileNames = [[NSMutableArray alloc] init];
	
	for(NSString *fileName in dirContents) {
		if([fileName hasSuffix:kWayPointFileExtension]) {
			[fileNames addObject:fileName];
		}
	}
	
	FakeLocationManagerSettingsRepository *settingsRepository = [[FakeLocationManagerSettingsRepository alloc] init];
	NSString *recordedWayPointsFile = [settingsRepository lastUsedDataFile];
	[settingsRepository release];
	
	if( (recordedWayPointsFile != nil) && ([recordedWayPointsFile length] > 0) ) {
		self.selectedFile = recordedWayPointsFile;
	} else {
		self.selectedFile = [fileNames objectAtIndex:0];
	}
}

-(void)setupSection {
	[self addFileRows];
}

-(void) addFileRows {
	for(NSString * fileName in fileNames) {
		WayPointFileCellController *cellController = [[WayPointFileCellController alloc] initWithParentSection:self withFileName:fileName];
		[self.rows addObject:cellController];
		[cellController release];
	}
}

- (void) dealloc {	
	[selectedFile release];
	[fileNames release];
	[super dealloc];
}



@end
