//
//  TableViewFormField.h
//  safecell
//
//  Created by Ben Scheirman on 4/19/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	kFormFieldText = 1,
	kFormFieldEmail = 2,
	kFormFieldPassword = 3,
	kFormFieldDate = 4,
	kFormFieldPhone = 5,
	kFormFieldSwitch = 6,
	kFormFieldTextAutoOff = 7,
	kFormFieldSelect = 8
} FormFieldType;

@interface TableViewFormField : NSObject {
	NSString *_label;
	NSString *_hint;
	FormFieldType _formFieldType;
}

@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *hint;
@property (nonatomic) FormFieldType formFieldType;

-(id)initWithLabel:(NSString *)label type:(FormFieldType)formFieldType;
-(id)initWithLabel:(NSString *)label hint:(NSString *)hint type:(FormFieldType)formFieldType;

-(BOOL)isTextType;

+(TableViewFormField *)textFieldWithLabel:(NSString *)label;
+(TableViewFormField *)emailFieldWithLabel:(NSString *)label;
+(TableViewFormField *)passwordFieldWithLabel:(NSString *)label;
+(TableViewFormField *)dateFieldWithLabel:(NSString *)label;
+(TableViewFormField *)phoneFieldWithLabel:(NSString *)label;
+(TableViewFormField *)switchFieldWithLabel:(NSString *)label hint:(NSString *)hint;
+(TableViewFormField *)textFieldAutoOffWithLabel:(NSString *)label;
+(TableViewFormField *)selectFieldWithLabel:(NSString *)label;

@end
