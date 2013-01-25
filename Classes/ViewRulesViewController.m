//
//  ViewRulesViewController.m
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "ViewRulesViewController.h"
#import "RuleProxy.h"
#import "RuleRepository.h"
#import "UIUtils.h"
#import "AppDelegate.h"
#import "LocationHelper.h"
#import "RulesDownloadManager.h"
#import "LocationStripeController.h"
#import "AlertHelper.h"
#import "HeaderWithCenteredTitleForSection.h"
#import "ViewSizeHelper.h"
#import "RuleDetailViewController.h"
#import "UIUtils.h"
#import "UITableViewAdditions.h"

#define kDateLabelTag 4563
#define kZoneLabelTag 4564
#define kDetailLabelTag 4565
#define kTitleLabelTag 4566
#define kImageViewTag  4567

@implementation ViewRulesViewController

@synthesize activeRules;
@synthesize inactiveRules;


-(void) addRulesTable {
	CGRect tableFrame = [ViewSizeHelper potraitBoundsWithStatusBar: YES 
													 navigationBar: YES 
															tabBar: YES 
													locationStripe: YES];
	
	rulesTableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
	rulesTableView.delegate = self;
	rulesTableView.dataSource = self;
	rulesTableView.backgroundColor = [UIColor clearColor];
	
	[self.view addSubview:rulesTableView];
}

-(void) showHUD {
	if (progressHUD == nil) {
		progressHUD = [[ProgressHUD alloc] init];
	}
	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[progressHUD showHUDWithLable:@"Loading Rules" inView:appDelegate.window];
}

-(void) hideHUD {
	[progressHUD hideHUD];
}

-(void) configureRuleProxy {
	rulesProxy = [[RuleProxy alloc] init];
	rulesProxy.delegate = self;
}

-(void) addBackgroundImage {
	UIImageView *imageView = [[UIImageView alloc] initWithFrame: self.view.bounds];
	imageView.image = [UIImage imageNamed:@"background.png"];
	[self.view addSubview:imageView];
	[imageView release];
}

-(void) createContents {
	DecorateNavBar(self);
	self.navigationItem.title = @"Rules";
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
											   target:self action:@selector(refreshRules)] autorelease];
	[self configureRuleProxy];
	[self addBackgroundImage];
	[self addRulesTable];
}

-(void) loadRules {
	RuleRepository *ruleRepository = [[RuleRepository alloc] init];
	self.activeRules = [ruleRepository activeRules];	
	self.inactiveRules = [ruleRepository inactiveRules];
	[ruleRepository release];
}

-(void) startRulesDownload {	
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	CLLocation *lastKnownLocation = appDelegate.locationHelper.lastKnownLocation;
	
	if (lastKnownLocation == nil) {
		// NSLog(@"Location not resolved yet. Will try again after 1 second...");
		//[self performSelector:@selector(startRulesDownload) withObject:nil afterDelay:1.0];
		
		SimpleAlertOK(@"Location Information Not Available", @"Your location has not resolved as of yet. You can refresh the rules in a few seconds.");
		
		return;
	}
	
	[self showHUD];
	CLLocationCoordinate2D locationCordinate = lastKnownLocation.coordinate;
	[rulesProxy downloadRulesForLatitude:locationCordinate.latitude longidute:locationCordinate.longitude distance: kRulesUpdateRadius];
	
	//[rulesProxy downloadRulesForLatitude:21.3282000000 longidute:-157.8768450000 distance: kRulesUpdateRadius];
}

#pragma mark -
#pragma mark view lifecycle

-(void)loadView {
	[super loadView];
	
	[self loadRules];
	[self createContents];
	cellImage = [UIImage imageNamed:@"view_rules_icon.png"];
	dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/yy"];
}

-(void) viewWillAppear: (BOOL)animated {
	if ( ([self.activeRules count] == 0) 
		&& 
		([self.inactiveRules count] == 0) ) {		
		[self startRulesDownload];		
	}
}
	
-(void)viewDidLoad {
	DecorateNavBar(self);
}

- (void)dealloc {
	[dateFormatter release];
	[cellImage release];
	[activeRules release];
	[inactiveRules release];
	[rulesTableView release];
	[rulesProxy release];
	[progressHUD release];
    [super dealloc];
}

