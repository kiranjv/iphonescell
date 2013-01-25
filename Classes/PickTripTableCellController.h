//
//  PickTripTableCellController.h
//  safecell
//
//  Created by shail on 08/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "C1Tables.h"

@class SCTrip;
@class ExistingTripsSection;

@interface PickTripTableCellController : C1RightAlignedInfoCell {
	SCTrip *trip;
	ExistingTripsSection *parentSection;
}

@property (nonatomic, retain) SCTrip *trip;
@property (nonatomic, retain) ExistingTripsSection *parentSection;

- (id) initWithParentSection: (ExistingTripsSection *) existingTripsSection withTrip:(SCTrip *) aTrip;


@end
