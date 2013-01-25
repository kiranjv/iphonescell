//
//  GoogleMap.m
//  RoutePath
//
//  Created by surjan singh on 10/9/12.
//  Copyright (c) 2012 treewalker. All rights reserved.
//

#import "GoogleMap.h"
#import "SBMapView.h"
#import "SBRouteAnnotation.h"
#import "City.h"
#import "UICGRoutes.h"
#import "SBCheckPointViewController.h"


@interface GoogleMap(Private)
-(void)releaseAllViews;
-(void)customInitialization;
@end

@implementation GoogleMap(Private)
-(void)releaseAllViews
{
	//Release All views that are retained by this class.. Both Views retained from nib and views added programatically
	
	self.loadBtn = nil;
    
}

-(void)customInitialization
{
	// do the initialization of class variables here..
	
	mDirections			 = [UICGDirections sharedDirections];
	mDirections.delegate = self;
}

@end

@implementation GoogleMap
@synthesize map				= mMap;
@synthesize startPoint		= mStartPoint;
@synthesize endPoint		= mEndPoint;
@synthesize loadBtn		= mLoadBtn;
@synthesize annotationArray = mAnnotationArray;
@synthesize travelMode		= mTravelMode;
@synthesize destination;
@synthesize routes;
@synthesize mAnnotations;
@synthesize mRouteArray;
@synthesize mRouteDetail;

-(id)initWithCoder:(NSCoder*)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if( self)
	{
		[self customInitialization];
	}
	return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self customInitialization];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
