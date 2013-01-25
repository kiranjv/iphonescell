//
//  C1TableCell.h
//  safecell
//
//  Created by Ben Scheirman on 5/11/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "C1TableCellController.h"

@interface C1TableCell : NSObject<C1TableCellController> {
	UIViewController *parentViewController;
}

@property (nonatomic, assign) UIViewController *parentViewController;

@end
