//
//  ExistingTripsSection.h
//  safecell
//
//  Created by shail on 08/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AddTripViewController;

@interface ExistingTripsSection : C1TableSection {
	NSMutableArray *trips;
	AddTripViewController *addTripViewController;
}

@property(nonatomic, retain) NSMutableArray *trips;
@property(nonatomic, retain) AddTripViewController *addTripViewController;

- (id) initWithTrips: (NSMutableArray *) tripsArr withAddTripViewController: (AddTripViewController *) theAddTripViewController;
-(void) addTripRows;

@end