-(void)backToCategoryDesc{
    
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor grayColor];
    UIButton *backButton=[UIButton  buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10, 5, 100, 24)];
    [backButton setBackgroundColor:[UIColor redColor]];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    // [backButton setBackgroundImage:[UIImage imageNamed:@"images.jpeg"] forState:UIControlStateNormal];
    //[backButton setBackgroundImage:[UIImage imageNamed:@"landbackbtn.png"] forState:UIControlStateHighlighted];
    //[backButton setBackgroundImage:[UIImage imageNamed:@"landbackbtn.png"] forState:UIControlStateSelected];
    [backButton addTarget:self action:@selector(backToCategoryDesc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    UIDeviceOrientation interfaceOrientation = [[UIDevice currentDevice] orientation];
    if (interfaceOrientation == UIInterfaceOrientationPortrait ||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        
        self.map = [[SBMapView alloc] initWithFrame:CGRectMake(0, 35, 320, 525)];
        
    }
    else
    {
        self.map = [[SBMapView alloc] initWithFrame:CGRectMake(0, 35, 480, 520)];
        
    }
    //self.map.imgString = self.imgString;
	[self.view addSubview:mMap];
	
	//self.view.backgroundColor = [UIColor blackColor];
	self.annotationArray = [[NSMutableArray alloc]init];
	self.routes	= [[UICGRoutes alloc]init];
    
	if (mDirections.isInitialized) {
		[self updateRoute];
	}

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark -
#pragma mark Instance Methods

- (void)updateRoute
{	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	UICGDirectionsOptions *options = [[[UICGDirectionsOptions alloc] init] autorelease];
	options.travelMode = mTravelMode;
	City *mFirstCity = [[[City alloc]init] autorelease];
	mFirstCity.mCityName = mStartPoint;
	[mDirections loadWithStartPoint:mFirstCity.mCityName endPoint:destination options:options];
}

/*-(void)loadRouteAnnotations
 {
 self.mRouteArray = [mDirections routeArray];
 //NSLog(@"mRouteArray %@",mRouteArray);
 self.mAnnotations = [[NSMutableArray alloc]init];
 for (int idx = 0; idx < [mRouteArray count]; idx++) {
 NSArray *_routeWayPoints1 = [[mRouteArray objectAtIndex:idx] wayPoints];
 NSArray *mPlacetitles = [[mRouteArray objectAtIndex:idx] mPlaceTitle]; 
 self.annotationArray = [NSMutableArray arrayWithCapacity:[_routeWayPoints1 count]-2];
 
 mLoadBtn.title = @"OFF";
 mLoadBtn.target = self;
 mLoadBtn.action = @selector(removeRouteAnnotations);
 
 for(int idx = 0; idx < [_routeWayPoints1 count]-1; idx++)
 {
 
 mBetweenAnnotation = [[[SBRouteAnnotation alloc] initWithCoordinate:[[_routeWayPoints1 objectAtIndex:idx]coordinate]
 title:[mPlacetitles objectAtIndex:idx]
 annotationType:SBRouteAnnotationTypeWayPoint] autorelease];
 [self.annotationArray addObject:mBetweenAnnotation];
 }
 [mAnnotations addObject:mAnnotationArray];
 [self.map.mapView addAnnotations:[mAnnotations objectAtIndex:idx]];
 NSLog(@"map %@",mMap);
 
 }	
 [mAnnotations release];
 }*/

/*-(void)showCheckpoints
 {
 SBCheckPointViewController *_Controller	= [[SBCheckPointViewController alloc]initWithNibName:@"SBCheckPoints" bundle:nil];
 [self.navigationController pushViewController:_Controller animated:YES];
 NSMutableArray *arr = [[mDirections checkPoint] mPlaceTitle];
 _Controller.mCheckPoints = arr ;
 
 [_Controller release];
 }*/
-(void)removeRouteAnnotations
{
	NSMutableArray *mTempAnnotation = [mAnnotations retain];
	for (int idx = 0; idx < [mTempAnnotation count]; idx++) {
		[mMap.mapView removeAnnotations:[mTempAnnotation objectAtIndex:idx] ];
	}	
	mLoadBtn.title = @"ON";
	mLoadBtn.target = self;
	mLoadBtn.action = @selector(loadRouteAnnotations);
	[mTempAnnotation release];
}


#pragma mark <UICGDirectionsDelegate> Methods

- (void)directionsDidFinishInitialize:(UICGDirections *)directions {
	[self updateRoute];
}

- (void)directions:(UICGDirections *)directions didFailInitializeWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Map Directions" message:[error localizedFailureReason] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alertView show];
	[alertView release];
}

- (void)directionsDidUpdateDirections:(UICGDirections *)indirections {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	UICGPolyline *polyline = [indirections polyline];
	NSArray *routePoints = [polyline routePoints];
	
	[mMap loadRoutes:routePoints]; // Loads route by getting the array of all coordinates in the route.
    
    UIToolbar *tools = [[UIToolbar alloc]
                        initWithFrame:CGRectMake(0.0f, 0.0f, 103.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
    tools.clearsContextBeforeDrawing = NO;
    tools.clipsToBounds = NO;
    tools.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f]; // closest I could get by eye to black, translucent style.
    // anyone know how to get it perfect?
    tools.barStyle = -1; // clear background
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:2];
    
    // Create a standard Load button.
    
    self.loadBtn = [[UIBarButtonItem alloc]initWithTitle:@"ON" 
                                                   style:UIBarButtonItemStyleBordered 
                                                  target:self 
                                                  action:@selector(loadRouteAnnotations)];
    
    [buttons addObject:mLoadBtn];
    
    // Add Go button.
    UIBarButtonItem *mGoBtn = [[UIBarButtonItem alloc] initWithTitle:@"Go" 
                                                               style:UIBarButtonItemStyleBordered 
                                                              target:self 
                                                              action:@selector(backToCategoryDesc:)];
    [buttons addObject:mGoBtn];
    [mGoBtn release];
    
    // Add buttons to toolbar and toolbar to nav bar.
    [tools setItems:buttons animated:NO];
    [buttons release];
    UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];
    [tools release];
    self.navigationItem.rightBarButtonItem = twoButtons;
    [twoButtons release];
	
	//Add annotations of different colors based on initial and final places.
	SBRouteAnnotation *startAnnotation = [[[SBRouteAnnotation alloc] initWithCoordinate:[[routePoints objectAtIndex:0] coordinate]
                                                                                  title:mStartPoint
                                                                         annotationType:SBRouteAnnotationTypeStart] autorelease];
	SBRouteAnnotation *endAnnotation = [[[SBRouteAnnotation alloc] initWithCoordinate:[[routePoints lastObject] coordinate]
                                                                                title:mEndPoint
                                                                       annotationType:SBRouteAnnotationTypeEnd] autorelease];
	
	
	[mMap.mapView addAnnotations:[NSArray arrayWithObjects:startAnnotation, endAnnotation,nil]];
}

- (void)directions:(UICGDirections *)directions didFailWithMessage:(NSString *)message {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Map Directions" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alertView show];
	[alertView release];
}

#pragma mark -
#pragma mark releasing instances
- (void)dealloc {
	//remove as Observer from NotificationCenter, if this class has registered for any notifications
	//release all you member variables and appropriate caches
	[routes release];
	[mAnnotationArray release];
    [mLoadBtn release];
    [mMap release];
    //[mimgString release];
	[self releaseAllViews];
    [super dealloc];
}

@end
