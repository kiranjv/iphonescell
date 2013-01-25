//
//  SBCheckPointViewController.h
//  AdsAroundMe
//
//  Created by Adodis on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SBCheckPointViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{

	IBOutlet UITableView *mTable;
	NSMutableArray *mCheckPoints;
}
@property (nonatomic,retain) UITableView *mTable;
@property (nonatomic,retain) NSMutableArray *mCheckPoints;

@end
