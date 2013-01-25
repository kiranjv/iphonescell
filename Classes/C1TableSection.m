//
//  C1TableSection.m
//  safecell
//
//  Created by Ben Scheirman on 4/21/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "C1TableSection.h"
#import "C1TableCellController.h"

@implementation C1TableSection

@synthesize headerText = _headerText;
@synthesize footerText = _footerText;
@synthesize rows = _rows;
@synthesize tableView = _tableView;
@synthesize sectionIndex = _sectionIndex;
@synthesize headerView = _headerView;
@synthesize footerView = _footerView;
@synthesize parentViewController = _parentViewController;

-(id)init {
	if(self = [super init]) {
		_rows = [[NSMutableArray alloc] init];
		[self setupSection];
	}
	
	return self;
}

-(id) initWithoutSetup {
	if(self = [super init]) {
		_rows = [[NSMutableArray alloc] init];
	}
	
	return self;	
}

-(void)reloadData {
	if(self.tableView == nil) {
		NSLog(@"WARNING: Table view property wasn't set.");
	}
	
	[self.tableView reloadData];
}

-(void)setupSection {
	//intended to be overridden in a subclass
}

-(BOOL)validateSection {
	//return NO in a child class to prevent further validations from occurring
	return YES;
}

-(void)dynamicAddRow:(id<C1TableCellController>)row {
	row.parentViewController = self.parentViewController;
	NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.rows.count inSection:self.sectionIndex];	
	[self.rows addObject:row];

	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
}

-(void)dynamicRemoveRowAtIndex:(NSInteger)rowIndex {
	[self.rows removeObjectAtIndex:rowIndex];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:self.sectionIndex];	
	[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}

-(void)dealloc {
	[_rows release];
	[super dealloc];
}

@end
