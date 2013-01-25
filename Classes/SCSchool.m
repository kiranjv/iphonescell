//
//  untitled.m
//  safecell
//
//  Created by shail m on 6/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SCSchool.h"
#import "ServerDateFormatHelper.h"


@implementation SCSchool

@synthesize schoolId;

@synthesize name;
@synthesize city;
@synthesize address;
@synthesize state;
@synthesize zipcode;

@synthesize latitude;
@synthesize longitude;

@synthesize distance;

@synthesize createdAt;
@synthesize updatedAt;


static NSString *SCHOOL_ID = @"id";

static NSString *NAME = @"name";
static NSString *CITY = @"city";
static NSString *ADDRESS = @"address";
static NSString *STATE = @"state";
static NSString *ZIPCODE = @"zipcode";

static NSString *LATITUDE = @"latitude";
static NSString *LONGITUDE = @"longitude";

static NSString * DISTANCE = @"distance";

static NSString * CREATED_AT = @"created_at";
static NSString * UPDATED_AT = @"updated_at";


+(SCSchool *) schoolWithDictionary:(NSDictionary *) dict {
	SCSchool *school = [[[SCSchool alloc] init] autorelease];
	
	school.schoolId = [[dict objectForKey:SCHOOL_ID] intValue];
	
	school.name = [dict objectForKey:NAME];
	school.city = [dict objectForKey:CITY];
	school.address = [dict objectForKey:ADDRESS];
	school.state = [dict objectForKey:STATE];
	school.zipcode = [dict objectForKey:ZIPCODE];
	
	school.latitude = [[dict objectForKey:LATITUDE] floatValue];
	school.longitude = [[dict objectForKey:LONGITUDE] floatValue];
	
	school.distance = [[dict objectForKey:DISTANCE] floatValue];
	
	NSString *createdAt = [dict objectForKey:CREATED_AT];
	NSString *updatedAt = [dict objectForKey:UPDATED_AT];
	
	school.createdAt = [ServerDateFormatHelper dateFormServerString:createdAt];
	school.updatedAt = [ServerDateFormatHelper dateFormServerString:updatedAt];
	
	return school;
}


- (void) dealloc {
	[name release];
	[city release];
	[address release];
	[state release];
	[zipcode release];
	[createdAt release];
	[updatedAt release];
	
	[super dealloc];
}


@end
