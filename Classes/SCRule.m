//
//  SCRule.m
//  safecell
//
//  Created by shail m on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SCRule.h"
#import "ServerDateFormatHelper.h"
#import "LicenseClassRepository.h"


@implementation SCRule

@synthesize ruleId;
@synthesize zoneId;
@synthesize zoneName;

@synthesize busDirver;
@synthesize novice;

@synthesize primary;
@synthesize crashCollection;
@synthesize preemption;
@synthesize allDrivers;

@synthesize ruleType;	
@synthesize label;
@synthesize detail;

@synthesize whenEnforced;
@synthesize createdAt;
@synthesize updatedAt;

@synthesize active;
@synthesize licenses;


static NSString *RULE_ID = @"id";
static NSString *ZONE_ID = @"zone_id";
static NSString *ZONE_NAME = @"zone_name";

static NSString *BUS_DRIVER = @"busdriver";
static NSString *NOVICE = @"novice";

static NSString *PRIMARY = @"primary";
static NSString *CRASH_COLLECTION = @"crash_collection";
static NSString *PREEMPTION = @"preemption";
static NSString *ALL_DRIVERS = @"alldrivers";

static NSString *RULE_TYPE = @"rule_type";
static NSString *LABEL = @"label";

static NSString *WHEN_ENFORCED = @"when_enforced";
static NSString *CREATED_AT = @"created_at";
static NSString *UPDATED_AT = @"updated_at";

static NSString *DETAIL = @"detail";
static NSString *LICENSES = @"licenses";

+(SCRule *) ruleWithDictionary:(NSDictionary *) dict {
	SCRule *rule = [[[SCRule alloc] init] autorelease];
	
	rule.ruleId = [[dict objectForKey:RULE_ID] intValue];
	rule.zoneId = [[dict objectForKey:ZONE_ID] intValue];
	rule.zoneName = [dict objectForKey:ZONE_NAME];
	
	rule.busDirver = [[dict objectForKey:BUS_DRIVER] boolValue];
	rule.novice = [[dict objectForKey:NOVICE] boolValue];
	rule.primary = [[dict objectForKey:PRIMARY] boolValue];
	rule.crashCollection = [[dict objectForKey:CRASH_COLLECTION] boolValue];
	rule.preemption = [[dict objectForKey:PREEMPTION] boolValue];
	
	id allDriversRule = [dict objectForKey:ALL_DRIVERS];
	if ((!allDriversRule) || ((NSNull *)allDriversRule == [NSNull null])) {
		rule.allDrivers = NO;
	} else {
		rule.allDrivers = YES;
	}

	rule.whenEnforced = [dict objectForKey:WHEN_ENFORCED];
	rule.ruleType = [dict objectForKey:RULE_TYPE];
	rule.label = [dict objectForKey:LABEL];
	rule.detail = [dict objectForKey:DETAIL];
	rule.licenses = [dict objectForKey:LICENSES];
	
	NSString *createdAtStr = [dict objectForKey:CREATED_AT];
	NSString *updatedAtStr = [dict objectForKey:UPDATED_AT];
	
	rule.createdAt = [ServerDateFormatHelper dateFormServerString:createdAtStr];
	rule.updatedAt = [ServerDateFormatHelper dateFormServerString:updatedAtStr];
		
	return rule;
}

- (void) dealloc {
	[zoneName release];
	[ruleType release];
	[label release];
	[detail release];
	
	[whenEnforced release];
	[createdAt release];
	[updatedAt release];
	[licenses release];
	
	[super dealloc];
}

-(BOOL) isSchoolZoneOnly {
	NSString *whenEnforcedStr = EmptyIfNull(self.whenEnforced);
	NSLog(@"whenEnforcedStr: %@", whenEnforcedStr);
	return [whenEnforcedStr isEqualToString:@"school_zone"];
}

-(BOOL) isSMSOrEmailRule {
	NSString *ruleTypeStr = EmptyIfNull(self.ruleType);
	if ([ruleTypeStr isEqualToString:@"sms"] || [ruleTypeStr isEqualToString:@"email"]) {
		return YES;
	}
	
	return NO;
}

