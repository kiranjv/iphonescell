//
//  ViewRulesViewController.h
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuleProxy.h"
#import "ProgressHUD.h"

@interface ViewRulesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, RuleProxyDelegate> {
	UITableView *rulesTableView;
	NSMutableArray *activeRules;
	NSMutableArray *inactiveRules;
	UIImage *cellImage;
	NSDateFormatter *dateFormatter;
	RuleProxy *rulesProxy;
	ProgressHUD *progressHUD;
}

@property (nonatomic, retain) NSMutableArray *activeRules;
@property (nonatomic, retain) NSMutableArray *inactiveRules;

@end
