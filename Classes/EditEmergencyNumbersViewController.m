//
//  untitled.m
//  safecell
//
//  Created by shail m on 6/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EditEmergencyNumbersViewController.h"
#import "EmergencyContactRepository.h"
#import "AlertHelper.h"

@implementation EditEmergencyNumbersViewController

@synthesize contact;

-(EditEmergencyNumberSection *) infoSection {
	if (!infoSection) {
		infoSection = [[EditEmergencyNumberSection alloc] init];		
		infoSection.parentViewController = self;		
	}
	
	return infoSection;
}

-(void) buttonFooter {
	
	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
	
	//we would like to show a gloosy red button, so get the image first
	UIImage *image = [[UIImage imageNamed:@"button_green.png"]
					  stretchableImageWithLeftCapWidth:8 topCapHeight:8];
	
	//create the button
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	
	//the button should be as big as a table view cell
	[button setFrame:CGRectMake(10, 20, 300, 44)];
	
	//set title, font size and font color
	[button setTitle:@"Save Contact" forState:UIControlStateNormal];
	[button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	//set action of the button
	[button addTarget:self action:@selector(saveButtonTapped:)
	 forControlEvents:UIControlEventTouchUpInside];
	
	
	//add the button to the view
	[footerView addSubview:button];
	
	
	C1TableSection *lastSection = [self.sections lastObject];
	lastSection.footerView = footerView;
	
	[footerView release];
}

-(void)setupTable {	
	[self addSection:[self infoSection]];
	
	[self buttonFooter];
}

- (void)viewDidAppear:(BOOL)animated {
	self.tableView.frame = self.view.bounds;
	[[self infoSection] setContact:self.contact];
}

-(id)initWithContact: (SCEmergencyContact *) emergencyContact {
	
	if(self = [super initWithStyle:UITableViewStyleGrouped]) {
		self.contact = emergencyContact;
		self.tabBarPresent = YES;
		self.navigationItem.title = @"Emergency Contact";
		[self setupTable];
	}
	
	return self;
}

- (void) dealloc {
	[contact release];
	[super dealloc];
}

#pragma mark -
#pragma mark Actions

-(void) saveButtonTapped:(id) sender {
	BOOL validForm = YES;
	
	for(C1TableSection *sections in [self sections]) {
		if(![sections validateSection]) {
			validForm = NO;
			//stop propagation
			break;
		}
	}
	
	if(validForm) {		
		contact.name = [infoSection valueForRowIndex:0];
		contact.number = [infoSection valueForRowIndex:1];		
		
		NSLog(@"contact.name: %@", contact.name);
		NSLog(@"contact.number: %@", contact.number);
		
		[infoSection hideKeyboard];
		EmergencyContactRepository *contactRepository = [[EmergencyContactRepository alloc] init];
		[contactRepository saveOrUpdateContact:self.contact];
		[contactRepository release];
		
		SimpleAlertOK(@"Emergency Contact Saved.", @"The emergency contact information was saved successfully.");
	}
}



@end
