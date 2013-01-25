//
//  ProfileRowCellController.m
//  safecell
//
//  Created by Mobisoft Infotech on 7/19/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "ProfileRowCellController.h"
#import "SelectProfileViewController.h"
#import "SCProfile.h"


@implementation ProfileRowCellController

@synthesize profile;

-(SCProfile *) profileForIndexPath: (NSIndexPath *) indexPath {
	SelectProfileViewController *parentController = (SelectProfileViewController *)self.parentViewController;
	int row = [indexPath row];
	SCProfile *profileObj = [parentController.account.profiles objectAtIndex:row];
	return profileObj;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	self.profile = [self profileForIndexPath:indexPath];
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName];
	
	cell.detailTextLabel.text = profile.phone;
	
	cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
	
	cell.accessoryType = UITableViewCellAccessoryNone;	
	
	SelectProfileViewController *parentController = (SelectProfileViewController *)self.parentViewController;
	
	if(parentController.selectedProfile == self.profile) {
		cell.accessoryView = nil;
		cell.accessoryType = UITableViewCellAccessoryCheckmark;	
	} else {
		
#ifdef __IPHONE_4_0
		NSLog(@"iOS 4 accessoryView");
		UILabel *accessoryView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
#else
		NSLog(@"iOS 3 accessoryView");
		UILabel *accessoryView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
#endif
		accessoryView.text = @"";
		accessoryView.backgroundColor = [UIColor clearColor];
		cell.accessoryView = accessoryView;
		[accessoryView release];		
	}
	
	return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	SelectProfileViewController *parentController = (SelectProfileViewController *)self.parentViewController;
	parentController.selectedProfile = self.profile;
	[self performSelector:@selector(reloadTableData) withObject:self afterDelay:0.3];	
}

- (void) dealloc {
	[profile release];
	[super dealloc];
}

-(void) reloadTableData {
	SelectProfileViewController *parentController = (SelectProfileViewController *)self.parentViewController;
	[parentController.tableView reloadData];
}


@end
