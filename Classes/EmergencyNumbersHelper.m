//
//  EmergencyNumbersHelper.m
//  safecell
//
//  Created by shail m on 6/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EmergencyNumbersHelper.h"
#import "EmergencyContactRepository.h"
#import "AlertHelper.h"
#import "SCEmergencyContact.h"

@implementation EmergencyNumbersHelper

- (id) init {
	self = [super init];
	if (self != nil) {
		EmergencyContactRepository *contactRepository = [[EmergencyContactRepository alloc] init];
		emergencyContacts = [contactRepository contacts];
		[emergencyContacts retain];
		[contactRepository release];
	}
	return self;
}

-(void) showEmergencyNumbers: (UIViewController *)viewController {
	if ([emergencyContacts count] == 0) {
		SimpleAlertOK(@"Emergency Numbers", 
					  @"You haven't specified emergency numbers as of yet." 
					  @"You can specify emergency numbers from Emergency Numbers screen under settings tab.");
		return;
	}
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Emergency Numbers" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
	
	for (SCEmergencyContact *contact in emergencyContacts) {
		[actionSheet addButtonWithTitle:contact.name]; 
	}
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:viewController.view.window];
	[actionSheet release];
}

- (void) dealloc {
	[emergencyContacts release];
	[super dealloc];
}

#pragma mark -
#pragma mark UIActionSheetDelegate
		 
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {

	if (( (buttonIndex - 1) > ([emergencyContacts count] - 1)) //cancel is the first button
		|| 
		(buttonIndex == [actionSheet cancelButtonIndex])) {		
		return;
	}
	
	SCEmergencyContact *contact = [emergencyContacts objectAtIndex:(buttonIndex - 1)];
	NSLog(@"Dialing : %@ - %@", contact.name, contact.number);
	NSString *dialerURL = [NSString stringWithFormat:@"tel://%@", contact.number];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:dialerURL]];		
}

@end
