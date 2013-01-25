//
//  SelectFormFieldCellController.m
//  safecell
//
//  Created by Mobisoft Infotech on 8/16/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "SelectFormFieldCellController.h"
#import "SelectFormFieldOptionsViewController.h"

@implementation SelectFormFieldCellController

@synthesize options;
@synthesize optionsScreenTitle;

-(id)initWithField:(TableViewFormField *)field {
	if(self = [super initWithField:field]) {
		selectedIndex = -1;
	}
	
	return self;
}

-(UIButton *) valueButtonForCell:(UITableViewCell *)cell {
	CGRect rect = cell.contentView.bounds;
	rect.origin.x = 90;
	rect.size.width -= 130;
	rect.origin.y += 10;
	rect.size.height -= 20;
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = rect;
	button.enabled = NO;
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	button.titleLabel.adjustsFontSizeToFitWidth = YES;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	button.titleLabel.font = [UIFont systemFontOfSize:17];
	return button;
	
}

-(void) setLabelValue:(NSString *) value {
	if (self.control != nil) {
		UIButton *labelButton = (UIButton *) self.control;
		[labelButton setTitle:value forState:UIControlStateNormal];
	}
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *SelectFormFieldCellIdentifier = [NSString stringWithFormat:@"SelectFormFieldCell%d,%d", indexPath.section, indexPath.row];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectFormFieldCellIdentifier];
	if (cell == nil) {
				
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:SelectFormFieldCellIdentifier] autorelease];
		
		if (!self.control) {
			cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
			
			UIButton *label = [self valueButtonForCell:cell];
			self.control = label;
			
			[cell.contentView addSubview:self.control];
		}
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	}
	
	cell.textLabel.text = _field.label;
	NSLog(@"_field.label : %@", _field.label);
	
	if (self.selectedIndex != -1) {
		[self setLabelValue:[self.options objectAtIndex:self.selectedIndex]];
	}
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	SelectFormFieldOptionsViewController *optionsViewController = [[SelectFormFieldOptionsViewController alloc] init];
	optionsViewController.selectFormFieldCellController = self;
	[self.parentViewController.navigationController pushViewController:optionsViewController animated:YES];
	[optionsViewController release];
}

- (void) dealloc {
	[optionsScreenTitle release];
	[options release];
	[super dealloc];
}

-(int) selectedIndex {
	return selectedIndex;
}

-(void) setSelectedIndex:(int) index {
	if (index > (self.options.count - 1)) {
		return;
	}	
	
	selectedIndex = index;
	[self setLabelValue:[self.options objectAtIndex:self.selectedIndex]];
}


@end
