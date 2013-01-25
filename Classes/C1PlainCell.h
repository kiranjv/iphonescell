//
//  C1PlainCell.h
//  safecell
//
//  Created by Ben Scheirman on 4/21/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "C1TableCellController.h"

@interface C1PlainCell : NSObject<C1TableCellController> {
	NSString *text;	
	UIViewController *parentViewController;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) UIViewController *parentViewController;

@end
