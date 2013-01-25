//
//  LastTripSection.h
//  safecell
//
//  Created by shail on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCTripJourney;
@class TripInfoTableCellController;

@interface LastTripSection : C1TableSection {
	SCTripJourney* recentJourney;
	TripInfoTableCellController *cellController;
}

@property(nonatomic, retain) SCTripJourney* recentJourney;
@property(nonatomic, retain) TripInfoTableCellController *cellController;

- (id) initWithParentController: (UIViewController *) parentController;

@end
