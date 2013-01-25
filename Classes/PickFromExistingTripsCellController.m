//
//  PickFromExistingTripsCellController.m
//  safecell
//
//  Created by shail on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PickFromExistingTripsCellController.h"
#import "PickTripViewController.h"
#import "AddTripViewController.h"

@implementation PickFromExistingTripsCellController

@synthesize pickTripViewController;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
	
	cell.backgroundView = [[[UIView alloc] initWithFrame:cell.bounds] autorelease];
	cell.backgroundView.backgroundColor = [UIColor whiteColor];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if(!self.pickTripViewController) {
		AddTripViewController *addTripViewController = (AddTripViewController *) parentViewController;
		PickTripViewController *newViewController = [[PickTripViewController alloc] initWithStyle:UITableViewStylePlain withAddTripViewController:addTripViewController];
		self.pickTripViewController = newViewController;
		[newViewController release];
	} else {
		// If we are using existing instance then reload data
		// so as to sync the selected trip between controllers
		// and show appropriate checkmarks.
		[pickTripViewController.tableView reloadData];
	}
	
	[parentViewController.navigationController pushViewController:pickTripViewController animated:YES];
	
}

- (void) dealloc {
	[pickTripViewController release];
	[super dealloc];
}


@end
