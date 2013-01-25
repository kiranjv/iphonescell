//
//  AccountVerificationSection.m
//  safecell
//
//  Created by shail on 21/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AccountVerificationSection.h"
#import "AlertHelper.h"
#import "DynamicFormFieldCellController.h"

@implementation AccountVerificationSection

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

-(UIView *) footerForSection {
	UIView *footer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)] autorelease];
	
	
	
	return footer;
}

-(void)setupSection {
	self.headerText = @"Account Verification";
	fields = [[NSArray arrayWithObjects:
			   [TableViewFormField textFieldWithLabel:@"Account Code"],
			   nil] retain];
	
	self.footerText =	@"You can obtain this code from the \"Add/Delete Account Devices\" Section" 
						@" under the \"Settings\" Tab of the Safecell App on your other phone.";
		
	self.footerView = [self footerForSection];
	
	cellControllers = [[NSMutableArray alloc] init];
	
	for(TableViewFormField *field in fields) {
		DynamicFormFieldCellController *cellController = [[DynamicFormFieldCellController alloc] initWithField:field labelWidth:100 tableFieldX:110];		
		[cellControllers addObject:cellController];
		[self.rows addObject:cellController];
		[cellController release];
	}	
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

-(BOOL)validateSection {
	for(UITextField *textField in [self textFields]) {
		if(textField.text == nil || [textField.text isBlank]) {
			[textField becomeFirstResponder];
			SimpleAlert(@"Account Code must be provided.", @"Please provide the Account Code for validation.", @"OK");
			return NO;
		}
	}
	
	return YES;
}

-(void)dealloc {
	if(_textFields) {
		[_textFields release];
	}
	
	[cellControllers release];
	
	[fields release];
	[super dealloc];
}


@end
