//
//  ViewMapCell.h
//  safecell
//
//  Created by shail on 08/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCTripJourney.h"

@interface ViewMapCellController : C1DisclosureIndicatorCell {
	SCTripJourney *journey;
}

@property (nonatomic, retain) SCTripJourney *journey;

-(void)routeForPoints;

@end
