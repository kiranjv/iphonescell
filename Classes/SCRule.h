//
//  SCRule.h
//  safecell
//
//  Created by shail m on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALL_LICENSE_CLASSES  @"all"
#define ALL_LICENSE_CLASSES_DISPLAY_TEXT @"All"

@interface SCRule : NSObject {
	int ruleId;
	int zoneId;
	NSString* zoneName;
	
	BOOL busDirver;
	BOOL novice;
	
	BOOL primary;
	BOOL crashCollection;
	BOOL preemption;
	BOOL allDrivers;
	
	NSString *ruleType;	
	NSString *label;
	
	NSString *whenEnforced;
	NSDate *createdAt;
	NSDate *updatedAt;
	
	NSString *detail;
	NSString *licenses;
	
	BOOL active;
}

@property(nonatomic, assign) int ruleId;
@property(nonatomic, assign) int zoneId;

@property(nonatomic, retain) NSString* zoneName;

@property(nonatomic, assign) BOOL busDirver;
@property(nonatomic, assign) BOOL novice;
@property(nonatomic, assign) BOOL primary;
@property(nonatomic, assign) BOOL crashCollection;

@property(nonatomic, assign) BOOL preemption;
@property(nonatomic, assign) BOOL allDrivers;

@property(nonatomic, assign, getter=isActive) BOOL active;

@property(nonatomic, copy) NSString *whenEnforced;
@property(nonatomic, copy) NSString *ruleType;
@property(nonatomic, copy) NSString *label;

@property(nonatomic, retain) NSDate *createdAt;
@property(nonatomic, retain) NSDate *updatedAt;

@property (nonatomic, retain) NSString *detail;
@property (nonatomic, retain) NSString *licenses;

+(SCRule *) ruleWithDictionary:(NSDictionary *) dict;
-(NSString *) ruleTypeTextForDisplay;
-(NSString *) ruleDescription;

-(BOOL) isSMSOrEmailRule;
-(BOOL) isPhoneRule;
-(BOOL) isSchoolZoneOnly;

-(NSString *) zoneNameForDisplay;
-(NSString *) whenEnforcedForDisplay;

-(BOOL) appliesToLicenseClass: (NSString *) licenseClass;
-(NSMutableArray *) licenseClassNames;

@end
