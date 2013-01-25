//
//  EmergencyContactRepository.h
//  safecell
//
//  Created by shail m on 6/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCEmergencyContact.h"
#import "AbstractRepository.h"


@interface EmergencyContactRepository : AbstractRepository {

}

-(void) saveContact: (SCEmergencyContact *) contact;
-(void) updateContact: (SCEmergencyContact *) contact;
-(BOOL) contactExists: (SCEmergencyContact *) contact;
-(void) saveOrUpdateContact: (SCEmergencyContact *) contact;
-(NSMutableArray *) contacts;
-(void) deleteAllContacts;

@end
