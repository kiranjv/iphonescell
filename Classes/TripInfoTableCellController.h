//
//  TripInfoTableCellController.h
//  safecell
//
//  Created by shail on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCTripJourney;

@interface TripInfoTableCellController : C1RightAlignedInfoCell {
	SCTripJourney* journey;
}

@property(nonatomic, retain) SCTripJourney* journey;

- (id) initWithJourney: (SCTripJourney *) aJourney;

@end
