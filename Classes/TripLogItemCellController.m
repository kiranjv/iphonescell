//
//  TripLogItemCell.m
//  safecell
//
//  Created by shail on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TripLogItemCellController.h"
#import "TripLogViewController.h"
#import "SCJourneyEvent.h"
#import "SCTripJourney.h"
#import "UIUtils.h"

static const NSInteger kTitleLabelTag = 0;
static const NSInteger kDescriptionLabelTag = 0;

@implementation TripLogItemCellController

@synthesize parentViewController;

- (id) initWithParentController: (UIViewController *) parentController {
	self = [super init];
	if (self != nil) {
		self.parentViewController = parentController;
		
		right = [[UIImage imageNamed:@"right.png"] retain];
		wrong = [[UIImage imageNamed:@"wrong.png"] retain];
		pointsBackground = [[UIImage imageNamed:@"trip_points_background.png"] retain];
		interruptionImage = [[UIImage imageNamed:@"interruption_cell_background.png"] retain];
	}
	return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	TripLogViewController * parentController = (TripLogViewController *) parentViewController;	
	int row = [indexPath row];
	
	SCJourneyEvent * journeyLogItem = [parentController.journey.journeyEvents objectAtIndex:row];
	if(journeyLogItem.isInterruption) {
		return [self tableView:tableView interruptionForLogItem:journeyLogItem];
	} else {
		return [self tableView:tableView regularCellForLogItem:journeyLogItem];
	}	
}


-(UITableViewCell *) tableView:(UITableView *)tableView regularCellForLogItem: (SCJourneyEvent *) logItem {
	static NSString *strCellIdentifier = @" TripLogItemCell"; 
	
	UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strCellIdentifier];
	
	UILabel *titleLabel, *descriptionLabel;
	
	TripLogViewController * parentController = (TripLogViewController *) parentViewController;	
	
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleSubtitle
				 reuseIdentifier:@"UITableViewCell"] autorelease];	
		
		cell.backgroundView = [[[UIView alloc] initWithFrame:cell.bounds] autorelease];
		cell.backgroundView.backgroundColor = [UIColor whiteColor];
		
		titleLabel = [self titleLabel];
		[cell.contentView addSubview:titleLabel];
				
		descriptionLabel = [self descriptionLabel];
		[cell.contentView addSubview:descriptionLabel];
	} else {
		titleLabel = (UILabel *)[cell.contentView viewWithTag:kTitleLabelTag];
        descriptionLabel = (UILabel *)[cell.contentView viewWithTag:kDescriptionLabelTag];
	}
	
	titleLabel.text = logItem.description;
	descriptionLabel.text = logItem.near;
	
	if (parentController.gameplayStatus) {
		cell.accessoryView = [self accessoryView:logItem.points];
		titleLabel.frame = CGRectMake(50, 5, 210, 15.0);
		descriptionLabel.frame = CGRectMake(52, 23, 210, 12.0);
	} else {
		cell.accessoryView = nil;
		titleLabel.frame = CGRectMake(50, 5, 260, 15.0);
		descriptionLabel.frame = CGRectMake(52, 23, 260, 12.0);
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	if(logItem.points < 0) {
		cell.imageView.image = wrong;
	} else {
		cell.imageView.image = right;
	}
	
	return cell;
}

-(UILabel *) titleLabel {
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 210, 15.0)] autorelease];
	label.tag = kTitleLabelTag;
	label.font = [UIFont boldSystemFontOfSize:12.0];
	label.textAlignment = UITextAlignmentLeft;
	label.textColor = [UIColor blackColor];
	
	return label;
}

-(UILabel *) descriptionLabel {
	UILabel *secondLabel = [[[UILabel alloc] initWithFrame:CGRectMake(52, 23, 210, 12.0)] autorelease];
	secondLabel.tag = kDescriptionLabelTag;
	secondLabel.font = [UIFont systemFontOfSize:12.0];
	secondLabel.textAlignment = UITextAlignmentLeft;
	secondLabel.textColor = [UIUtils colorFromHexColor:@"9DB9D8"];
	
	return secondLabel;
}
	
-(UIView *) accessoryView: (int) points {
	UIView *accessoryView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)] autorelease];
	
	[accessoryView addSubview:[self accessoryImageView]];
	[accessoryView addSubview:[self pointsValueLabel: points]];
	[accessoryView addSubview:[self pointsLabel: points]];
	
	return accessoryView;
}

-(UIImageView *) accessoryImageView {
	UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)] autorelease];
	imageView.image = pointsBackground;
	
	return imageView;
}

- (UILabel *) pointsValueLabel: (int) points {
	UILabel *pointsValueLabel = [[[UILabel alloc] initWithFrame:CGRectMake(2, 6, 28, 10)] autorelease];
	pointsValueLabel.backgroundColor = [UIColor clearColor];
	if(points <= 0) {	
		pointsValueLabel.textColor = [UIColor redColor]; 
	} else {
		pointsValueLabel.textColor = [UIUtils colorFromHexColor:@"323232"];
	}
	pointsValueLabel.font = [UIFont boldSystemFontOfSize:11];
	pointsValueLabel.textAlignment = UITextAlignmentCenter;
	pointsValueLabel.text = [NSString stringWithFormat:@"%d", points];
	return pointsValueLabel;
}

- (UILabel *) pointsLabel: (int) points {
	UILabel *pointsLabel  = [[[UILabel alloc] initWithFrame:CGRectMake(2, 20, 28, 8)] autorelease];
	pointsLabel.backgroundColor = [UIColor clearColor];
	if(points <= 0) {	
		pointsLabel.textColor = [UIColor redColor]; 
	} else {
		pointsLabel.textColor = [UIUtils colorFromHexColor:@"323232"];
	}
	pointsLabel.text = @"Points";
	pointsLabel.font = [UIFont systemFontOfSize:8];
	pointsLabel.textAlignment = UITextAlignmentCenter;
	
	return pointsLabel;
}

-(UITableViewCell *) tableView:(UITableView *)tableView interruptionForLogItem: (SCJourneyEvent *) logItem {
	static NSString *strCellIdentifier = @"InterruptionTripLogItemCell"; 
	
	UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strCellIdentifier];
	
	if(cell == nil) {
		cell = [[[UITableViewCell alloc] 
				 initWithStyle:UITableViewCellStyleDefault 
				 reuseIdentifier:@"UITableViewCell"] autorelease];	
		
		UIImageView *backImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 43)] autorelease];
		backImageView.image = interruptionImage;		
		[cell.contentView addSubview:backImageView];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.frame = cell.bounds;
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.textLabel.text = [self interruptionMessage:logItem];
	cell.textLabel.textAlignment = UITextAlignmentCenter;
	cell.textLabel.font = [UIFont boldSystemFontOfSize: 12];
	
	return cell;
}

-(NSString *) interruptionMessage: (SCJourneyEvent *) interruption {
  
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"hh:mm a"];
   // [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSLog(@"INTERRUPTION BEFORE FORMAT: %@",interruption.timestamp);
	NSString * interruptionTime = [dateFormatter stringFromDate:interruption.timestamp];
     NSLog(@"INTERRUPTION AFTER FORMAT: %@",interruptionTime);
	[dateFormatter release];
	NSString *message = [NSString stringWithFormat:@"SAFECELL INTERRUPTION AT %@", interruptionTime];
    
	return message;
}


- (void)dealloc {	
	[right release];
	[wrong release];
	[interruptionImage release];
	[pointsBackground release];
	
    [super dealloc];
}


@end
