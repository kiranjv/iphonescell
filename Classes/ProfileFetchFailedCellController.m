//
//  ProfileFetchFailedCellController.m
//  safecell
//
//  Created by Mobisoft Infotech on 6/23/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "ProfileFetchFailedCellController.h"
#import "ManageAccountProfilesViewController.h"


@implementation ProfileFetchFailedCellController

-(UIButton *) retryButton {
	UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[retryButton setBackgroundImage:[UIImage imageNamed:@"retry-button.png"] forState:UIControlStateNormal];
	retryButton.frame = CGRectMake(0, 0, 71, 30);
	[retryButton setTitle:@"Retry" forState:UIControlStateNormal];
	[retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	retryButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
	[retryButton addTarget:self action:@selector(retryButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	return retryButton;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

	cell.textLabel.text = @"Netwrok Request Failed";
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.accessoryView = [self retryButton];
	
	return cell;
}

-(void) retryButtonTapped {
	ManageAccountProfilesViewController *parentController = (ManageAccountProfilesViewController *)self.parentViewController;
	[parentController loadData];
}

@end
