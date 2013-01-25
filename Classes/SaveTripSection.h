//
//  NewTripSection.h
//  safecell
//
//  Created by shail on 08/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "C1Tables.h"

@class NewTripCellController;
@class PickFromExistingTripsCellController;

@interface SaveTripSection : C1TableSection  {
	NewTripCellController *newTripCell;
	PickFromExistingTripsCellController *pickFromExistingTripsCell;
}

-(void) addNewTripCell;
-(void) addPickFromExistingTripsCell;

-(void) setNewTripTitle:(NSString *) title;
-(NSString *) tripTitle;
-(int) totalNoOfTrips;
-(NSString *) defaultTripTitleText;

@end
