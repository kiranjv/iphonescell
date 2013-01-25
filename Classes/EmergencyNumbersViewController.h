//
//  EmergencyNumbersViewController.h
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmergencyNumbersListSection.h"

static const int kNumberOfMaxEmergencyContacts = 4;

@interface EmergencyNumbersViewController : C1TableViewController {
	EmergencyNumbersListSection *emergencyNumbersListSection;
	NSMutableArray *emergencyContacts;
}

@property (nonatomic, retain) NSMutableArray *emergencyContacts;


-(void) loadContacts;

@end
