//
//  VerificationCodeCellController.m
//  safecell
//
//  Created by Mobisoft Infotech on 6/23/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "VerificationCodeCellController.h"
#import "ManageAccountProfilesViewController.h"


@implementation VerificationCodeCellController

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	ManageAccountProfilesViewController *parentController = (ManageAccountProfilesViewController *)self.parentViewController;
	cell.textLabel.text = @"Verification Code";
	cell.detailTextLabel.text = parentController.currentAccount.accountCode;
	
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	return cell;
}

@end