-(UITableViewCell *) noRulesCell {
	
	static NSString *strCellIdentifier = @"NoRulesTableCell";  
	
	UITableViewCell *cell = [rulesTableView dequeueReusableCellWithIdentifier:strCellIdentifier];  
	
	if (cell == nil) {		
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCellIdentifier] autorelease];	
		cell.textLabel.text = @"No rules are applicable for this area.";
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		CGRect textLabelFrame = cell.bounds;
		cell.textLabel.frame = textLabelFrame;
		
		cell.backgroundView = [[[UIView alloc] initWithFrame:cell.bounds] autorelease];
		cell.backgroundView.backgroundColor = [UIColor whiteColor];
	}
	
	return cell;
}

-(void) addImageViewForCell: (UITableViewCell *) cell {
	UIImageView *imageView = (UIImageView *)[cell viewWithTag:kImageViewTag];
	
	if (imageView == nil) {
		CGRect frame = CGRectMake(10, 5, 30, 30);
		imageView = [[[UIImageView alloc] initWithFrame:frame] autorelease];		
		
		[cell addSubview:imageView];
	}
	
	imageView.image = cellImage;
}

// This label was removed for this version because for this version it has no 
// meaning. 
//-(void) addDateLabelInCell: (UITableViewCell *) cell text: (NSString *) text {
//	UILabel *dateLabel = (UILabel *)[cell viewWithTag:kDateLabelTag];
//	
//	if(dateLabel == nil) {
//		CGRect frame = CGRectMake(240, 5, 60, 12);
//		dateLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
//		dateLabel.font = [UIFont systemFontOfSize:12];
//		dateLabel.textColor = [UIUtils colorFromHexColor:@"666666"];
//		dateLabel.backgroundColor = [UIColor clearColor];
//		dateLabel.tag = kDateLabelTag;
//		
//		[cell addSubview:dateLabel];
//	}
//	
//	dateLabel.text = text;
//}

-(void) addZoneLabelInCell: (UITableViewCell *) cell text: (NSString *) text {
	UILabel *zoneLabel = (UILabel *)[cell viewWithTag:kZoneLabelTag];
	
	if(zoneLabel == nil) {
		CGRect frame = CGRectMake(240, 5, 60, 12);
		zoneLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
		zoneLabel.font = [UIFont systemFontOfSize:12];
		zoneLabel.textColor = [UIUtils colorFromHexColor:@"7F9FC0"];
		zoneLabel.backgroundColor = [UIColor clearColor];
		zoneLabel.tag = kZoneLabelTag;
		
		[cell addSubview:zoneLabel];
	}
	
	zoneLabel.text = text;
}

-(void) addDetailLabelInCell: (UITableViewCell *) cell text: (NSString *) text {
	UILabel *detailLabel = (UILabel *)[cell viewWithTag:kDetailLabelTag];
	
	if(detailLabel == nil) {
		CGRect frame = CGRectMake(50, 23, 190, 42);
		detailLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
		detailLabel.font = [UIFont systemFontOfSize:12];
		detailLabel.textColor = [UIUtils colorFromHexColor:@"7F9FC0"];
		detailLabel.backgroundColor = [UIColor clearColor];
		detailLabel.tag = kDetailLabelTag;
		detailLabel.numberOfLines = 0;
		detailLabel.lineBreakMode = UILineBreakModeWordWrap;
		
		[cell addSubview:detailLabel];
	}
	
	detailLabel.text = text;
	float detailLabelTextHeight = [UIUtils heightOfText:detailLabel.text withWidth:detailLabel.frame.size.width font:detailLabel.font lineBreakMode:UILineBreakModeWordWrap];
	CGRect frame = detailLabel.frame;
	frame.size.height = detailLabelTextHeight;
	detailLabel.frame = frame;
}

-(void) addTitleLabelInCell: (UITableViewCell *) cell text: (NSString *) text {
	UILabel *titleLabel = (UILabel *)[cell viewWithTag:kTitleLabelTag];
	
	if(titleLabel == nil) {
		CGRect frame = CGRectMake(50, 5, 190, 12);
		titleLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
		titleLabel.font = [UIFont boldSystemFontOfSize:12];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.tag = kTitleLabelTag;
		
		[cell addSubview:titleLabel];
	}
	
	titleLabel.text = text;
}

