//
//  SCActivation.m
//  safecell
//
//  Created by Mobisoft Infotech on 7/12/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "SCActivation.h"
#import "ServerDateFormatHelper.h"
#import "JSONHelper.h"

static NSString *ACTIVATION = @"account_activation";
static NSString *ACTIVATION_ID = @"id";
static NSString *ACCOUNT_ID = @"account_id";
static NSString *ACTIVATION_CODE = @"activation_code";
static NSString *VALID_UNTIL = @"valid_until";
static NSString *CREATED_AT = @"created_at";
static NSString *UPDATED_AT = @"updated_at";


@implementation SCActivation

@synthesize activationId;
@synthesize accountId;
@synthesize activationcode;
@synthesize validUntil;
@synthesize createdAt;
@synthesize updatedAt;

+(SCActivation *) activationWithJSON: (NSString *) json {
	NSDictionary *dict = [JSONHelper dictFromString:json];
	dict = [dict objectForKey:ACTIVATION];
	
	if (dict == nil) {
		return nil;
	}
	
	return [SCActivation activationWithDictionary:dict];
}

+(SCActivation *) activationWithDictionary: (NSDictionary *) dict {
	
	SCActivation *activation = [[[SCActivation alloc] init] autorelease];
	
	activation.activationId = [[dict objectForKey:ACTIVATION_ID] intValue];
	activation.accountId = [[dict objectForKey:ACCOUNT_ID] intValue];
	activation.activationcode = [dict objectForKey:ACTIVATION_CODE];	
	id validUntilDateStr = [dict objectForKey:VALID_UNTIL];
	if (validUntilDateStr != [NSNull null]) {
		activation.validUntil = [ServerDateFormatHelper dateFormServerString:validUntilDateStr];
	}
	
	id createdAtDateStr = [dict objectForKey:CREATED_AT];
	if (createdAtDateStr != [NSNull null]) {
		activation.createdAt = [ServerDateFormatHelper dateFormServerString:createdAtDateStr];
	}
	
	id updatedAtDateStr = [dict objectForKey:UPDATED_AT];
	if (updatedAtDateStr != [NSNull null]) {
		activation.updatedAt = [ServerDateFormatHelper dateFormServerString:updatedAtDateStr];
	}
	
	return activation;
}

- (void) dealloc {
	[activationcode release];
	[validUntil release];
	[createdAt release];
	[updatedAt release];
	[super dealloc];
}


@end
