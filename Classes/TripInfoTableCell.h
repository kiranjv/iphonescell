//
//  HomeViewCustomCell.h
//  safecell
//
//  Created by shail on 05/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCTripJourney;

@interface TripInfoTableCell : UITableViewCell {
	UIImageView *pointsLabelBackgroundImageView;
	UILabel *recordedOnLabel;
	UILabel *pointsLabel;
	UILabel *pointsValueLabel;
	UILabel *tripNameLabel;
	UILabel *tripDateLabel;
	UILabel *milesLabel;
	SCTripJourney *tripObject;
}

@property (nonatomic ,retain) SCTripJourney *tripObject;

- (void) createCell;
- (void) addPointsValueLabel;
- (void) addPointsLabel;
- (void) addTripNameLabel;
- (void) addRecordedOnLabel;
- (void) addTripLabel;
- (void) addMilesLabel;

- (void) hidePoints;
- (void) showPoints;

@end
