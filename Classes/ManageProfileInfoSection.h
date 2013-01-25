//
//  untitled.h
//  safecell
//
//  Created by shail m on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ManageProfileInfoSection : C1TableSection <UITextFieldDelegate> {
	NSMutableArray *fields;
	NSMutableArray *cellControllers;
	NSMutableArray *_textFields;
}

-(NSString *)valueForRowIndex:(NSInteger)rowIndex;
-(void) setProfile: (SCProfile *) profile;
-(void) hideKeyboard;
-(void) setInitialSelectedLicenseClass;

-(int) selectedLicenseClassIndex;

@end
