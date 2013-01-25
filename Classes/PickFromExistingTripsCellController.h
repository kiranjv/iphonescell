//
//  PickFromExistingTripsCellController.h
//  safecell
//
//  Created by shail on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PickTripViewController;

@interface PickFromExistingTripsCellController : C1DisclosureIndicatorCell {
	PickTripViewController* pickTripViewController;
}

@property (nonatomic, retain) PickTripViewController* pickTripViewController;

@end
