//
//  TripStatsTableCell.m
//  safecell
//
//  Created by shail on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TripStatsTableCell.h"
#import "SCTripJourney.h"
#import "UIUtils.h"

@implementation TripStatsTableCell

@synthesize journey;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withJourney:(SCTripJourney *) tripJourney {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.journey = tripJourney;
        [self createCell];
    }
    return self;
}

-(void) createCell {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	
	[self addPointsBackground];
	[self addPointsLabel];
	[self addPointsTitleLabel];
	
	[self addMilesLabelBackground];
	[self addMilesLabel];
	[self addMilesTitleLabel];
	
	[self addPenaltyLabelBackground];
	[self addPenaltyPointsLabel];
	[self addPenaltyLabel];
	
	[self addGradeLabelBackground];
	[self addGradePercentageLabel];
	[self addGradeTitleLabel];	
}

-(void) addPointsLabel {
	int tripPoints = [journey tripPointsForDisplay];
	pointsLabel =  [[UILabel alloc] initWithFrame: CGRectMake(165, 25, 68, 20)];
	pointsLabel.font = [UIFont systemFontOfSize:26];
	if (tripPoints > 0) {
		pointsLabel.textColor = [UIUtils colorFromHexColor:@"323232"];
	} else {
		pointsLabel.textColor = [UIUtils colorFromHexColor:@"FA0000"];
	}

	pointsLabel.textAlignment = UITextAlignmentCenter;
	pointsLabel.adjustsFontSizeToFitWidth = YES;
	pointsLabel.minimumFontSize = 16;
	
	pointsLabel.text = [NSString stringWithFormat:@"%d", tripPoints];
	pointsLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:pointsLabel];
}

-(void) addPointsBackground {
	UIImage* background = [[UIImage imageNamed:@"trip_checks_Backround.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	pointsBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(164, 18, 70, 51)];
	pointsBackgroundView.image = background;
	[self.contentView addSubview:pointsBackgroundView];
	
}

-(void) addPointsTitleLabel {
	int tripPoints = [journey tripPointsForDisplay];
	pointsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(165, 43, 68, 26)];
	pointsTitleLabel.font = [UIFont systemFontOfSize:12];

	if (tripPoints > 0) {
		pointsTitleLabel.textColor = [UIUtils colorFromHexColor:@"323232"];
	} else {
		pointsTitleLabel.textColor = [UIUtils colorFromHexColor:@"FA0000"];
	}

	pointsTitleLabel.textAlignment = UITextAlignmentCenter;
	pointsTitleLabel.text = @"Trip Points";
	pointsTitleLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:pointsTitleLabel];
}

-(void) addMilesLabel {
	
	
	milesLabel =  [[UILabel alloc] initWithFrame: CGRectMake(9, 25, 68, 20)];
	milesLabel.font = [UIFont systemFontOfSize:26];
	milesLabel.textColor = [UIUtils colorFromHexColor:@"323232"];
	milesLabel.textAlignment = UITextAlignmentCenter;
	milesLabel.adjustsFontSizeToFitWidth = YES;
	milesLabel.minimumFontSize = 16;
	
	//int miles = (int) round(journey.miles);
	//milesLabel.text = [NSString stringWithFormat:@"%d", miles];
	
	//int safeMiles =  [journey tripMilesForDisplay] + [journey penaltyPoints];
	
	milesLabel.text = [NSString stringWithFormat:@"%d", [journey tripMilesForDisplay]];
	milesLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:milesLabel];
}

-(void) addMilesLabelBackground {	
	UIImage* background = [[UIImage imageNamed:@"trip_checks_Backround.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	milesBackgroundView= [[UIImageView alloc] initWithFrame:CGRectMake(8, 18, 70, 51)];
	milesBackgroundView.image = background;
	[self.contentView addSubview:milesBackgroundView];
}

-(void) addMilesTitleLabel {
	milesTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 43, 68, 26)];
	milesTitleLabel.font = [UIFont systemFontOfSize:12];
	milesTitleLabel.textColor = [UIUtils colorFromHexColor:@"323232"];
	milesTitleLabel.textAlignment = UITextAlignmentCenter;
	milesTitleLabel.text = @"Total Miles";
	milesTitleLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:milesTitleLabel];
}

