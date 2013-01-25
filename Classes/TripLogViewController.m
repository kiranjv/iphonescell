//
//  TripLogViewController.m
//  safecell
//
//  Created by shail on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TripLogViewController.h"
#import "SCTripJourney.h"
#import "NavBarHelper.h"
#import "SCJourneyEvent.h"
#import "TripLogStatsSection.h"
#import "SCJourneyEvent.h"
#import "TripLogItemsSection.h"
#import "ViewSizeHelper.h"
#import "RectHelper.h"
#import "AppSettingsItemRepository.h"

@implementation TripLogViewController

@synthesize journey;
@synthesize gameplayStatus;

-(void) adjustTableFrame {
	CGRect tableFrame = [ViewSizeHelper potraitBoundsWithStatusBar: YES 
													 navigationBar: YES 
															tabBar: YES 
													locationStripe: YES];
	
	self.tableView.frame = tableFrame;
	LogRect(@"tableFrame", tableFrame);
}

-(void) setGameplayStatus {
	AppSettingsItemRepository *appSettingsItemsRepository = [[AppSettingsItemRepository alloc] init];
	gameplayStatus = [appSettingsItemsRepository isGameplayOn];	
	[appSettingsItemsRepository release];
}

- (void)viewWillAppear: (BOOL)animated {	
	[self adjustTableFrame];
	[self setGameplayStatus];
	[self.tableView reloadData];
}

-(id)initWithStyle:(UITableViewStyle)style withJourney: (SCTripJourney *) tripJourney {
	self = [super initWithStyle:style];
	if (self != nil) {		
		reactToKeyboard = NO;
		
		self.journey = tripJourney;	
		
		[self setUpNavigationBar];
		
		[self setupTable];		
	}
	return self;
}

-(void) setUpNavigationBar {
	DecorateNavBar(self);
	self.navigationItem.title = @"Trip History";
}

-(void) setupTable {
	[self addSection:[self tripLogStatsSection]];
	[self addSection:[self tripLogItemsSection]];
}

- (void)dealloc {
	[journey release];
    [super dealloc];
}

-(TripLogStatsSection *) tripLogStatsSection {
	if(!tripLogStatsSection) {		
		tripLogStatsSection = [[TripLogStatsSection alloc] initWithParentController:self];
	}
	
	return tripLogStatsSection;
}

-(TripLogItemsSection *) tripLogItemsSection {
	if(!tripLogItemsSection) {		
		tripLogItemsSection = [[TripLogItemsSection alloc] initWithParentController:self];
	}
	
	return tripLogItemsSection;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if([indexPath section] == 0) {
		return 88;
	} else {
				
		int height = 41;
		
		int row = [indexPath row];
		
		if(self.journey && self.journey.journeyEvents) {
			if(row < [self.journey.journeyEvents count]) {
				SCJourneyEvent * item = [self.journey.journeyEvents objectAtIndex:row];
				height = item.isInterruption ? 43 : 41;
			}
		}
			   
		return height;
	}
}


@end
