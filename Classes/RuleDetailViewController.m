//
//  RuleDetailViewController.m
//  safecell
//
//  Created by shail m on 6/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RuleDetailViewController.h"
#import "UIUtils.h"
#import "RectHelper.h"


@implementation RuleDetailViewController

@synthesize titleLabel;	
@synthesize secondaryTitleLabel;

@synthesize groupsAffectedTitle;
@synthesize affectedGroupsLabelsArray;
@synthesize rule;

@synthesize primaryRuleLabel;
@synthesize primaryRuleDescriptionLabel;
@synthesize primaryRuleCheckmark;

@synthesize crashCollectionLabel;
@synthesize crashCollectionDescriptionLabel;
@synthesize crashCollectionCheckmark;

@synthesize preemptionLabel;
@synthesize preemptionCheckmark;	

@synthesize whenEnforcedLabel;
@synthesize whenEnforcedDescriptionLabel;

@synthesize detailTitleLabel;
@synthesize detailTextLabel;
@synthesize scrollView;

-(void) createCheckBoxImages {
	checked = [[UIImage imageNamed:@"checked_checkbox.png"] retain];
	unchecked = [[UIImage imageNamed:@"empty_checkbox.png"] retain];
}

- (void)configureGroupsAffectedTitleLabel {
	
	UILabel *referenceLabel = whenEnforcedLabel;
	
	if (whenEnforcedLabel.hidden == YES) {
		referenceLabel = preemptionLabel;
	}
	
	CGRect groupsAffectedTitleLabelFrame = groupsAffectedTitle.frame;
	groupsAffectedTitleLabelFrame.origin.y = referenceLabel.frame.origin.y + referenceLabel.frame.size.height  + 7;
	groupsAffectedTitle.frame = groupsAffectedTitleLabelFrame;
}

- (UILabel *)allDriversLabel {
	CGRect groupsAffectedTitleLabelFrame = groupsAffectedTitle.frame;
	CGRect labelFrame = CGRectMake(groupsAffectedTitleLabelFrame.origin.x, 
								   groupsAffectedTitleLabelFrame.origin.y + groupsAffectedTitleLabelFrame.size.height + 5, 
								   groupsAffectedTitleLabelFrame.size.width, 
								   groupsAffectedTitleLabelFrame.size.height);
	
	UILabel *label = [[[UILabel alloc] initWithFrame:labelFrame] autorelease];
	label.text = ALL_LICENSE_CLASSES_DISPLAY_TEXT;
	label.font = [UIFont systemFontOfSize:12];
	return label;
}

- (void)addAffectedGroupsLabels {
	affectedGroupsLabelsArray = [[NSMutableArray alloc] init];
	
	if ([rule.licenses isEqualToString:ALL_LICENSE_CLASSES]) {
		[affectedGroupsLabelsArray addObject:[self allDriversLabel]];
		NSLog(@"added all rule");
	} else {
		
		CGRect groupsAffectedTitleLabelFrame = groupsAffectedTitle.frame;
		
		float x = groupsAffectedTitleLabelFrame.origin.x;
		float y = groupsAffectedTitleLabelFrame.origin.y + groupsAffectedTitleLabelFrame.size.height + 5;
		float width = groupsAffectedTitleLabelFrame.size.width;
		float height = groupsAffectedTitleLabelFrame.size.height;
		
		NSArray *licenseClassNames = [rule licenseClassNames];
		
		for (int i = 0; i < licenseClassNames.count; i++) {
			UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)] autorelease];
			label.text = [licenseClassNames objectAtIndex:i];
			label.font = [UIFont systemFontOfSize:12];
			y += height;
			[affectedGroupsLabelsArray addObject:label];
		}
	}
	
	int totalAffectedGroupsLabels = [self.affectedGroupsLabelsArray count];
	
	if (totalAffectedGroupsLabels > 0) {
		for (UILabel *label in self.affectedGroupsLabelsArray) {
			[self.scrollView addSubview:label];
		}
		
		UILabel *lastLabel = [self.affectedGroupsLabelsArray objectAtIndex:totalAffectedGroupsLabels - 1];
		affectedGroupsEndYCoordinate = lastLabel.frame.origin.y + lastLabel.frame.size.height;
	} else {
		self.groupsAffectedTitle.hidden = YES;
		affectedGroupsEndYCoordinate = self.whenEnforcedDescriptionLabel.frame.origin.y + self.whenEnforcedDescriptionLabel.frame.size.height;
	}
}

