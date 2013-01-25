//
//  ValidUntilCellController.m
//  safecell
//
//  Created by Mobisoft Infotech on 7/13/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "ValidUntilCellController.h"
#import "ManageAccountProfilesViewController.h"


@implementation ValidUntilCellController

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	// ManageAccountProfilesViewController *parentController = (ManageAccountProfilesViewController *)self.parentViewController;
	cell.textLabel.text = @"Valid Until";
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];	
	[dateFormatter setDateFormat:@"MMMM dd, yyyy"];
	
	// cell.detailTextLabel.text = [dateFormatter stringFromDate:parentController.currentAccount.validUntil];
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	return cell;
}
@end
