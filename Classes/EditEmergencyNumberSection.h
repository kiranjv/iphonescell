//
//  EditEmergencyNumberSection.h
//  safecell
//
//  Created by shail m on 6/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCEmergencyContact.h"

@interface EditEmergencyNumberSection : C1TableSection <UITextFieldDelegate> {
	NSArray *fields;
	NSMutableArray *cellControllers;
	NSMutableArray *_textFields;
}

-(NSString *)valueForRowIndex:(NSInteger)rowIndex;
-(void) hideKeyboard;
-(void) setContact: (SCEmergencyContact *) emergencyContact;

@end
