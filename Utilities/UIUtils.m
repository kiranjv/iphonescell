//
//  UIUtils.m
//  AwarenessRibbons
//
//  Created by Prasad Tandulwadkar on 25/11/09.
//  Copyright 2009 Mobisoft. All rights reserved.
//

#import "UIUtils.h"


@implementation UIUtils

+(float) heightOfText:(NSString *) text withWidth:(float) width font:(UIFont *) font  lineBreakMode:(UILineBreakMode) lineBreakMode {
	CGSize suggestedSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:lineBreakMode];
	return suggestedSize.height;
}

+ (UIColor *) colorFromHexColor: (NSString *) hexColor { 
	NSUInteger red, green, blue; 
	NSRange range; 
	range.length = 2; 
	range.location = 0; 
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red]; 
	range.location = 2; 
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green]; 
	range.location = 4; 
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue]; 
	return [UIColor colorWithRed:(float)(red/255.0) green:(float)(green/255.0) blue:(float)(blue/255.0) alpha:1.0]; 
} 


@end
