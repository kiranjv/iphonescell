//
//  TripInfoTableCellController.m
//  safecell
//
//  Created by shail on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TripInfoTableCellController.h"
#import "SCTripJourney.h"
#import "TripInfoTableCell.h"
#import "TripLogViewController.h"
#import "AppSettingsItemRepository.h"

@implementation TripInfoTableCellController

@synthesize journey;

- (id) initWithJourney: (SCTripJourney *) aJourney {
	self = [super init];
	if (self != nil) {
		self.journey = aJourney;
	}
	return self;
}

-(BOOL) gameplayStaus {
	AppSettingsItemRepository *repository = [[AppSettingsItemRepository alloc] init];	
	BOOL gameplayStatus = [repository isGameplayOn];
	[repository release];
	
	return gameplayStatus;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if(journey) {
		static NSString *strCellIdentifier = @"TripInfoTableCell";  
		
		TripInfoTableCell *tripInfoTableCell = (TripInfoTableCell*)[tableView dequeueReusableCellWithIdentifier:strCellIdentifier];  
		
		if (tripInfoTableCell == nil) {			
			tripInfoTableCell = [[[TripInfoTableCell alloc] 
								  initWithStyle:UITableViewCellStyleDefault 
								  reuseIdentifier:strCellIdentifier] autorelease];			
		}
		
		tripInfoTableCell.tripObject = journey; 	

		tripInfoTableCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;		
		
		BOOL gameplayStatus = [self gameplayStaus];
		
		if (gameplayStatus) {
			[tripInfoTableCell showPoints];
		} else {
			[tripInfoTableCell hidePoints];
		}

		return tripInfoTableCell;
	} else {
	
		UITableViewCell *cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault 
				 reuseIdentifier:@"UITableViewCell"] autorelease];	
		
		cell.textLabel.text = @"You haven't taken any trips yet.";
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		CGRect textLabelFrame = CGRectMake(0, 0, 320, 43);
		cell.textLabel.frame = textLabelFrame;
		
		cell.backgroundView = [[[UIView alloc] initWithFrame:cell.bounds] autorelease];
		cell.backgroundView.backgroundColor = [UIColor whiteColor];

		
		return cell;
	}

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];	
	
	TripLogViewController *tripLogViewController = [[TripLogViewController alloc] initWithStyle:UITableViewStylePlain withJourney:self.journey];
	[parentViewController.navigationController pushViewController:tripLogViewController animated:YES];
	[tripLogViewController release];
}


- (void) dealloc {
	[journey release];
	[super dealloc];
}


@end
