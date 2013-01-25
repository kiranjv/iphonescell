//
//  C1RightAlignedInfoCell.m
//  safecell
//
//  Created by shail on 08/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "C1RightAlignedInfoCell.h"

@implementation C1RightAlignedInfoCell

@synthesize label;
@synthesize info;
@synthesize cellSelectionAllowed;
@synthesize showDiscloserIndicator;

- (id) initWithLabel:(NSString *) labelStr info: (NSString *) infoStr {
	self = [super init];
	if (self != nil) {		
		self.label = labelStr;
		self.info = infoStr;		
	}
	return self;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *identifier = @"RightAlignedInfoCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if(cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
		[cell autorelease];
	}
	
	cell.textLabel.text = label;
	cell.detailTextLabel.text = info;
	
	if(!cellSelectionAllowed) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	if(showDiscloserIndicator) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	return cell;
}


- (void) dealloc {
	[label release];
	[info release];
	[super dealloc];
}

@end
