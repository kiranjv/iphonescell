//
//  PersonalInformationSection.h
//  safecell
//
//  Created by Ben Scheirman on 4/22/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PersonalInformationSection : C1TableSection <UITextFieldDelegate> {
	NSMutableArray *fields;
	NSMutableArray *cellControllers;
	NSMutableArray *_textFields;
}

-(NSString *)valueForRowIndex:(NSInteger)rowIndex;
-(void) hideKeyboard;
-(int) selectedLicenseClassIndex;

@end
