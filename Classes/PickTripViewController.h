//
//  PickTripViewController.h
//  safecell
//
//  Created by shail on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ExistingTripsSection;
@class AddTripViewController;

@interface PickTripViewController : C1TableViewController {
	ExistingTripsSection *existingTripsSection;
	AddTripViewController *addTripViewController;
}

@property(nonatomic, retain) AddTripViewController* addTripViewController;

-(id)initWithStyle:(UITableViewStyle)style withAddTripViewController:(AddTripViewController *) parentViewController;

-(void) setupTable;
-(ExistingTripsSection *) existingTripsSection;
-(NSMutableArray *)loadExistingTrips;

@end
