//
//  TripLogItemCell.h
//  safecell
//
//  Created by shail on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "C1Tables.h"

@class SCJourneyEvent;


@interface TripLogItemCellController : NSObject<C1TableCellController> {
	UIViewController *parentViewController;
	
	UIImage *right;
	UIImage *wrong;
	
	UIImage *pointsBackground;
	UIImage *interruptionImage;
}

- (id) initWithParentController: (UIViewController *) parentController;

-(UITableViewCell *) tableView:(UITableView *)tableView regularCellForLogItem: (SCJourneyEvent *) logItem;
-(UITableViewCell *) tableView:(UITableView *)tableView interruptionForLogItem: (SCJourneyEvent *) logItem;

-(UILabel *) titleLabel;
-(UILabel *) descriptionLabel;
-(UIView *) accessoryView: (int) points;

-(UIImageView *) accessoryImageView;
-(UILabel *) pointsValueLabel: (int) points;
-(UILabel *) pointsLabel: (int) points;
-(NSString *) interruptionMessage: (SCJourneyEvent *) interruption;

@end
