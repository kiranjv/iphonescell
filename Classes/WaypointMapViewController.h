//
//  JourneyMapViewController.h
//  safecell
//
//  Created by Ben Scheirman on 5/10/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class AddTripViewController;

@interface WaypointMapViewController : UIViewController <MKMapViewDelegate> {
	MKMapView *_mapView;
	NSArray *waypoints;
	NSMutableArray *routeLayerViews;
	BOOL showPins;
	BOOL simplifiedMap;
	UILabel *simplifiedMapLabel;
	UIView *bottomNoticeBackground;
	UIButton *hideNoticeButton;
	AddTripViewController *addTripViewController;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, assign) BOOL simplifiedMap;
@property (nonatomic, retain) IBOutlet UILabel *simplifiedMapLabel;
@property (nonatomic, retain) IBOutlet UIView *bottomNoticeBackground;
@property (nonatomic, retain) IBOutlet UIButton *hideNoticeButton;
@property (nonatomic, assign) AddTripViewController *addTripViewController;

-(id)initWithWaypoints:(NSArray *)waypointsArray;
-(IBAction) hideNoticeButtonTapped;

@end
