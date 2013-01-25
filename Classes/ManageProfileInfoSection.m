//
//  untitled.m
//  safecell
//
//  Created by shail m on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ManageProfileInfoSection.h"
#import "AlertHelper.h"
#import "SCProfile.h"
#import "SelectFormFieldCellController.h"
#import "ManageProfileViewController.h"
#import "SCLicenseClass.h"

@implementation ManageProfileInfoSection

- (id) init {
	self = [super initWithoutSetup];
	if (self != nil) {
		
	}
	return self;
}


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

-(int) selectedLicenseClassIndex {
	SelectFormFieldCellController *licenseFieldCellController = (SelectFormFieldCellController *) [cellControllers objectAtIndex:4];
	int selectedLicenseClassIndex = licenseFieldCellController.selectedIndex;
	return selectedLicenseClassIndex;
}


-(void) setInitialSelectedLicenseClass {
	ManageProfileViewController *manageProfileViewController = (ManageProfileViewController *)self.parentViewController;
	SCProfile *profile = manageProfileViewController.userProfile;
	SelectFormFieldCellController *licenseFieldCellController = [cellControllers objectAtIndex:4];
	licenseFieldCellController.options = manageProfileViewController.licenseClassNames;
	int i = 0;
	for(SCLicenseClass *licenseClass in manageProfileViewController.licenseClasses) {
		if([licenseClass.key isEqualToString:profile.licenseClassKey]) {
			licenseFieldCellController.selectedIndex = i;
			break;
		}
		i++;
	}
}

-(void)setupSection {
	self.headerText = @"Personal Information";
	fields = [[NSMutableArray arrayWithObjects:
			   [TableViewFormField textFieldWithLabel:@"First Name"],
			   [TableViewFormField textFieldWithLabel:@"Last Name"],
			   [TableViewFormField emailFieldWithLabel:@"Email"], 
			   [TableViewFormField phoneFieldWithLabel:@"Phone"],
			   nil] retain];
	
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
	
	ManageProfileViewController *manageProfileViewController = (ManageProfileViewController *)self.parentViewController;
	licenseFieldCellController.options = manageProfileViewController.licenseClassNames;
	
	licenseFieldCellController.optionsScreenTitle = @"Select License Class";
	[cellControllers addObject:licenseFieldCellController];
	[self.rows addObject:licenseFieldCellController];
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

-(void) setProfile: (SCProfile *) profile {
	
	NSArray *textFieldsArr = [self textFields];
	
	UITextField *firstNameField = [textFieldsArr objectAtIndex:0];
	firstNameField.text = profile.firstName;
	
	UITextField *lastNameField = [textFieldsArr objectAtIndex:1];
	lastNameField.text = profile.lastName;
	
	UITextField *emailField = [textFieldsArr objectAtIndex:2];
	emailField.text = profile.email;
	
	UITextField *phoneNoField = [textFieldsArr objectAtIndex:3];
	phoneNoField.text = profile.phone;
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
