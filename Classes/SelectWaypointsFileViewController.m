//
//  SelectWayPoitnsFileViewController.m
//  safecell
//
//  Created by shail on 14/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SelectWaypointsFileViewController.h"
#import "WaypointsFilesSection.h"

@implementation SelectWaypointsFileViewController

@synthesize delegate;

-(id)initWithStyle:(UITableViewStyle)style {
	self = [super initWithStyle:style];
	if (self != nil) {		
		[self setupTable];
		[self setUpNavigationBar];
	}
	return self;
}

-(void) setupTable {
	[self addSection:[self waypointsFilesSection]];
}

-(void) setUpNavigationBar {
	self.navigationItem.title = @"Select Recorded Trip";
	self.navigationItem.hidesBackButton = YES;
	
	UIBarButtonItem *selectButton = [[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleBordered target:self action:@selector(didSelectFile:)]; 
	self.navigationItem.rightBarButtonItem = selectButton; 
	[selectButton release]; 
}

-(WaypointsFilesSection *) waypointsFilesSection {
	if(!waypointsFilesSection) {
		waypointsFilesSection = [[WaypointsFilesSection alloc] init];
		waypointsFilesSection.parentViewController = self;
	}
	
	return waypointsFilesSection;
}

-(void) didSelectFile: (id) sender {
	
	if(!waypointsFilesSection.selectedFile) {
		UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Select WayPoints File" message:@"Please select a prerecorded waypoints file to replay." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
	}
	
	if(delegate && [delegate respondsToSelector:@selector(didFinishSelectingWayPointsFile:)]) {
		[delegate didFinishSelectingWayPointsFile:waypointsFilesSection.selectedFile];
	}
}


- (void)dealloc {
	[waypointsFilesSection release];
    [super dealloc];
}

+(BOOL) atleastOneRecordedWayPointsFilePresent {
	NSString *strResourcePath = [[NSBundle mainBundle] resourcePath];	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSArray *dirContents = [fileManager contentsOfDirectoryAtPath:strResourcePath error:nil];
	
	BOOL fileFound = NO;
	
	for(NSString *fileName in dirContents) {
		if([fileName hasSuffix:kWayPointFileExtension]) {
			fileFound = YES;
			break;
		}
	}
	
	return fileFound;
}


@end
