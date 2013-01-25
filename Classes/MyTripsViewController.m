//
//  HistoryViewController.m
//  safecell
//
//  Created by shail on 06/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyTripsViewController.h"
#import "LastTripSection.h"
#import "TripRepository.h"
#import "PastTripsSection.h"
#import "NavBarHelper.h"
#import "ViewSizeHelper.h"
#import "AppSettingsItemRepository.h"

@implementation MyTripsViewController

@synthesize jouenrys;
@synthesize gameplayStatus;

-(void) adjustTableFrame {
	CGRect tableFrame = [ViewSizeHelper potraitBoundsWithStatusBar: YES 
													 navigationBar: YES 
															tabBar: YES 
													locationStripe: YES];
	self.tableView.frame = tableFrame;
}

-(void)loadView {	
	
	self.tableView.backgroundColor = [UIColor whiteColor];
	
	[self setUpNavigationBar];
	
	[self loadJourneys];
	[self setupTable];
	
	[super loadView];
}


-(void) setUpNavigationBar {

	DecorateNavBar(self);
	self.navigationItem.title = @"My Trips";
	
}

-(void) setGameplayStatus {
	AppSettingsItemRepository *appSettingsItemsRepository = [[AppSettingsItemRepository alloc] init];
	gameplayStatus = [appSettingsItemsRepository isGameplayOn];	
	[appSettingsItemsRepository release];
}

- (void)viewWillAppear: (BOOL)animated {
	
	[self setGameplayStatus];
	
	[self loadJourneys];
	
	if([jouenrys count] > 0) {
		lastTripSection.recentJourney = [jouenrys objectAtIndex:0];
	}
	
	if([jouenrys count] > 0) {
		pastTripsSection.pastTrips = [self pastTripsArray];
	}
	
	[lastTripSection reloadData];
	
	[self adjustTableFrame];
}

-(void) setupTable {
	[self addSection:[self lastTripSection]];
	[self addSection:[self pastTripsSection]];
}

-(LastTripSection *) lastTripSection {	
	if(!lastTripSection) {		
		lastTripSection = [[LastTripSection alloc] initWithParentController:self];		
		if([jouenrys count] > 0) {
			lastTripSection.recentJourney  = [jouenrys objectAtIndex:0];
		}
	}
	
	return lastTripSection;
}

-(PastTripsSection *) pastTripsSection {	
	if(!pastTripsSection) {	
		pastTripsSection = [[PastTripsSection alloc] initWithParentController:self];		
	}	
	
	return pastTripsSection;
}

-(void) loadJourneys {
	TripRepository *tripRepository = [[TripRepository alloc] init];
	
	self.jouenrys = [tripRepository journeys];
	
	[tripRepository release];
}

-(NSMutableArray *) pastTripsArray {
	NSMutableArray *pastTrips = [[[NSMutableArray alloc] initWithCapacity:([self.jouenrys count] - 1)] autorelease];
	
	for(int i = 1; i < [self.jouenrys count]; i++ ) {
		SCTripJourney *journey = [self.jouenrys objectAtIndex:i];
		[pastTrips addObject:journey];
	}
	
	return pastTrips;
}

- (void)dealloc {
	[jouenrys release];
    [super dealloc];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)i {
	C1TableSection *section = [_sections objectAtIndex:i];
	
	return section.rows.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {	
	int noOfJourneys = [jouenrys count];
	
	if(noOfJourneys <= 1) {
		return 1;
	} else {
		return 2;
	}
}


@end
