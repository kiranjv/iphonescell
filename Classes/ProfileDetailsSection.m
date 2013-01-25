//
//  ProfileDetailsSection.m
//  safecell
//
//  Created by Mobisoft Infotech on 6/23/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "ProfileDetailsSection.h"
#import "ProfileDetailsViewController.h"
#import "C1RightAlignedInfoCell.h"
#import "SCProfile.h"

@implementation ProfileDetailsSection

-(void) addFirstNameCell: (SCProfile *) profile {
	C1RightAlignedInfoCell * cell = [[C1RightAlignedInfoCell alloc] initWithLabel:@"First Name" info:profile.firstName];
	cell.cellSelectionAllowed = NO;
	cell.showDiscloserIndicator = NO;
	[self.rows addObject:cell];
	[cell release];
}

-(void) addLastNameCell: (SCProfile *) profile {
	C1RightAlignedInfoCell * cell = [[C1RightAlignedInfoCell alloc] initWithLabel:@"Last Name" info:profile.lastName];
	cell.cellSelectionAllowed = NO;
	cell.showDiscloserIndicator = NO;
	[self.rows addObject:cell];
	[cell release];
}

-(void) addEmailCell: (SCProfile *) profile {
	C1RightAlignedInfoCell * cell = [[C1RightAlignedInfoCell alloc] initWithLabel:@"Email" info:profile.email];
	cell.cellSelectionAllowed = NO;
	cell.showDiscloserIndicator = NO;
	[self.rows addObject:cell];
	[cell release];
}

-(void) addPhoneCell: (SCProfile *) profile {
	C1RightAlignedInfoCell * cell = [[C1RightAlignedInfoCell alloc] initWithLabel:@"Phone" info:profile.phone];
	cell.cellSelectionAllowed = NO;
	cell.showDiscloserIndicator = NO;
	[self.rows addObject:cell];
	[cell release];
}

-(void) addLicenseCell: (SCProfile *) profile {
	C1RightAlignedInfoCell * cell = [[C1RightAlignedInfoCell alloc] initWithLabel:@"License" info:[SCProfile driversLicenseNameForKey:profile.licenseClassKey]];
	cell.cellSelectionAllowed = NO;
	cell.showDiscloserIndicator = NO;
	[self.rows addObject:cell];
	[cell release];
}

-(void)setupSection {
	ProfileDetailsViewController *parentController = (ProfileDetailsViewController *) self.parentViewController;
	SCProfile * profile = parentController.profile;
	
	[self addFirstNameCell:profile];
	[self addLastNameCell:profile];
	[self addEmailCell:profile];
	[self addPhoneCell:profile];
	[self addLicenseCell:profile];
}

@end
