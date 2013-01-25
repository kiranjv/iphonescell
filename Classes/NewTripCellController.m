//
//  NewTripCellController.m
//  safecell
//
//  Created by shail on 08/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewTripCellController.h"
#import "AlertPrompt.h"
#import "SaveTripSection.h"
#import "AddTripViewController.h"

static const NSInteger kAlertPromptOKButton = 1;

@implementation NewTripCellController

@synthesize saveTripSection;

- (void) dealloc {
	[saveTripSection release];
	[super dealloc];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	cell.textLabel.font = [UIFont boldSystemFontOfSize:18];	
	
	cell.backgroundView = [[[UIView alloc] initWithFrame:cell.bounds] autorelease];
	cell.backgroundView.backgroundColor = [UIColor whiteColor];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	AlertPrompt * alertPrompt = [[AlertPrompt alloc] initWithTitle:@"Enter Trip Name" message:self.info delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"OK"];
	[alertPrompt show];
	[alertPrompt release];
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if(buttonIndex == kAlertPromptOKButton) {
		AlertPrompt *prompt = (AlertPrompt *)alertView;
		
		if(prompt.enteredText != nil) {
			NSString * enteredText = [prompt.enteredText stringByStrippingWhitespace];
			if([enteredText length] > 0) {
				self.info = prompt.enteredText;
				[saveTripSection reloadData];		
				AddTripViewController * addTripViewController = (AddTripViewController *) saveTripSection.parentViewController;
				addTripViewController.selectedTrip = nil;
			}
		}
	}
}

@end
