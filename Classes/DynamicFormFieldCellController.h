//
//  DynamicFormFieldCellController.h
//  safecell
//
//  Created by shail on 21/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormFieldCellController.h"


@interface DynamicFormFieldCellController : FormFieldCellController {
	int tableFieldX;
	int labelWidth;
}

- (id) initWithField:(TableViewFormField *)field labelWidth:(int) width tableFieldX: (int) xPos;

@end
