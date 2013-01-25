//
//  SettingsCellController.m
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsItemCellController.h"
#import "SettingsItem.h"

@implementation SettingsItemCellController

@synthesize settingsItem;

- (id) initWithParentController: (UIViewController *) parentController settingsItem: (SettingsItem *) item {
	self = [super init];
	if (self != nil) {
		self.parentViewController = parentController;
		self.settingsItem = item;
	}
	return self;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *identifier = @"SettingsItemCellController";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if(cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		[cell autorelease];
	}
	
	cell.textLabel.text = self.settingsItem.title;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
	cell.imageView.image = self.settingsItem.image;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;	
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];	
	
	UIViewController *viewController = [[NSClassFromString(self.settingsItem.controllerClassName) alloc] init];	
	[self.parentViewController.navigationController pushViewController:viewController animated:YES];
	[viewController release];
}


- (void) dealloc {
	[settingsItem release];
	[super dealloc];
}


@end
