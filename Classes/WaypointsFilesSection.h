//
//  WaypointsFilesSection.h
//  safecell
//
//  Created by shail on 14/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelectWaypointsFileViewController.h"


@interface WaypointsFilesSection : C1TableSection {
	NSMutableArray *fileNames;
	NSString * selectedFile;
}

@property(nonatomic, retain) NSString * selectedFile;

-(void) populateWaypointFiles;
-(void) setupSection;
-(void) addFileRows;

@end
