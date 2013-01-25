//
//  RuleDetailViewController.h
//  safecell
//
//  Created by shail m on 6/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCRule.h"

@interface RuleDetailViewController : UIViewController {
	UILabel *titleLabel;	
	UILabel *secondaryTitleLabel;
	
	UILabel *groupsAffectedTitle;
	NSMutableArray *affectedGroupsLabelsArray;
	
	SCRule *rule;
	
	NSDateFormatter *dateFormatter;
	
	UILabel *primaryRuleLabel;
	UILabel *primaryRuleDescriptionLabel;
	UIImageView *primaryRuleCheckmark;
	
	UILabel *crashCollectionLabel;
	UILabel *crashCollectionDescriptionLabel;
	UIImageView *crashCollectionCheckmark;
	
	UILabel *preemptionLabel;
	UIImageView *preemptionCheckmark;	
	
	UILabel *whenEnforcedLabel;
	UILabel *whenEnforcedDescriptionLabel;	
	
	UIImage *checked;
	UIImage *unchecked;
	
	UILabel *detailTitleLabel;
	UILabel *detailTextLabel;
	UIScrollView *scrollView;
	
	float affectedGroupsEndYCoordinate;
}

@property(nonatomic, retain) IBOutlet UILabel *titleLabel;	
@property(nonatomic, retain) IBOutlet UILabel *secondaryTitleLabel;

@property(nonatomic, retain) IBOutlet UILabel *groupsAffectedTitle;
@property(nonatomic, retain) NSMutableArray *affectedGroupsLabelsArray;


@property(nonatomic, retain) SCRule *rule;


@property(nonatomic, retain) IBOutlet UILabel *primaryRuleLabel;
@property(nonatomic, retain) IBOutlet UILabel *primaryRuleDescriptionLabel;
@property(nonatomic, retain) IBOutlet UIImageView *primaryRuleCheckmark;

@property(nonatomic, retain) IBOutlet UILabel *crashCollectionLabel;
@property(nonatomic, retain) IBOutlet UILabel *crashCollectionDescriptionLabel;
@property(nonatomic, retain) IBOutlet UIImageView *crashCollectionCheckmark;

@property(nonatomic, retain) IBOutlet UILabel *preemptionLabel;
@property(nonatomic, retain) IBOutlet UIImageView *preemptionCheckmark;	

@property(nonatomic, retain) IBOutlet UILabel *whenEnforcedLabel;
@property(nonatomic, retain) IBOutlet UILabel *whenEnforcedDescriptionLabel;

@property(nonatomic, retain) IBOutlet UILabel *detailTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel *detailTextLabel;

@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;

@end