-(UITableViewCell *) cellForRowAtIndexPath: (NSIndexPath *) indexPath {
	static NSString *strCellIdentifier = @"RulesTableCell";  
	
	UITableViewCell *cell = [rulesTableView dequeueReusableCellWithIdentifier:strCellIdentifier];  
	
	if (cell == nil) {		
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strCellIdentifier] autorelease];	
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.backgroundView = [[[UIView alloc] initWithFrame:cell.bounds] autorelease];
		cell.backgroundView.backgroundColor = [UIColor whiteColor];
	}
		
	SCRule *rule = nil;
	
	if ([indexPath section] == 0) {
		rule = [activeRules objectAtIndex: [indexPath row]];
		cell.textLabel.textColor = [UIUtils colorFromHexColor:@"000000"];
	} else {
		rule = [inactiveRules objectAtIndex: [indexPath row]];
		cell.textLabel.textColor = [UIUtils colorFromHexColor:@"666666"];
	}
	
	
	[self addImageViewForCell:cell];
	[self addTitleLabelInCell:cell text:rule.label];
	[self addDetailLabelInCell:cell text:[rule ruleDescription]];	
	[self addZoneLabelInCell:cell text:[rule zoneNameForDisplay]];
	
	return cell;
}

#pragma mark -
#pragma mark Actions

-(void) refreshRules {
	[self startRulesDownload];
}

#pragma mark -
#pragma mark UITableViewDataSource 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return ([inactiveRules count] > 0) ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	int count = 0;
	switch (section) {
		case 0:
			count = [activeRules count] > 0 ? [activeRules count] : 1;
			break;
		case 1:
			count = [inactiveRules count];
			break;
	}	
	
	return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	int section = [indexPath section];
	
	UITableViewCell *cell = nil;
	
	switch (section) {
		case 0:
		{
			if ([activeRules count] == 0) {
				cell = [self noRulesCell];
			} else {
				cell = [self cellForRowAtIndexPath:indexPath];
			}	
			break;
		}
		case 1:
			cell = [self cellForRowAtIndexPath:indexPath];
			break;
	}	
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	int section = [indexPath section];
	SCRule *rule = nil;

	switch (section) {
		case 0:
		{
			if ([activeRules count] == 0) {
				rule = nil;
			} else {
				rule = [activeRules objectAtIndex: [indexPath row]];
			}	
			break;
		}
		case 1:
			rule = [inactiveRules objectAtIndex: [indexPath row]];
			break;
	}	
	
	if (rule != nil) {
		RuleDetailViewController *ruleDetailViewController = [[RuleDetailViewController alloc] initWithNibName:@"RuleDetailViewController" bundle:nil];
		ruleDetailViewController.rule = rule;
		[self.navigationController pushViewController:ruleDetailViewController animated:YES];
		[ruleDetailViewController release];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	
	HeaderWithCenteredTitleForSection *headerView = [[[HeaderWithCenteredTitleForSection alloc] initWithFrame:CGRectMake(0, 0, 320, 28)]autorelease];
	
	switch (section) {
		case 0:
			headerView.title = @"ACTIVE RULES";
			break;
		case 1:
			headerView.title = @"INACTIVE RULES";
			break;
		default:
			break;
	}	
	
	return headerView;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 28.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 70;
}

#pragma mark - 
#pragma mark Response Handlers

-(void) rulesDownloadFinished: (NSArray *) rules {
	RuleRepository *ruleRepository = [[RuleRepository alloc] init];	
	[ruleRepository setAllRulesToInactive];
	
	for (SCRule *rule in rules) {
		rule.active = YES;
		[ruleRepository saveOrUpdateRule:rule];
	}
	
	[ruleRepository release];
	
	[self loadRules];
	[rulesTableView reloadData];	
	//[rulesTableView scrollToTop:YES];
	[rulesTableView scrollToFirstRow:YES];
	[self hideHUD];
}

-(void) rulesDownloadFailed {
	[self hideHUD];
	SimpleAlertOK(@"Network Error", @"Rules download failed because of network error.");	
}

@end
