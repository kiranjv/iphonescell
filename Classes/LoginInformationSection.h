//
//  LoginInformationSection.h
//  safecell
//
//  Created by Mobisoft Infotech on 7/7/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoginInformationSection : C1TableSection <UITextFieldDelegate> {
	NSArray *fields;
	NSMutableArray *cellControllers;
	NSMutableArray *_textFields;
}

-(NSString *)valueForRowIndex:(NSInteger)rowIndex;
-(void) hideKeyboard;

@end