-(void) configureTitleLabels {
	self.navigationItem.title = @"Rule Detail";
	self.titleLabel.text = rule.label;
	
	NSString *secondaryTitleText = [NSString stringWithFormat:@"%@ usage banned in %@", [rule ruleTypeTextForDisplay], rule.zoneName];
	
	float textHeight = [UIUtils heightOfText:secondaryTitleText 
								   withWidth:secondaryTitleLabel.frame.size.width 
										font:self.secondaryTitleLabel.font 
							   lineBreakMode:UILineBreakModeWordWrap];
	
	CGRect secondaryTitleLabelFrame = self.secondaryTitleLabel.frame;
	secondaryTitleLabelFrame.size.height = textHeight;
	self.secondaryTitleLabel.frame = secondaryTitleLabelFrame;
	
	self.secondaryTitleLabel.text = secondaryTitleText;	
}

-(void) configurePrimaryRuleLabels {
	CGRect referenceLabelFrame = self.secondaryTitleLabel.frame;
	
	CGRect primaryRuleLabelFrame = self.primaryRuleLabel.frame;
	primaryRuleLabelFrame.origin.y = referenceLabelFrame.origin.y + referenceLabelFrame.size.height + 7;
	self.primaryRuleLabel.frame = primaryRuleLabelFrame;
	
	CGRect checkMarkImageFrame = self.primaryRuleCheckmark.frame;
	checkMarkImageFrame.origin.y = primaryRuleLabelFrame.origin.y + 3;
	self.primaryRuleCheckmark.frame = checkMarkImageFrame;
	
	if (self.rule.primary) {
		self.primaryRuleLabel.text = @"Primary Rule";
		self.primaryRuleDescriptionLabel.text = @"You can be pulled over and issued a ticket for the violation of this rule.";
	} else {
		self.primaryRuleLabel.text = @"Secondary Rule";
		self.primaryRuleDescriptionLabel.text = @"You can be issued a ticket but only in combination of other moving violation of a speeding law.";
	}	
	
	referenceLabelFrame = self.primaryRuleLabel.frame;
	
	CGRect descriptionLabelFrame = self.primaryRuleDescriptionLabel.frame;
	descriptionLabelFrame.origin.y = referenceLabelFrame.origin.y + referenceLabelFrame.size.height + 7;
	float textHeight = [UIUtils heightOfText:self.primaryRuleDescriptionLabel.text withWidth:descriptionLabelFrame.size.width font:self.primaryRuleDescriptionLabel.font lineBreakMode:UILineBreakModeWordWrap];
	descriptionLabelFrame.size.height = textHeight;
	self.primaryRuleDescriptionLabel.frame = descriptionLabelFrame;
}

-(void) configureCrashCollectionLabels {
	if (rule.crashCollection) {
		self.crashCollectionCheckmark.image = checked;
	} else {
		self.crashCollectionCheckmark.image = unchecked;
	}
	
	CGRect referenceLabelFrame = self.primaryRuleDescriptionLabel.frame;
	
	CGRect mainLabelFrame = self.crashCollectionLabel.frame;
	mainLabelFrame.origin.y = referenceLabelFrame.origin.y + referenceLabelFrame.size.height + 7;
	self.crashCollectionLabel.frame = mainLabelFrame;
	
	CGRect descriptionLabelFrame = self.crashCollectionDescriptionLabel.frame;
	descriptionLabelFrame.origin.y = mainLabelFrame.origin.y + mainLabelFrame.size.height;
	self.crashCollectionDescriptionLabel.frame = descriptionLabelFrame;
	
	CGRect checkMarkImageFrame = self.crashCollectionCheckmark.frame;
	checkMarkImageFrame.origin.y = mainLabelFrame.origin.y + 3;
	self.crashCollectionCheckmark.frame = checkMarkImageFrame;
}

-(void) configurePreemptionLabels {
	if (rule.preemption) {
		self.preemptionCheckmark.image = checked;
	} else {
		self.preemptionCheckmark.image = unchecked;
	}
	
	CGRect referenceLabelFrame = self.crashCollectionDescriptionLabel.frame;
	
	CGRect mainLabelFrame = self.preemptionLabel.frame;
	mainLabelFrame.origin.y = referenceLabelFrame.origin.y + referenceLabelFrame.size.height + 7;
	self.preemptionLabel.frame = mainLabelFrame;
	
	CGRect checkMarkImageFrame = self.preemptionCheckmark.frame;
	checkMarkImageFrame.origin.y = mainLabelFrame.origin.y + 3;
	self.preemptionCheckmark.frame = checkMarkImageFrame;
}

