//
//  JSONHelper.m
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JSONHelper.h"
#import "SBJSON.h"
#import "ServerDateFormatHelper.h"

@implementation JSONHelper  

+(NSDictionary *) dictFromString:(NSString *) jsonStr {
	SBJSON *jsonHelper = [[SBJSON alloc] init];
	id obj = [jsonHelper objectWithString:jsonStr];
	[jsonHelper release];
	
	if([obj isKindOfClass:[NSDictionary class]]) {
		NSDictionary * dict = (NSDictionary *) obj;
		return dict;
	} else {
		return nil;
	}
	
}

+(NSArray *) arrayFromString:(NSString *) jsonStr {
	SBJSON *jsonHelper = [[SBJSON alloc] init];
	id obj = [jsonHelper objectWithString:jsonStr];
	[jsonHelper release];
	
	if([obj isKindOfClass:[NSArray class]]) {
		NSArray * arr = (NSArray *) obj;
		return arr;
	} else {
		return nil;
	}
}

+(NSString *) jsonFromDict: (NSDictionary *) dict {
	SBJSON *jsonHelper = [[SBJSON alloc] init];
	NSString *json = [jsonHelper stringWithObject:dict];
	[jsonHelper release];
	return json;
}

+(NSDate *) dateForKey: (NSString *) key fromDict: (NSDictionary *) dict {
	id obj = [dict objectForKey:key];
	
	if ((!obj) || ((NSNull *)obj == [NSNull null])) {
		return nil;
	} else {
		NSString *dateStr  = (NSString *)obj;
		return [ServerDateFormatHelper dateFormServerString:dateStr];
	}
}

+(NSString *) stringForKey: (NSString *) key fromDict: (NSDictionary *) dict {
	id obj = [dict objectForKey:key];
	
	if ((!obj) || ((NSNull *)obj == [NSNull null])) {
		return nil;
	} else {
		return (NSString *)obj;
	}
}

+(BOOL) boolForKey: (NSString *) key fromDict: (NSDictionary *) dict {
	id obj = [dict objectForKey:key];
	
	if ((!obj) || ((NSNull *)obj == [NSNull null])) {
		return NO;
	} else {
		return [obj boolValue];
	}
}

+(int) integerForKey: (NSString *) key fromDict: (NSDictionary *) dict {
	id obj = [dict objectForKey:key];
	
	if ((!obj) || ((NSNull *)obj == [NSNull null])) {
		return 0;
	} else {
		return [obj intValue];
	}
}

@end
