//
//  SCLicenseClass.m
//  safecell
//
//  Created by Mobisoft Infotech on 8/23/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "SCLicenseClass.h"
#import "JSONHelper.h"


@implementation SCLicenseClass

@synthesize licenseClassId;
@synthesize key;
@synthesize name;
@synthesize description;

+(SCLicenseClass *) licenseClassFromJSON: (NSString *) json {
	NSDictionary *dict = [JSONHelper dictFromString:json];
	return [SCLicenseClass licenseClassFromDictionary:dict];
}

+(SCLicenseClass *) licenseClassFromDictionary: (NSDictionary *) wrapperDict {
	SCLicenseClass *licenseClass = [[[SCLicenseClass alloc] init] autorelease];
	
	NSDictionary* dict = [wrapperDict objectForKey:@"license_class"];
	
	licenseClass.licenseClassId = [[dict objectForKey:@"id"] intValue];
	licenseClass.key = [dict objectForKey:@"key"];
	licenseClass.name = [dict objectForKey:@"name"];
	licenseClass.description = [dict objectForKey:@"description"];
	
	return licenseClass;
}

- (void) dealloc {
	
	self.key = nil;
	self.name = nil;
	self.description = nil;
	
	[super dealloc];
}


@end
