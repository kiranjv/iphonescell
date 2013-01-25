//
//  TableViewFormField.m
//  safecell
//
//  Created by Ben Scheirman on 4/19/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "TableViewFormField.h"


@implementation TableViewFormField

@synthesize label = _label;
@synthesize formFieldType = _formFieldType;
@synthesize hint = _hint;


-(id)initWithLabel:(NSString *)label type:(FormFieldType)formFieldType {
	if(self = [self initWithLabel:label hint:nil type:formFieldType]) {
	}
	
	return self;
}

-(id)initWithLabel:(NSString *)label hint:(NSString *)hint type:(FormFieldType)formFieldType {
	if(self = [super init]) {
		self.label = label;
		self.hint = hint;
		self.formFieldType = formFieldType;
	}
	
	return self;
}

-(BOOL)isTextType {
	return (
		self.formFieldType == kFormFieldText || 
		self.formFieldType == kFormFieldPassword ||
		self.formFieldType == kFormFieldPhone ||
		self.formFieldType == kFormFieldEmail ||
		self.formFieldType == kFormFieldTextAutoOff);
}

#pragma mark -
#pragma mark static factory methods

+(TableViewFormField *)textFieldWithLabel:(NSString *)label {
	return [[[TableViewFormField alloc] initWithLabel:label type:kFormFieldText] autorelease];
}

+(TableViewFormField *)emailFieldWithLabel:(NSString *)label {
	return [[[TableViewFormField alloc] initWithLabel:label type:kFormFieldEmail] autorelease];
}

+(TableViewFormField *)passwordFieldWithLabel:(NSString *)label {
	return [[[TableViewFormField alloc] initWithLabel:label type:kFormFieldPassword] autorelease];
}

+(TableViewFormField *)dateFieldWithLabel:(NSString *)label {
	return [[[TableViewFormField alloc] initWithLabel:label type:kFormFieldDate] autorelease];
}

+(TableViewFormField *)phoneFieldWithLabel:(NSString *)label {
	return [[[TableViewFormField alloc] initWithLabel:label type:kFormFieldPhone] autorelease];
}

+(TableViewFormField *)switchFieldWithLabel:(NSString *)label hint:(NSString *)hint {
	return [[[TableViewFormField alloc] initWithLabel:label hint:hint type:kFormFieldSwitch] autorelease];
}

+(TableViewFormField *)textFieldAutoOffWithLabel:(NSString *)label {
	return [[[TableViewFormField alloc] initWithLabel:label type:kFormFieldTextAutoOff] autorelease];
}

+(TableViewFormField *)selectFieldWithLabel:(NSString *)label {
	return [[[TableViewFormField alloc] initWithLabel:label type:kFormFieldSelect] autorelease];
}

#pragma mark -
#pragma mark cleanup

-(void)dealloc {
	self.label = nil;
	self.formFieldType = 0;
	[super dealloc];
}

@end