-(BOOL) isPhoneRule {
	NSString *ruleTypeStr = EmptyIfNull(self.ruleType);
	if ([ruleTypeStr isEqualToString:@"phone"]) {
		return YES;
	}
	
	return NO;
}

-(NSString *) ruleTypeTextForDisplay {
	if ([self.ruleType isEqualToString:@"sms"]) {
		return @"SMS";
	}
	
	if ([self.ruleType isEqualToString:@"email"]) {
		return @"Email";
	}
	
	if ([self.ruleType isEqualToString:@"phone"]) {
		return @"Cellphone";
	}
	
	return self.ruleType;
}
//
//-(void)setRuleType:(NSString *)newRuleType {
//	if (newRuleType == ruleType) {
//		return;
//	}
//	
//	if (newRuleType == nil) {
//		newRuleType = @"";
//	}
//	
//	if (ruleType != nil) {
//		[ruleType release];
//	}
//	
//	ruleType = [newRuleType copy];
//}

-(NSString *) ruleDescription {
	NSMutableString *description = [[[NSMutableString alloc] init] autorelease];
	
	if (self.primary) {
		[description appendString: @"Primary Rule: Yes"];
	} else {
		[description appendString: @"Secondary Rule: Yes"];
	}

	
	if (self.crashCollection) {
		[description appendString: @", Crash Collection: Yes"];
	} else {
		[description appendString: @", Crash Collection: No"];
	}
	
	if (self.preemption) {
		[description appendString: @", Preemption: Yes"];
	} else {
		[description appendString: @", Preemption: No"];
	}

	if (self.whenEnforced != nil) {
		[description appendFormat: @", When Enforced: %@", [self whenEnforcedForDisplay]];
	}
	
	return description;
}

-(NSString *) zoneNameForDisplay {
	int indexOfComma = [self.zoneName indexOfString:@","];
	if (indexOfComma != NSNotFound) {
		return [zoneName substringFrom:0 to:indexOfComma];
	}
	
	return self.zoneName;
}

-(NSString *) whenEnforcedForDisplay {
	if (self.whenEnforced != nil) {
		NSString *processed = [self.whenEnforced stringByReplacingOccurrencesOfString:@"_" withString:@" "];
		processed = [processed capitalizedString];
		
		return processed;
	} else {
		return @"";
	}
}

-(BOOL) appliesToLicenseClass: (NSString *) licenseClass {
	
	if(!self.licenses) {
		return NO;
	}
	
	if((NSNull *)self.licenses == [NSNull null]) {
		return NO;
	}
	
	if ([self.licenses isEqualToString:ALL_LICENSE_CLASSES]) {
		return YES;
	}
		 
	NSArray *individialLicenseClasses = [self.licenses componentsSeparatedByString:@"|"];
	
	for (NSString * licenseClassStr in individialLicenseClasses) {
		licenseClassStr = [licenseClassStr stringByStrippingWhitespace];
		if ([licenseClassStr isEqualToString:licenseClass]) {
			return YES;
		}
	}
	
	return NO;
}

-(NSMutableArray *) licenseClassNames {
	
	if([self.licenses isEqualToString:ALL_LICENSE_CLASSES]) {
		return [NSMutableArray arrayWithObject:ALL_LICENSE_CLASSES_DISPLAY_TEXT];
	} 
	
	
	NSArray *individialLicenseClasses = [self.licenses componentsSeparatedByString:@"|"];
	NSMutableArray *licenseClassNames = [NSMutableArray arrayWithCapacity:individialLicenseClasses.count];
	LicenseClassRepository *licenseClassRepository = [[LicenseClassRepository alloc] init];
	for (NSString * licenseClassStr in individialLicenseClasses) {
		licenseClassStr = [licenseClassStr stringByStrippingWhitespace];
		NSString *licenseClassName = [licenseClassRepository nameForLicenseClassKey:licenseClassStr];
		if (!licenseClassName) {
			licenseClassName = licenseClassStr;
		}
		
		[licenseClassNames addObject:licenseClassName];
	}
	[licenseClassRepository release];
	
	return licenseClassNames;
}

@end
