//
//  HomeViewCustomCell.m
//  safecell
//
//  Created by shail on 05/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TripInfoTableCell.h"
#import "SCTripJourney.h"
#import "UIUtils.h"

@implementation TripInfoTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		[self createCell];
    }
    return self;
}

- (void)dealloc {
	[recordedOnLabel release];	
	[pointsLabelBackgroundImageView release];
	[pointsLabel release];
	[pointsValueLabel release];
	[tripNameLabel release];
	[tripDateLabel release];
	[milesLabel release];
    [super dealloc];
}


-(SCTripJourney *) tripObject {
	return tripObject;
}

-(void) setTripObject : (SCTripJourney *) tripobj {
	[tripobj retain];
	[tripObject release];
	tripObject = tripobj;
	
	if(tripObject.points > 0) {
		pointsValueLabel.textColor = [UIUtils colorFromHexColor:@"404B5E"];
		pointsLabel.textColor = [UIUtils colorFromHexColor:@"404B5E"];
	} else {
		pointsValueLabel.textColor = [UIColor redColor];
		pointsLabel.textColor = [UIColor redColor];
	}

	
	pointsValueLabel.text = [NSString stringWithFormat:@"%d",[tripObject tripPointsForDisplay]]; 
	tripNameLabel.text = tripObject.tripName;
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];	
	[dateFormatter setDateFormat:@"MMMM dd, yyyy hh:mm a"];
	NSString *tripDateString = (NSString *) [dateFormatter stringFromDate:tripObject.tripDate];
	[dateFormatter release];
	tripDateLabel.text = [NSString stringWithFormat:@"%@", tripDateString];
	
	//int miles = (int) round(tripObject.miles);

	milesLabel.text = [NSString stringWithFormat:@"%d Total Miles", [tripObject tripMilesForDisplay]];
}


- (void) addPointsValueLabel {
	pointsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 10, 28, 10)];
	pointsValueLabel.backgroundColor = [UIColor clearColor];
	pointsValueLabel.textColor = [UIColor redColor]; 
	pointsValueLabel.font = [UIFont boldSystemFontOfSize:11];
	pointsValueLabel.textAlignment = UITextAlignmentCenter;
	[self.contentView addSubview:pointsValueLabel];
}

- (void) addPointsLabel {
	pointsLabel  = [[UILabel alloc] initWithFrame:CGRectMake(11, 24, 28, 8)];
	pointsLabel.backgroundColor = [UIColor clearColor];
	pointsLabel.textColor = [UIColor redColor]; 
	pointsLabel.text = @"Points";
	pointsLabel.font = [UIFont systemFontOfSize:8];
	pointsLabel.textAlignment = UITextAlignmentCenter;
	[self.contentView addSubview:pointsLabel];
}

- (void) addTripNameLabel {
	tripNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(59, 7, 145, 16)];
	tripNameLabel.backgroundColor = [UIColor clearColor];
	tripNameLabel.textColor = [UIColor blackColor]; 
	tripNameLabel.font = [UIFont boldSystemFontOfSize:12];
	tripNameLabel.textAlignment = UITextAlignmentLeft;
	[self.contentView addSubview:tripNameLabel];
}

- (void) addRecordedOnLabel {
	recordedOnLabel  = [[UILabel alloc] initWithFrame:CGRectMake(62, 25, 75, 12)];
	recordedOnLabel.backgroundColor = [UIColor clearColor];
	recordedOnLabel.textColor = [UIUtils colorFromHexColor:@"7F9FC0"];
	recordedOnLabel.font = [UIFont boldSystemFontOfSize:11];
	recordedOnLabel.textAlignment = UITextAlignmentLeft;
	recordedOnLabel.text =@"Recorded On:";
	[self.contentView addSubview:recordedOnLabel];	
}

- (void) addTripLabel {
	tripDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(138, 25, 233, 12)];
	tripDateLabel.backgroundColor = [UIColor clearColor];
	tripDateLabel.textColor =  [UIUtils colorFromHexColor:@"7F9FC0"];
	tripDateLabel.font = [UIFont systemFontOfSize:11];
	tripDateLabel.textAlignment = UITextAlignmentLeft;
	[self.contentView addSubview:tripDateLabel];
	
}

- (void) addMilesLabel {
	milesLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 8, 90, 14)];
	milesLabel.backgroundColor = [UIColor clearColor];
	milesLabel.textColor = [UIColor blackColor]; 
	milesLabel.font = [UIFont boldSystemFontOfSize:11];
	milesLabel.textAlignment = UITextAlignmentCenter;
	[self.contentView addSubview:milesLabel];
	
}

-(void) addPointsLabelBackgroundImageView {
	pointsLabelBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trip_points_background.png"]];
	pointsLabelBackgroundImageView.frame =  CGRectMake(7, 3, 35, 35);
	[self.contentView addSubview:pointsLabelBackgroundImageView];
}

-(void)createCell {	
	self.backgroundView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
	self.backgroundView.backgroundColor = [UIColor whiteColor];
	
	[self addPointsLabelBackgroundImageView];
	[self addPointsValueLabel];	
	[self addPointsLabel];	
	[self addTripNameLabel];
	[self addRecordedOnLabel];		
	[self addTripLabel];	
	
	[self addMilesLabel];	
}

-(void) hidePoints {
	pointsLabelBackgroundImageView.hidden = YES;
	pointsLabel.hidden = YES;
	pointsValueLabel.hidden = YES;
	
	tripNameLabel.frame = CGRectMake(7, 7, 145, 16);
	recordedOnLabel.frame  = CGRectMake(10, 25, 75, 12);
	tripDateLabel.frame  = CGRectMake(86, 25, 233, 12);
}

- (void) showPoints {
	pointsLabelBackgroundImageView.hidden = NO;
	pointsLabel.hidden = NO;
	pointsValueLabel.hidden = NO;
	
	tripNameLabel.frame = CGRectMake(59, 7, 145, 16);
	recordedOnLabel.frame  = CGRectMake(62, 25, 75, 12);
	tripDateLabel.frame  = CGRectMake(138, 25, 233, 12);
}

@end
