//
//  NewTripCellController.h
//  safecell
//
//  Created by shail on 08/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SaveTripSection;

@interface NewTripCellController : C1RightAlignedInfoCell<UIAlertViewDelegate> {
	SaveTripSection *saveTripSection;
}

@property(nonatomic, retain) SaveTripSection *saveTripSection;

@end