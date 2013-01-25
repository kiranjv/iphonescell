//
//  TripLogViewController.h
//  safecell
//
//  Created by shail on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCTripJourney;
@class TripLogStatsSection;
@class TripLogItemsSection;

@interface TripLogViewController : C1TableViewController {
	SCTripJourney *journey;
	TripLogStatsSection *tripLogStatsSection;
	TripLogItemsSection *tripLogItemsSection;
	
	BOOL gameplayStatus;
}

@property(nonatomic, retain) SCTripJourney *journey;
@property(nonatomic, assign) BOOL gameplayStatus;

-(id)initWithStyle:(UITableViewStyle)style withJourney: (SCTripJourney *) tripJourney;

-(void) setUpNavigationBar;
-(void) setupTable;

-(TripLogStatsSection *) tripLogStatsSection;
-(TripLogItemsSection *) tripLogItemsSection;


@end
