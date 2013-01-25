//
//  RouteLineAnnotation.h
//  safecell
//
//  Created by Ben Scheirman on 5/11/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RouteLineAnnotation : NSObject<MKAnnotation> {
	NSArray *_waypoints;
}

@property (nonatomic, retain) NSArray *waypoints;

@end
