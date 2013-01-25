//
//  RectHelper.m
//  safecell
//
//  Created by Ben Scheirman on 4/21/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "RectHelper.h"

CGRect CGRectCenter(CGRect outerRect, CGFloat width, CGFloat height) {
	CGFloat centerX = outerRect.size.width / 2.0f;
	CGFloat centerY = outerRect.size.height / 2.0f;
	CGFloat left = centerX - (width/2.0f);
	CGFloat top = centerY - (height/2.0f);
	
	return CGRectMake(left, top, width, height);
}

void LogRect(NSString *description, CGRect rect) {
	NSLog(@"%@ ==> [%.1f, %.1f, %.1f, %.1f", description, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}
