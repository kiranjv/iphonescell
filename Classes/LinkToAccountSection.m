//
//  LinkToAccountSection.m
//  safecell
//
//  Created by Ben Scheirman on 4/22/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "LinkToAccountSection.h"
#import "TableViewFormField.h"
#import "FormFieldCellController.h"

@implementation LinkToAccountSection

-(void)setupSection {
	self.headerText = @"Account Information";
	self.footerText = @"If you don't have an account, leave this Off and we'll create one for you.";
	
	TableViewFormField *hasAccountField = [TableViewFormField switchFieldWithLabel:@"Link to Account?" hint:nil];
	switchRow = [[FormFieldCellController alloc] initWithField:hasAccountField];
	[switchRow addTarget:self selector:@selector(onLinkToAccount:) forControlEvents:UIControlEventValueChanged];
	
	[self.rows addObject:switchRow];
}

-(void)onLinkToAccount:(id)sender {
	UISwitch *sw = (UISwitch *)sender;
	NSLog(@"Switch toggled");
	if (sw.on) {
		TableViewFormField *accountCodeField = [TableViewFormField textFieldWithLabel:@"Account Code"];
		accountCodeRow = [[FormFieldCellController alloc] initWithField:accountCodeField];
		accountCodeRow.textFieldDelegate = self;
		//[self.rows addObject:accountCodeRow];
		
		[self dynamicAddRow:accountCodeRow];
		
		[accountCodeRow release];
		
		//[super reloadData];
	} else {
		[self dynamicRemoveRowAtIndex:self.rows.count-1];
	}
}


-(void)dealloc {
	[switchRow release];
	[super dealloc];
}

@end
