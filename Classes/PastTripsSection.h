//
//  PastTripsSection.h
//  safecell
//
//  Created by shail on 18/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PastTripsSection : C1TableSection {
	NSMutableArray *pastTrips;
}

@property(nonatomic, retain) NSMutableArray *pastTrips;

-(void) addPastTrips;

@end
