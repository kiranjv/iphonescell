//
//  LoginInformationSection.m
//  safecell
//
//  Created by Mobisoft Infotech on 7/7/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "LoginInformationSection.h"
#import "AlertHelper.h"


@implementation LoginInformationSection

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
	self.headerText = @"Login Information";
	fields = [[NSArray arrayWithObjects:
			   [TableViewFormField textFieldAutoOffWithLabel:@"Username"],
			   [TableViewFormField passwordFieldWithLabel:@"Password"],
			   nil] retain];
	
	self.footerText = @"The master account owner can enter these details for you.";
	
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

- (void)doneButton:(id)sender {
	int i;
	for(i=0; i<[self textFields].count; i++)
		if ([[[self textFields] objectAtIndex:i] isFirstResponder]) 
			break;
	
	[self advancedField:i];
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
