//
//  EditEmergencyNumberSection.m
//  safecell
//
//  Created by shail m on 6/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EditEmergencyNumberSection.h"
#import "AlertHelper.h"
#import "EditEmergencyNumbersViewController.h"


@implementation EditEmergencyNumberSection

- (NSArray *)textFields {
	if(_textFields == nil) {
		NSLog(@"Creating array to hold text field controls...");
		_textFields = [[NSMutableArray alloc] init];
		for(FormFieldCellController *cell in cellControllers) {
			if([cell.field isTextType]) {
				NSLog(@"Adding text field...");
				
				if(cell.control == nil) {
					NSLog(@"WARNING:cell with field of text type didn't have its control set!");
				}
				
				[_textFields addObject:cell.control];
			}
		}
	}
	
	return _textFields;
}

-(void)setupSection {
	self.headerText = @"Contact Information";
	fields = [[NSArray arrayWithObjects:
			   [TableViewFormField textFieldWithLabel:@"Name"],
			   [TableViewFormField phoneFieldWithLabel:@"Number"],
			   nil] retain];
	
	cellControllers = [[NSMutableArray alloc] init];
	
	for(TableViewFormField *field in fields) {
		FormFieldCellController *cellController = [[FormFieldCellController alloc] initWithField:field];
		cellController.textFieldDelegate = self;
		[cellControllers addObject:cellController];
		[self.rows addObject:cellController];
		[cellController release];
	}	
}

-(BOOL)validateSection {
	for(UITextField *textField in [self textFields]) {
		if(textField.text == nil || [textField.text isBlank]) {
			[textField becomeFirstResponder];
			SimpleAlert(@"All fields are required", @"Please fill out all fields", @"OK");
			return NO;
		}
	}
	
	return YES;
}

-(void) hideKeyboard {
	NSArray *textFieldsArr = [self textFields];
	for(UITextField *textField in textFieldsArr) {
		[textField resignFirstResponder];
	}
}

-(void) setContact: (SCEmergencyContact *) emergencyContact {
	NSArray *textFieldsArr = [self textFields];
	
	UITextField *nameField = [textFieldsArr objectAtIndex:0];
	nameField.text = emergencyContact.name;
	
	UITextField *numberField = [textFieldsArr objectAtIndex:1];
	numberField.text = emergencyContact.number;
}


#pragma mark -
#pragma mark textFieldDelegate methods

- (void)advancedField:(NSInteger)currentTextFieldIndex {
	if(currentTextFieldIndex >= [[self textFields] count] - 1) {
		NSLog(@"Hiding keyboard");
		[[[self textFields] objectAtIndex:currentTextFieldIndex] resignFirstResponder];
	} else {
		NSLog(@"Advancing to field %d", currentTextFieldIndex);
		[[[self textFields] objectAtIndex:currentTextFieldIndex+1] becomeFirstResponder];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	NSLog(@"textFieldShouldreturn?");
	NSInteger currentIndex = [[self textFields] indexOfObject:textField];
	[self advancedField:currentIndex];
	return NO;
}


-(NSString *)valueForRowIndex:(NSInteger)rowIndex {
	return [[_textFields objectAtIndex:rowIndex] text];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
#ifdef __IPHONE_4_0
	NSLog(@"textFieldDidBeginEditing");
	C1TableViewController *tableViewController = (C1TableViewController *)self.parentViewController;
	[tableViewController performSelector:@selector(adjustNumberPad) withObject:nil afterDelay:0.0];
	[tableViewController keyboardShown];
#endif
}



#pragma mark -
#pragma mark cleanup


-(void)dealloc {
	if(_textFields) {
		[_textFields release];
	}
	
	[cellControllers release];
	
	[fields release];
	[super dealloc];
}



@end
