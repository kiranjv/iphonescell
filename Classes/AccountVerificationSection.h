//
//  AccountVerificationSection.h
//  safecell
//
//  Created by shail on 21/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AccountVerificationSection : C1TableSection {
	NSArray *fields;
	NSMutableArray *cellControllers;
	NSMutableArray *_textFields;
}

-(NSString *)valueForRowIndex:(NSInteger)rowIndex;
-(void) hideKeyboard;

@end
