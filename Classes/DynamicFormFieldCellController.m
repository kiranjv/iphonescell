//
//  DynamicFormFieldCellController.m
//  safecell
//
//  Created by shail on 21/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DynamicFormFieldCellController.h"


@implementation DynamicFormFieldCellController

static int const kTextLabelTag = 23456;

- (id) initWithField:(TableViewFormField *)field labelWidth:(int) width tableFieldX: (int) xPos {
	self = [super initWithField:field];
	if (self != nil) {
		tableFieldX = xPos;
		labelWidth = width;
	}
	return self;
}

- (UITextField *)textFieldForCell:(UITableViewCell *)cell  {
	
	CGRect textRect = cell.contentView.bounds;
	textRect.origin.x = tableFieldX;
	textRect.size.width -= (200 - tableFieldX);
	textRect.origin.y += 10;
	textRect.size.height -= 20;
	UITextField *textField = [[[UITextField alloc] initWithFrame:textRect] autorelease];
	
	if(self.textFieldDelegate) {
		NSLog(@"Assigning textfield delegate...");
		textField.delegate = self.textFieldDelegate;
	} else {
		NSLog(@"SkippingÏ textfield delegate");
	}
	
	//we don't want anything auto-corrected here
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	
	switch (_field.formFieldType) {
		case kFormFieldPhone:
			textField.keyboardType = UIKeyboardTypePhonePad;
			textField.returnKeyType = UIReturnKeyNext;
			break;
			
		case kFormFieldEmail:
			textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
			textField.keyboardType = UIKeyboardTypeEmailAddress;
			
		default:
			break;
	}
	
	return textField;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	UITableViewCell * cell = [super tableView: tableView cellForRowAtIndexPath: indexPath];
	
	UILabel *labelView = (UILabel *)[cell viewWithTag:kTextLabelTag];
	
	if(labelView == nil) {
		CGRect frame = CGRectMake(28, 17, labelWidth, 12);
		labelView = [[[UILabel alloc] initWithFrame:frame] autorelease];
		labelView.font = [UIFont boldSystemFontOfSize:12];
		labelView.textColor = cell.textLabel.textColor;
		labelView.backgroundColor = [UIColor clearColor];
		labelView.tag = kTextLabelTag;
		
		[cell addSubview:labelView];
	}
	
	labelView.text =  [cell.textLabel.text copy];
	cell.textLabel.text = @"";
	
	return cell;
}

@end
