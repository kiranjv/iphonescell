//
//  SelectFormFieldOptionsViewController.h
//  safecell
//
//  Created by Mobisoft Infotech on 8/16/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectFormFieldCellController.h"


@interface SelectFormFieldOptionsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	SelectFormFieldCellController* selectFormFieldCellController;
	UITableView *optionsTableView;
}

@property (nonatomic, assign) SelectFormFieldCellController* selectFormFieldCellController;

@end
