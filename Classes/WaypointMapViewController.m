//
//  JourneyMapViewController.m
//  safecell
//
//  Created by Ben Scheirman on 5/10/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "WaypointMapViewController.h"
#import "SCWaypoint.h"
#import "RouteLayerView.h"
#import "RouteLineAnnotation.h"
#import "AddTripViewController.h"

@implementation WaypointMapViewController

@synthesize mapView = _mapView;
@synthesize simplifiedMap;
@synthesize simplifiedMapLabel;
@synthesize bottomNoticeBackground;
@synthesize hideNoticeButton;
@synthesize addTripViewController;


-(id)initWithWaypoints:(NSArray *)waypointsArray {
	if(self = [super initWithNibName:@"WaypointMapViewController" bundle:nil]) {
		waypoints = [waypointsArray retain];
		routeLayerViews = [[NSMutableArray alloc] init];
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Toggle Waypoint Pins" 
																				   style:UIBarButtonItemStylePlain 
																				  target:self 
																				  action:@selector(togglePins)] autorelease];
		
		
	}
	
	return self;
}

- (void)annotateMap {
	//each waypoint already confroms to the MKAnnotation protocol
	if (showPins) {
		[self.mapView addAnnotations:waypoints];
	}

	RouteLineAnnotation *routeLine = [[RouteLineAnnotation alloc] init];
	routeLine.waypoints = waypoints;
	[self.mapView addAnnotation:routeLine];
	[routeLine release];
}

- (void)togglePins {
	showPins = !showPins;
	
	if (showPins) {
		[self.mapView addAnnotations:waypoints];
	} else {
		[self.mapView removeAnnotations:waypoints];
	}
}

-(void) hideSimplifiedMapNotice {
	self.simplifiedMapLabel.hidden = YES;
	self.bottomNoticeBackground.hidden = YES;
	self.hideNoticeButton.hidden = YES;
}

-(void) showSimplifiedMapNotice {
	self.simplifiedMapLabel.hidden = NO;
	self.bottomNoticeBackground.hidden = NO;
	self.hideNoticeButton.hidden = NO;
}

- (MKCoordinateRegion)regionForWaypoints:(NSArray *)points {
	NSLog(@"Centering the map on %d waypoints", waypoints.count);
	
	CGFloat leftMost, rightMost, topMost, bottomMost = 0;
	BOOL firstPass = YES;
	
	for(SCWaypoint *waypoint in waypoints) {
		if (firstPass) {
			//first need to set the values so that we have something to compare against
			leftMost = waypoint.latitude;
			rightMost = waypoint.latitude;
			topMost = waypoint.longitude;
			bottomMost = waypoint.longitude;
			firstPass = NO;
			continue;
		}
		
		leftMost = fmin(leftMost, waypoint.latitude);
		rightMost = fmax(rightMost, waypoint.latitude);
		topMost = fmin(topMost, waypoint.longitude);
		bottomMost = fmax(bottomMost, waypoint.longitude);
	}
	
	CGFloat latRange = rightMost - leftMost;
	CGFloat longRange = bottomMost - topMost;
	CGFloat centerLat = leftMost + (latRange / 2);
	CGFloat centerLong = topMost + (longRange / 2);
	
	const CGFloat minRange = .01;  //roughly the size of a neighborhood
	latRange = fmax(minRange, latRange);
	longRange = fmax(minRange, longRange);
	
	MKCoordinateSpan span = MKCoordinateSpanMake(latRange, longRange);
	
	CLLocation *centerLocation = [[CLLocation alloc] initWithLatitude:centerLat longitude:centerLong];
    CLLocationCoordinate2D center = centerLocation.coordinate;
	[centerLocation release];
	return MKCoordinateRegionMake(center, span);
}

- (void)centerMapOnWaypoints {
	MKCoordinateRegion region = [self regionForWaypoints:waypoints];
	[self.mapView setRegion:region animated:YES];
}
-(void)cancel{
    
    [self dismissModalViewControllerAnimated:YES];
}
-(void) setupNavigationBar {
	DecorateNavBarWithLogo(self);
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                              target:self action:@selector(cancel)] autorelease];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setupNavigationBar];
	self.mapView.delegate = self;
	
	[self centerMapOnWaypoints];
	[self annotateMap];
	
	if (self.simplifiedMap) {
		[self showSimplifiedMapNotice];
	} else {
		[self hideSimplifiedMapNotice];
	}
	
}

-(IBAction) hideNoticeButtonTapped {
	[self hideSimplifiedMapNotice];
}


#pragma mark -
#pragma mark mapView delegate functions

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
	NSLog(@"Map region changing...");
	// turn off the view of the route as the map is chaning regions. This prevents
	// the line from being displayed at an incorrect positoin on the map during the
	// transition.
	for (RouteLayerView *layerView in routeLayerViews) {
		NSLog(@"showing layer view...");
		//layerView.hidden = YES;
	}
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	NSLog(@"Map region changed.");
	// re-enable and re-poosition the route display. 
	for (RouteLayerView *layerView in routeLayerViews) {
		NSLog(@"showing layer view...");
		//layerView.hidden = NO;
		[layerView regionChanged];
	}	
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

	MKAnnotationView *annotationView = nil;
	
	NSLog(@"Configuring annotation view for %@", [annotation class]);
	
	if ([annotation isKindOfClass:[SCWaypoint class]]) {
				
		static NSString *pinIdentifier = @"pinView";
		MKPinAnnotationView *pin = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
		
		if(pin == nil) {
			pin = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentifier] autorelease];
		}
		
		//reset the annotation point
		pin.annotation = annotation;
		annotationView = pin;
		
	} else if ([annotation isKindOfClass:[RouteLineAnnotation class]]) {
		
		NSLog(@"Returning the route layer annotation view...");
		
		RouteLineAnnotation *routeLine = (RouteLineAnnotation *)annotation;
		RouteLayerView *routeLayer = [[[RouteLayerView alloc] initWithPoints:routeLine.waypoints mapView:self.mapView] autorelease];
		
		//reposition frame
		routeLayer.center = self.mapView.center;
		
		[routeLayerViews addObject:routeLayer];
		annotationView = routeLayer;
	}
	
	return annotationView;
}

#pragma mark -
#pragma mark cleanup

- (void)cleanUpMapView {
	if (self.mapView != nil) {
		self.mapView.delegate = nil;
		self.mapView = nil;
	}
}

- (void)cleanUpWaypoints {
	if(waypoints != nil) {
		[waypoints release];
		waypoints = nil;
	}
}

-(void) viewWillDisappear:(BOOL)animated {
	[self cleanUpMapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
	NSLog(@"Popping map controller because of memory warning");
	[self.addTripViewController setPoppedMapWarningFlag];
	[self cleanUpWaypoints];
	[self cleanUpMapView];
			
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
	[self cleanUpMapView];
	[self cleanUpWaypoints];
	
	self.simplifiedMapLabel = nil;
	self.hideNoticeButton = nil;
	self.bottomNoticeBackground = nil;
	[routeLayerViews release];

    [super dealloc];
}



@end
