//
//  City.m
//  AdsAroundMe
//
//  Created by Adodis on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "City.h"


@implementation City

@synthesize mCityName;
@synthesize mCityDescription;

-(id) init
{
	self = [super init];
	if (self != nil) {
		self.mCityName = @"";
		self.mCityDescription = @"";
	}
	return self;
}
- (void) dealloc
{
	[mCityName release];
	[mCityDescription release];
	[super dealloc];
}


@end