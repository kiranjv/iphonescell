//
//  UITableViewAdditions.m
//  safecell
//
//  Created by Ben Scheirman on 9/20/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "UITableViewAdditions.h"

@implementation UITableView (Additions)

- (void)scrollToTop:(BOOL)animated {
	[self setContentOffset:CGPointMake(0,0) animated:animated];
}

- (void)scrollToBottom:(BOOL)animated {
	NSUInteger sectionCount = [self numberOfSections];
	if (sectionCount) {
		NSUInteger rowCount = [self numberOfRowsInSection:0];
		if (rowCount) {
			NSUInteger ii[2] = {0, rowCount-1};
			NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
			[self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom
								animated:animated];
		}
	}
}

- (void)scrollToFirstRow:(BOOL)animated {
	if ([self numberOfSections] > 0 && [self numberOfRowsInSection:0] > 0) {
		NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		[self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop
							animated:NO];
	}
}

- (void)scrollToLastRow:(BOOL)animated {
	if ([self numberOfSections] > 0) {
		NSInteger section = [self numberOfSections]-1;
		NSInteger rowCount = [self numberOfRowsInSection:section];
		if (rowCount > 0) {
			NSIndexPath* indexPath = [NSIndexPath indexPathForRow:rowCount-1 inSection:section];
			[self scrollToRowAtIndexPath:indexPath
						atScrollPosition:UITableViewScrollPositionBottom animated:NO];
		}
	}
}

@end
