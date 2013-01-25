//
//  untitled.h
//  safecell
//
//  Created by shail m on 6/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EditEmergencyNumberSection.h"
#import "SCEmergencyContact.h"

@interface EditEmergencyNumbersViewController : C1TableViewController {
	EditEmergencyNumberSection *infoSection;
	SCEmergencyContact *contact;
}

@property (nonatomic, retain) SCEmergencyContact *contact;

-(id)initWithContact: (SCEmergencyContact *) emergencyContact;

@end
