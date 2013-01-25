//
//  TripInfoCellController.m
//  safecell
//
//  Created by shail m on 6/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TripInfoCellController.h"


@implementation TripInfoCellController

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	cell.textLabel.font = [UIFont boldSystemFontOfSize:18];	
	
	cell.backgroundView = [[[UIView alloc] initWithFrame:cell.bounds] autorelease];
	cell.backgroundView.backgroundColor = [UIColor whiteColor];
	
	return cell;
}

@end
