//
//  PersonalInformationSection.m
//  safecell
//
//  Created by Ben Scheirman on 4/22/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "PersonalInformationSection.h"
#import "AlertHelper.h"
#import "SelectFormFieldCellController.h"
#import "CreateProfileViewController.h"

@implementation PersonalInformationSection

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
	self.headerText = @"Personal Information";
	fields = [[NSMutableArray arrayWithObjects:
					   [TableViewFormField textFieldWithLabel:@"First Name"],
					   [TableViewFormField textFieldWithLabel:@"Last Name"],
					   [TableViewFormField emailFieldWithLabel:@"Email"], 
						[TableViewFormField phoneFieldWithLabel:@"Phone"],
					   nil] retain];
	
	self.footerText = @"These fields are required";
	
	cellControllers = [[NSMutableArray alloc] init];
	
	for(TableViewFormField *field in fields) {
		FormFieldCellController *cellController = [[FormFieldCellController alloc] initWithField:field];
		cellController.textFieldDelegate = self;
		[cellControllers addObject:cellController];
		[self.rows addObject:cellController];
		[cellController release];
	}	
	
	TableViewFormField *licenseField = [TableViewFormField selectFieldWithLabel:@"License"];
	[fields addObject:licenseField];
	SelectFormFieldCellController *licenseFieldCellController = [[SelectFormFieldCellController alloc] initWithField:licenseField];
	licenseFieldCellController.parentViewController = self.parentViewController;
    
	
	CreateProfileViewController *createProfileViewController = (CreateProfileViewController *)self.parentViewController;
	
	licenseFieldCellController.options = createProfileViewController.licenseClassNames;
	licenseFieldCellController.optionsScreenTitle = @"Select License Class";
	[cellControllers addObject:licenseFieldCellController];
	[self.rows addObject:licenseFieldCellController];

}

-(int) selectedLicenseClassIndex {
	SelectFormFieldCellController *licenseFieldCellController = (SelectFormFieldCellController *) [cellControllers objectAtIndex:4];
	int selectedLicenseClassIndex = licenseFieldCellController.selectedIndex;
	return selectedLicenseClassIndex;
}

-(BOOL)validateSection {
	for(UITextField *textField in [self textFields]) {
		if(textField.text == nil || [textField.text isBlank]) {
			[textField becomeFirstResponder];
			SimpleAlert(@"All fields are required", @"Please fill out all fields", @"OK");
			return NO;
		}
	}
	
	
	if ([self selectedLicenseClassIndex] == -1) {
		SimpleAlert(@"All fields are required", @"Please select the license class.", @"OK");
		return NO;
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

- (void) textFieldDidBeginEditing:(UITextField *)textField {
#ifdef __IPHONE_4_0
	NSLog(@"textFieldDidBeginEditing");
	C1TableViewController *tableViewController = (C1TableViewController *)self.parentViewController;
	[tableViewController performSelector:@selector(adjustNumberPad) withObject:nil afterDelay:0.0];
	[tableViewController keyboardShown];
#endif
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
