//
//  Graphics2DHelper.m
//  safecell
//
//  Created by Ben Scheirman on 4/22/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "Graphics2DHelper.h"


void DrawPoint(CGPoint point, CGColorRef color) {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, color);
	CGContextFillRect(context, CGRectMake(point.x, point.y, 2, 2));
	NSLog(@"Drew point at (%.1f, %.1f)", point.x, point.y);
}

void DrawRect(CGRect rect, CGColorRef color) {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, color);
	CGContextFillRect(context, rect);
}