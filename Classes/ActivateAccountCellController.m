//
//  ProfileFetchFailedCellController.m
//  safecell
//
//  Created by Mobisoft Infotech on 6/23/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "ActivateAccountCellController.h"
#import "ManageAccountProfilesViewController.h"


@implementation ActivateAccountCellController

-(UIButton *) activateButton {
	UIButton *activateButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[activateButton setBackgroundImage:[UIImage imageNamed:@"retry-button.png"] forState:UIControlStateNormal];
	activateButton.frame = CGRectMake(0, 0, 71, 30);
	[activateButton setTitle:@"Activate" forState:UIControlStateNormal];
	[activateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	activateButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	[activateButton addTarget:self.parentViewController action:@selector(acivateAccountButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	return activateButton;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

	cell.textLabel.text = @"Activate";
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryView = [self activateButton];
	
	return cell;
}


@end
