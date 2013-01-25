//
//  SelectWayPoitnsFileViewController.h
//  safecell
//
//  Created by shail on 14/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWayPointFileExtension @".wpf"

@protocol SelectWaypointsFileViewControllerDelegate<NSObject>

-(void) didFinishSelectingWayPointsFile: (NSString *) fileName;

@end

@class WaypointsFilesSection;

@interface SelectWaypointsFileViewController : C1TableViewController {
	WaypointsFilesSection *waypointsFilesSection;
	id<SelectWaypointsFileViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id<SelectWaypointsFileViewControllerDelegate> delegate;


+(BOOL) atleastOneRecordedWayPointsFilePresent;

-(WaypointsFilesSection *) waypointsFilesSection;
-(void) setupTable;
-(void) setUpNavigationBar;

@end
