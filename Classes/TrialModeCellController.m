//
//  TrialModeCellController.m
//  safecell
//
//  Created by Mobisoft Infotech on 7/13/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "TrialModeCellController.h"
#import "ManageAccountProfilesViewController.h"


@implementation TrialModeCellController

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	cell.textLabel.text = @"Trial Mode";
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	return cell;
}

@end
