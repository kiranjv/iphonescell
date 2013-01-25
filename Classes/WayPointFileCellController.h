//
//  WayPointFileCellController.h
//  safecell
//
//  Created by shail on 14/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WaypointsFilesSection;

@interface WayPointFileCellController : C1PlainCell {
	WaypointsFilesSection *parentSection;
	NSString *fileName;
}

@property (nonatomic, retain) WaypointsFilesSection *parentSection;
@property (nonatomic, retain) NSString *fileName;

- (id) initWithParentSection: (WaypointsFilesSection* ) waypointsFilesSection withFileName: (NSString *) file;

@end
