//
//  TripStatsTableCell.h
//  safecell
//
//  Created by shail on 19/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCTripJourney;


@interface TripStatsTableCell : UITableViewCell {
	
	UILabel *pointsLabel;
	UILabel *penaltyPointsLabel;
	UILabel *gradeLabel;	
	UILabel *milesLabel;
	
	UILabel *pointsTitleLabel;
	UILabel *penaltyTitleLabel;
	UILabel *gradeTitleLabel;
	UILabel *milesTitleLabel;
	
	UIImageView *pointsBackgroundView;
	UIImageView *penaltyBackgroundView;
	UIImageView *gradeBackgroundView;
	UIImageView *milesBackgroundView;
	
	SCTripJourney *journey;
}

@property (nonatomic, assign)  SCTripJourney *journey;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withJourney:(SCTripJourney *) tripJourney;

-(void) createCell;

-(void) addPointsLabel;
-(void) addPointsBackground;
-(void) addPointsTitleLabel;

-(void) addPenaltyPointsLabel;
-(void) addPenaltyLabelBackground;
-(void) addPenaltyLabel;

-(void) addGradePercentageLabel;
-(void) addGradeLabelBackground;
-(void) addGradeTitleLabel;

-(void) addMilesLabel;
-(void) addMilesLabelBackground;
-(void) addMilesTitleLabel;

-(void) showPenaltyAndGrade;
-(void) hidePenaltyAndGrade;

@end
