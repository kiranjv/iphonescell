//
//  WayPointFileCellController.m
//  safecell
//
//  Created by shail on 14/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WayPointFileCellController.h"
#import "WaypointsFilesSection.h"



@implementation WayPointFileCellController

@synthesize parentSection;
@synthesize fileName;

- (id) initWithParentSection: (WaypointsFilesSection* ) waypointsFilesSection withFileName: (NSString *) file {
	self = [super init];
	if (self != nil) {
		self.parentSection = waypointsFilesSection;
		self.fileName = file;
		self.text = fileName;
	}
	return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	if([self.fileName isEqualToString: self.parentSection.selectedFile]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;	
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	self.parentSection.selectedFile = self.fileName;
	[self performSelector:@selector(reloadTableData) withObject:self afterDelay:0.3];	
}

-(void) reloadTableData {
	[self.parentSection reloadData];
}

- (void) dealloc {
	[parentSection release];
	[fileName release];
	[super dealloc];
}


@end
