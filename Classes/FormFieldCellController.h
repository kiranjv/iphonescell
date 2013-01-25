//
//  FormFieldCellController.h
//  safecell
//
//  Created by Ben Scheirman on 4/21/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewFormField.h"
#import "C1TableCellController.h"

@interface FormFieldCellController : C1TableCell {
	TableViewFormField *_field;
	id<UITextFieldDelegate> textFieldDelegate;
	UIControl *_control;
	id _delegate;
	SEL _selector;
	UIControlEvents _controlEvents;
}

@property (nonatomic, assign) id<UITextFieldDelegate> textFieldDelegate;
@property (nonatomic, retain) UIControl *control;
@property (nonatomic, retain) TableViewFormField *field;

-(id)initWithField:(TableViewFormField *)field;

-(void)addTarget:(id)target selector:(SEL)selector forControlEvents:(UIControlEvents)controlEvents;

-(NSString *)textValue;
-(BOOL)boolValue;

-(UITableViewCellStyle)cellStyleForFieldType;

@end
