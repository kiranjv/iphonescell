//
//  SBMapView.h
//  AdsAroundMe
//
//  Created by Adodis on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKPolyline.h>

@interface SBMapView : UIView<MKMapViewDelegate> 
{
	MKMapView*			mMapView;			  	    // the view we create for the map
	MKPolyline*			mrouteLine;			 	    // An Instance of Line (MKPolyline)  on the map
	MKPolylineView*		mrouteLineView;				// the view we create for the line on the map
    NSString *mimgString;
}
@property (nonatomic, retain) MKMapView*		mapView;
@property (nonatomic, retain) MKPolyline*		routeLine;
@property (nonatomic, retain) MKPolylineView*	routeLineView;

@property (nonatomic,retain) NSString *imgString;

#pragma mark Instance Methods

-(void)loadRoutes:(NSArray *)inArray;
@end
