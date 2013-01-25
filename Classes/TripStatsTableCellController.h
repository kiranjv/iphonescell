//
//  TripStatsCellController.h
//  safecell
//
//  Created by shail on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripStatsTableCellController : NSObject<C1TableCellController> {
	UIViewController *parentViewController;
}



- (id) initWithParentController: (UIViewController *) parentController;

@end
