//
//  LinkToAccountSection.h
//  safecell
//
//  Created by Ben Scheirman on 4/22/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "C1TableSection.h"
#import "FormFieldCellController.h"

@interface LinkToAccountSection : C1TableSection <UITextFieldDelegate> {
	FormFieldCellController *switchRow;
	FormFieldCellController *accountCodeRow;
}

@end
