//
//  EmergencyNumbersViewController.m
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EmergencyNumbersViewController.h"
#import "NavBarHelper.h"
#import "EmergencyContactRepository.h"

@implementation EmergencyNumbersViewController

@synthesize emergencyContacts;


-(EmergencyNumbersListSection *) emergencyNumbersListSection {	
	if(!emergencyNumbersListSection) {
		emergencyNumbersListSection = [[EmergencyNumbersListSection alloc] initWithoutSetup];
		emergencyNumbersListSection.parentViewController = self;
		[emergencyNumbersListSection setupSection];
	}
	
	return emergencyNumbersListSection;
}

-(void) setupTable {
	[self addSection:[self emergencyNumbersListSection]];
}

-(id)init {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self != nil) {		
		DecorateNavBar(self);		
		self.navigationItem.title = @"Contacts";
		[self setupTable];		
	}
	return self;
}

- (void)dealloc {
	[emergencyContacts release];
	[emergencyNumbersListSection release];
    [super dealloc];
}

- (void)viewWillAppear: (BOOL)animated {
	[self loadContacts];
	[self.tableView reloadData];
}

-(void) loadContacts {
	EmergencyContactRepository *repository = [[EmergencyContactRepository alloc] init];	
	NSMutableArray *contacts = [repository contacts];	
	[repository release];
	
	self.emergencyContacts = contacts;
	
	while ([self.emergencyContacts count] < kNumberOfMaxEmergencyContacts) {
		SCEmergencyContact *number = [[SCEmergencyContact alloc] init];
		number.name = @"";
		number.number = @"";
		[self.emergencyContacts addObject:number];
		[number release];
	}
}

@end
