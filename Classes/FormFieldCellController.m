//
//  FormFieldCellController.m
//  safecell
//
//  Created by Ben Scheirman on 4/21/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "FormFieldCellController.h"


@implementation FormFieldCellController

const int CELL_CONTENT_LEFT = 190;
const int CELL_CONTENT_TOP = 8;

@synthesize textFieldDelegate;
@synthesize control = _control;
@synthesize field = _field;

-(id)initWithField:(TableViewFormField *)field {
	if(self = [super init]) {
		self.field = field;
	}
	
	return self;
}

-(void)addTarget:(id)target selector:(SEL)selector forControlEvents:(UIControlEvents)controlEvents {
	_delegate = target;
	_selector = selector;
	_controlEvents = controlEvents;
}

- (UITextField *)textFieldForCell:(UITableViewCell *)cell  {
	
	CGRect textRect = cell.contentView.bounds;
	textRect.origin.x = 90;
	textRect.size.width -= 110;
	textRect.origin.y += 10;
	textRect.size.height -= 20;
	UITextField *textField = [[[UITextField alloc] initWithFrame:textRect] autorelease];
	
	if(self.textFieldDelegate) {
		NSLog(@"Assigning textfield delegate...");
		textField.delegate = self.textFieldDelegate;
	} else {
		NSLog(@"Skipping textfield delegate");
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
			break;
			
		case kFormFieldPassword:
			textField.secureTextEntry = YES;
			break;
			
		case kFormFieldTextAutoOff:
			textField.autocorrectionType = UITextAutocorrectionTypeNo;
			textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
			break;
            
        default:
            break;
	}
	
	return textField;
}


-(UITableViewCellStyle)cellStyleForFieldType {
	if(_field.formFieldType == kFormFieldSwitch) {
		return UITableViewCellStyleSubtitle;
	}
	
	return UITableViewCellStyleValue2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *CellIdentifier = [NSString stringWithFormat:@"FormFieldCell%d,%d", indexPath.section, indexPath.row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:[self cellStyleForFieldType] reuseIdentifier:CellIdentifier] autorelease];
	
		cell.textLabel.text = _field.label;
		
		if([_field isTextType]) {
			
			if (!self.control) {
				UITextField *textField = [self textFieldForCell:cell];
				cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
				NSLog(@"Setting textField control on the row");
				self.control = textField;
				//[textField release];
			}
			
			cell.accessoryType = UITableViewCellAccessoryNone;
			
			[cell.contentView addSubview:self.control];
		} else {
			
			cell.detailTextLabel.text = _field.hint;
			UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(CELL_CONTENT_LEFT, CELL_CONTENT_TOP, 80, 50)];
			self.control = sw;
			[cell.contentView addSubview:sw];
			[sw release];
			
			cell.accessoryType = UITableViewCellAccessoryNone;
			
		}
		
		if(_delegate != nil)
			[self.control addTarget:_delegate action:_selector forControlEvents:_controlEvents];
	}
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"didSelectRow...");
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	if([_field isTextType]) {
		UITextField *textField = (UITextField *)self.control;
		[textField becomeFirstResponder];
	}
}

-(NSString *)textValue {
	if([_control respondsToSelector:@selector(text)]) {
		return (NSString *)[_control performSelector:@selector(text)];
	}
	
	return nil;
}

-(BOOL)boolValue {
	if([_control respondsToSelector:@selector(on)]) {
		return [(NSNumber *)[_control performSelector:@selector(on)] boolValue];
	}
	
	return NO;
}

-(void)dealloc {
	self.control = nil;
	self.field = nil;
	
	[super dealloc];
}

@end
