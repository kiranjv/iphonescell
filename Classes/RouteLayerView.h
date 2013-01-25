//
//  RouteLayerView.h
//  safecell
//
//  Created by Ben Scheirman on 5/11/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class RouteLayerViewInternal;

@interface RouteLayerView : MKAnnotationView {
	MKMapView *_mapView;
	RouteLayerViewInternal *_internalRouteLayer;
	NSArray *_points;
	UIColor *_lineColor;	
}

-(id)initWithPoints:(NSArray *)points mapView:(MKMapView *)mapView;

//signal from the view controller that the region changed, so we can redraw
-(void)regionChanged;

@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) NSArray *points;
@property (nonatomic, retain) UIColor *lineColor;

@end