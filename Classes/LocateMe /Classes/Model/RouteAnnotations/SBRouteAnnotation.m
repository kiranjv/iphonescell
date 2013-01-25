//
//  SBRouteAnnotation.m
//  AdsAroundMe
//
//  Created by Adodis on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import "SBRouteAnnotation.h"

@implementation SBRouteAnnotation

@synthesize coordinate = coordinate;
@synthesize title = mTitle;
@synthesize annotationType = annotationType;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)inTitle annotationType:(SBRouteAnnotationType)type {
	self = [super init];
	if (self != nil) {
		coordinate = coord;
		mTitle = [inTitle retain];
		annotationType = type;
	}
	return self;
}

- (void)dealloc {
	[mTitle release];	
	[super dealloc];
}

@end