-(void) configureWhenEnforcedLabels {
	if (rule.whenEnforced == nil) {
		self.whenEnforcedLabel.hidden = YES;
		self.whenEnforcedDescriptionLabel.hidden = YES;
	} else {
		self.whenEnforcedDescriptionLabel.text = [rule whenEnforcedForDisplay];
		
		CGRect referenceLabelFrame = self.preemptionLabel.frame;
		
		CGRect mainLabelFrame = self.whenEnforcedLabel.frame;
		mainLabelFrame.origin.y = referenceLabelFrame.origin.y + referenceLabelFrame.size.height + 7;
		self.whenEnforcedLabel.frame = mainLabelFrame;
		
		CGRect descriptionLabelFrame = self.whenEnforcedDescriptionLabel.frame;
		descriptionLabelFrame.origin.y = mainLabelFrame.origin.y;
		self.whenEnforcedDescriptionLabel.frame = descriptionLabelFrame;
	}
}


-(void) configureRuleDetailLabels {
	CGRect mainLabelFrame = self.detailTitleLabel.frame;
	mainLabelFrame.origin.y = affectedGroupsEndYCoordinate + 7;
	self.detailTitleLabel.frame = mainLabelFrame;
	
	CGRect descriptionLabelFrame = self.detailTextLabel.frame;
	self.detailTextLabel.text = self.rule.detail;
	
	float textHeight = [UIUtils heightOfText:self.detailTextLabel.text withWidth:descriptionLabelFrame.size.width font:self.detailTextLabel.font lineBreakMode:UILineBreakModeWordWrap];
	
	descriptionLabelFrame.origin.y = mainLabelFrame.origin.y + mainLabelFrame.size.height + 2;
	descriptionLabelFrame.size.height = textHeight;
	self.detailTextLabel.frame = descriptionLabelFrame;
}

- (void) configureScrollView {
	LogRect(@"description: ", self.detailTextLabel.frame);
	float detailTextLabelEnd = self.detailTextLabel.frame.origin.y + self.detailTextLabel.frame.size.height;
	scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width, detailTextLabelEnd + 5);
	LogRect(@"scrollView:", scrollView.frame);
	NSLog(@"%f, %f", scrollView.contentSize.width, scrollView.contentSize.height);
}

#pragma mark -
#pragma mark View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self configureTitleLabels];
	[self createCheckBoxImages];
	[self configurePrimaryRuleLabels];
	[self configureCrashCollectionLabels];
	[self configurePreemptionLabels];
	[self configureWhenEnforcedLabels];
	
	[self configureGroupsAffectedTitleLabel];
	[self addAffectedGroupsLabels];
	[self configureRuleDetailLabels];
	[self configureScrollView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
	self.titleLabel = nil;
	self.secondaryTitleLabel = nil;
	
	self.groupsAffectedTitle = nil;
	self.affectedGroupsLabelsArray = nil;
	
	self.primaryRuleLabel = nil;
	self.primaryRuleDescriptionLabel = nil;
	self.primaryRuleCheckmark = nil;
	
	self.crashCollectionLabel = nil;
	self.crashCollectionDescriptionLabel = nil;
	self.crashCollectionCheckmark = nil;
	
	self.preemptionLabel = nil;
	self.preemptionCheckmark = nil;
	
	self.whenEnforcedLabel = nil;
	self.whenEnforcedDescriptionLabel = nil;
	
	self.detailTitleLabel = nil;
	self.detailTextLabel = nil;
	self.scrollView = nil;
}

#pragma mark -
#pragma mark Clean Up

- (void)dealloc {
	[checked release];
	[unchecked release];
	
	[dateFormatter release];
	[titleLabel release];
	[secondaryTitleLabel release];

	
	[groupsAffectedTitle release];
	[affectedGroupsLabelsArray release];
	
	[primaryRuleLabel release];
	[primaryRuleDescriptionLabel release];
	[primaryRuleCheckmark release];
	
	[crashCollectionLabel release];
	[crashCollectionDescriptionLabel release];
	[crashCollectionCheckmark release];
	
	[preemptionLabel release];
	[preemptionCheckmark release];	
	
	[whenEnforcedLabel release];
	[whenEnforcedDescriptionLabel release];
	
	[detailTitleLabel release];
	[detailTextLabel release];
	[scrollView release];
	
	[rule release];	
    [super dealloc];
}


@end
