//
//  RouteLayerView.m
//  safecell
//
//  Created by Ben Scheirman on 5/11/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "RouteLayerView.h"


@interface RouteLayerViewInternal : UIView {
	MKMapView *_mapView;
	RouteLayerView *_routeLayerView;
}

@property (nonatomic, retain) RouteLayerView *routeLayerView;

@end

@implementation RouteLayerViewInternal

@synthesize routeLayerView = _routeLayerView;

-(id)init {
	if(self = [super init]) {
		self.backgroundColor = [UIColor clearColor]; //colorWithHue:251 saturation:18 value:46 alpha:.5];
		self.clipsToBounds = NO;
	}
	
	return self;
}

-(void)dealloc {
	self.routeLayerView = nil;
	[super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	
	NSLog(@"Drawing route lines...clips to bounds? %@", self.clipsToBounds ? @"YES" : @"NO");
	
	//don't draw if we don't have to
	if(self.hidden || self.routeLayerView.points == nil || self.routeLayerView.points.count == 0)
		return;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//set line properties
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetStrokeColorWithColor(context, [self.routeLayerView.lineColor CGColor]);
	CGContextSetRGBFillColor(context, 0, 0, 1.0, 1.0);
	CGContextSetLineWidth(context, 3.0);
	
	NSLog(@"Drawing points...");
	BOOL firstPoint = YES;
	for (id<MKAnnotation> point in self.routeLayerView.points) {
		CLLocationCoordinate2D coord = [point coordinate];
		CGPoint convertedPoint = [self.routeLayerView.mapView convertCoordinate:coord toPointToView:self];
		
		NSLog(@"Processing point (%.lf, %.lf)", convertedPoint.x, convertedPoint.y);
		
		if(firstPoint) {
			CGContextMoveToPoint(context, convertedPoint.x, convertedPoint.y);
		} else {
			CGContextAddLineToPoint(context, convertedPoint.x, convertedPoint.y);
		}
		
		firstPoint = NO;
	}
	
	CGContextStrokePath(context);
}

@end


@implementation RouteLayerView

@synthesize lineColor = _lineColor;
@synthesize mapView = _mapView;
@synthesize points = _points;

-(id)initWithPoints:(NSArray *)points mapView:(MKMapView *)mapView {
	if(self = [super initWithFrame:mapView.bounds]) {
		
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = NO;
		self.mapView = mapView;
		self.points = points;
		self.lineColor = [UIColor blueColor];
		self.frame = CGRectInset(mapView.frame, -1000, -1000);
		
		_internalRouteLayer = [[RouteLayerViewInternal alloc] init];
		_internalRouteLayer.routeLayerView = self;
		_internalRouteLayer.frame = self.bounds;
		[self addSubview:_internalRouteLayer];
	}
	
	return self;
}

-(void)setMapView:(MKMapView *)mapView {
	if (mapView == _mapView) {
		return;
	}
	
	[_mapView release];
	
	if(mapView == nil)
		_mapView = nil;
	else
		_mapView = [mapView retain];
	
	[self regionChanged];
}

-(void)regionChanged {
	NSLog(@"Region Changed");
	
	// move the internal route view. 
//	CGPoint origin = CGPointMake(0, 0);
//	origin = [_mapView convertPoint:origin toView:self];
//	CGRect frame = CGRectMake(origin.x, origin.y, self.mapView.frame.size.width, self.mapView.frame.size.height);	
//	
//	self.backgroundColor = [UIColor colorWithRed:.6 green:.1 blue:.6 alpha:.8];
//	self.frame = CGRectInset(frame, -1000, -1000);
	
	[_internalRouteLayer setNeedsDisplay];
}

-(void)dealloc {
	self.backgroundColor = nil;
	self.mapView = nil;
	self.lineColor = nil;
	self.points = nil;
	[_internalRouteLayer release];
	
	[super dealloc];
}

@end