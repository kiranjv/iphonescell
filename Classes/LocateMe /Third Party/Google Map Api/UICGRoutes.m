//
//  UICGRoutes.m
//  AdsAroundMe
//
//  Created by Adodis on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UICGRoutes.h"


@implementation UICGRoutes
@synthesize mRoutes;
- (id) init
{
	self = [super init];
	if (self != nil) {
		self.mRoutes = [[NSMutableArray alloc]init];
	}
	return self;
}
- (void)dealloc {
	[mRoutes release]; mRoutes = nil;
	[super dealloc];
}

@end
