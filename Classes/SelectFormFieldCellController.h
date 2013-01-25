//
//  SelectFormFieldCellController.h
//  safecell
//
//  Created by Mobisoft Infotech on 8/16/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SelectFormFieldCellController : FormFieldCellController {
	NSMutableArray *options;
	NSString *optionsScreenTitle;
	int selectedIndex;
}

@property (nonatomic, retain) NSMutableArray *options;
@property (nonatomic, retain) NSString *optionsScreenTitle;
@property (nonatomic, assign) int selectedIndex;

@end
