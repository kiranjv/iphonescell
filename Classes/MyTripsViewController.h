//
//  HistoryViewController.h
//  safecell
//
//  Created by shail on 06/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LastTripSection;
@class PastTripsSection;

@interface MyTripsViewController : C1TableViewController {
	LastTripSection *lastTripSection;
	PastTripsSection *pastTripsSection;
	
	NSMutableArray *jouenrys;
	BOOL gameplayStatus;
}

@property(nonatomic, retain) NSMutableArray *jouenrys;
@property(nonatomic, assign) BOOL gameplayStatus;

-(LastTripSection *) lastTripSection;
-(PastTripsSection *) pastTripsSection;

-(void) loadJourneys;
-(void) setupTable;
-(NSMutableArray *) pastTripsArray;

-(void) setUpNavigationBar;

@end