-(void) addPenaltyPointsLabel {
	penaltyPointsLabel =  [[UILabel alloc] initWithFrame: CGRectMake(87, 25, 68, 20)];
	penaltyPointsLabel.font = [UIFont systemFontOfSize:26];
	penaltyPointsLabel.textColor = [UIUtils colorFromHexColor:@"FA0000"];
	penaltyPointsLabel.textAlignment = UITextAlignmentCenter;
	penaltyPointsLabel.text = [NSString stringWithFormat:@"%d", [journey penaltyPoints]];
	penaltyPointsLabel.backgroundColor = [UIColor clearColor];
	penaltyPointsLabel.adjustsFontSizeToFitWidth = YES;
	penaltyPointsLabel.minimumFontSize = 16;
	
	[self.contentView addSubview:penaltyPointsLabel];
}

-(void) addPenaltyLabelBackground {	
	UIImage* background = [[UIImage imageNamed:@"trip_checks_Backround.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	penaltyBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(86, 18, 70, 51)];
	penaltyBackgroundView.image = background;
	[self.contentView addSubview:penaltyBackgroundView];
}

-(void) addPenaltyLabel {
	penaltyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(87, 43, 68, 26)];
	penaltyTitleLabel.font = [UIFont systemFontOfSize:12];
	penaltyTitleLabel.textColor = [UIUtils colorFromHexColor:@"FA0000"];
	penaltyTitleLabel.textAlignment = UITextAlignmentCenter;
	penaltyTitleLabel.text = @"Penalty";
	penaltyTitleLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:penaltyTitleLabel];
}

-(void) addGradePercentageLabel {	
	gradeLabel =  [[UILabel alloc] initWithFrame: CGRectMake(243, 25, 68, 20)];
	gradeLabel.font = [UIFont systemFontOfSize:26];
	gradeLabel.minimumFontSize = 15;
	gradeLabel.adjustsFontSizeToFitWidth = YES;
	gradeLabel.textColor = [UIUtils colorFromHexColor:@"323232"];
	gradeLabel.textAlignment = UITextAlignmentCenter;
	gradeLabel.text = [NSString stringWithFormat:@"%d\%%", journey.grade];
	gradeLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:gradeLabel];
}

-(void) addGradeLabelBackground {	
	UIImage* background = [[UIImage imageNamed:@"trip_checks_Backround.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	gradeBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(242, 18, 70, 51)];
	gradeBackgroundView.image = background;
	[self.contentView addSubview:gradeBackgroundView];
}

-(void) addGradeTitleLabel {
	gradeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(243, 43, 68, 26)];
	gradeTitleLabel.font = [UIFont systemFontOfSize:12];
	gradeTitleLabel.textColor = [UIUtils colorFromHexColor:@"323232"];
	gradeTitleLabel.textAlignment = UITextAlignmentCenter;
	gradeTitleLabel.text = @"Grade";
	gradeTitleLabel.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview:gradeTitleLabel];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) showPenaltyAndGrade {
	
	pointsLabel.hidden = NO;
	pointsTitleLabel.hidden = NO;
	pointsBackgroundView.hidden = NO;
	
	penaltyPointsLabel.hidden = NO;
	penaltyTitleLabel.hidden = NO;
	penaltyBackgroundView.hidden = NO;
	
	gradeLabel.hidden = NO;
	gradeTitleLabel.hidden = NO;
	gradeBackgroundView.hidden = NO;
	
	milesLabel.frame = CGRectMake(9, 25, 68, 20);
	milesTitleLabel.frame = CGRectMake(9, 43, 68, 26);
	milesBackgroundView.frame = CGRectMake(8, 18, 70, 51);
}

-(void) hidePenaltyAndGrade {
	
	pointsLabel.hidden = YES;
	pointsTitleLabel.hidden = YES;
	pointsBackgroundView.hidden = YES;
	
	
	penaltyPointsLabel.hidden = YES;
	penaltyTitleLabel.hidden = YES;
	penaltyBackgroundView.hidden = YES;
	
	gradeLabel.hidden = YES;
	gradeTitleLabel.hidden = YES;
	gradeBackgroundView.hidden = YES;
	
	milesLabel.frame = CGRectMake(112, 25, 88, 20);
	milesTitleLabel.frame = CGRectMake(112, 43, 88, 26);
	milesBackgroundView.frame = CGRectMake(111, 18, 90, 51);
}

- (void)dealloc {	
	[pointsTitleLabel release];
	[penaltyTitleLabel release];
	[gradeTitleLabel release];
	[milesTitleLabel release];
	
	[pointsLabel release];
	[penaltyPointsLabel release];
	[gradeLabel release];
	[milesLabel release];
	
	[pointsBackgroundView release];
	[penaltyBackgroundView release];
	[gradeBackgroundView release];
	[milesBackgroundView release];
    
	[super dealloc];
}

@end
