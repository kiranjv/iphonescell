	//
//  EmergencyNumberCellController.m
//  safecell
//
//  Created by shail m on 6/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EmergencyNumberCellController.h"
#import "EmergencyNumbersViewController.h"
#import "SCEmergencyContact.h"
#import "EditEmergencyNumbersViewController.h"

@implementation EmergencyNumberCellController


-(SCEmergencyContact *) contactForRow: (int) row {
	EmergencyNumbersViewController* controller = (EmergencyNumbersViewController *)self.parentViewController;
	SCEmergencyContact *contact = [controller.emergencyContacts objectAtIndex:row];
	
	return contact;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	int row = [indexPath row];
	SCEmergencyContact *contact = [self contactForRow:row];
	
	cell.textLabel.text = [NSString stringWithFormat:@"Contact %d", (row  + 1)];
	cell.detailTextLabel.text = contact.name;
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	int row = [indexPath row];
	SCEmergencyContact *contact = [self contactForRow:row];
	
	EditEmergencyNumbersViewController *viewController = [[EditEmergencyNumbersViewController alloc] initWithContact:contact];
	[self.parentViewController.navigationController pushViewController:viewController animated:YES];
	[viewController release];
	
}

- (void) dealloc {
	[super dealloc];
}


@end
