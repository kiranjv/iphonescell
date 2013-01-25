//
//  SelectFormFieldOptionsViewController.m
//  safecell
//
//  Created by Mobisoft Infotech on 8/16/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "SelectFormFieldOptionsViewController.h"



@implementation SelectFormFieldOptionsViewController

@synthesize selectFormFieldCellController;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
	[self.view addSubview:backgroundView];
	[backgroundView release];
	
	optionsTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	optionsTableView.delegate = self;
	optionsTableView.dataSource = self;
	optionsTableView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:optionsTableView];
	
	self.navigationItem.title = selectFormFieldCellController.optionsScreenTitle;
	NSLog(@" selectFormFieldCellController.optionsScreenTitle : %@",  selectFormFieldCellController.optionsScreenTitle);
	[super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
	[optionsTableView release];
    [super dealloc];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	if(self.selectFormFieldCellController != nil) {
		if (selectFormFieldCellController.options != nil) {
			return selectFormFieldCellController.options.count;
		}
	}
	
	NSLog(@"Warning: SelectFormFieldOptionsViewController needs selectFormFieldCellController with valid options!");
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *SelectFormFieldOptionsCellIdentifier = [NSString stringWithFormat:@"SelectFormFieldOptionsCellIdentifier"];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectFormFieldOptionsCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: SelectFormFieldOptionsCellIdentifier] autorelease];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
	}
	
	int row = [indexPath row];
	
	cell.textLabel.text = [self.selectFormFieldCellController.options objectAtIndex:row];
	
	if (row == self.selectFormFieldCellController.selectedIndex) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	self.selectFormFieldCellController.selectedIndex = [indexPath row];
	[tableView reloadData];
}


@end
