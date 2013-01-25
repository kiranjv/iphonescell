//
//  TripInfoSection.h
//  safecell
//
//  Created by shail on 08/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "C1Tables.h"

@class SCTripJourney;
@class ViewMapCellController;

@interface TripInfoSection : C1TableSection {
	C1RightAlignedInfoCell *milesTravelledCell;
	C1RightAlignedInfoCell *estimatedSpeedCell;
	ViewMapCellController *viewMapCell;
	
	SCTripJourney *journey;
}

@property (nonatomic, retain) SCTripJourney *journey;

-(id) initWithTrip:(SCTripJourney *)journey parentViewController:(UIViewController *)parentViewController;
-(void) addMilesTravelledCell;
-(void) addEstimatedSpeedCell;
-(void) addViewMapCell;

@end
