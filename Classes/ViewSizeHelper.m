//
//  ViewSizeHelper.m
//  safecell
//
//  Created by shail m on 6/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ViewSizeHelper.h"
#import "LocationStripeController.h"

static const int kPotraitScreenWidth = 320;
static const int kPotaritScreenHeight = 480;
static const int kStatusBarHright = 20;
static const int kNavigationBarHeight = 44;
static const int kTabBarHeight = 49;


@implementation ViewSizeHelper

+(CGRect) potraitBoundsWithStatusBar: (BOOL) statusBar 
					   navigationBar: (BOOL) navigation 
							  tabBar: (BOOL) tabBar 
					  locationStripe: (BOOL) locationStripe {
	
	int height = kPotaritScreenHeight;
	
	height = (statusBar) ? (height - kStatusBarHright) : height;
	
	height = (navigation) ? (height - kNavigationBarHeight) : height;
	
	height = (tabBar) ? (height - kTabBarHeight) : height;
	
	height = (locationStripe) ? (height - kLocationStripeHeight) : height;
	
	return CGRectMake(0, 0, kPotraitScreenWidth, height);
}


@end
