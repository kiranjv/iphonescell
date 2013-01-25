//
//  ServerDateFormatHelper.m
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ServerDateFormatHelper.h"


@implementation ServerDateFormatHelper

+(NSString *) formattedDateForJSON:(NSDate *) date {
	if(date == nil) {
		date = [NSDate date];
	}
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSTimeZone *utc = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [dateFormatter setTimeZone:utc];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    [dateFormatter release];
	
	return formattedDate;
}

+(NSDate *) dateFormServerString:(NSString *) dateStr {
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSTimeZone *utc = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [dateFormatter setTimeZone:utc];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	
    NSDate *date = [dateFormatter dateFromString:dateStr];
    [dateFormatter release];
	
	return date;
	
	/*
	NSString *processedStr = [dateStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
	processedStr = [processedStr stringByReplacingOccurrencesOfString:@"Z" withString:@""];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	NSDate *date = [dateFormatter dateFromString:processedStr];
	
	[dateFormatter release];
	
	return date;
	 */
}

@end
