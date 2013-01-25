//
//  Profile.m
//  safecell
//
//  Created by Ben Scheirman on 4/19/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "SCProfile.h"
#import "SBJSON.h"
#import "JSONHelper.h"
#import "LicenseClassRepository.h"
#import "ServerDateFormatHelper.h"
#import "AppDelegate.h"


@implementation SCProfile

@synthesize profileId, accountId, apiKey, firstName, lastName, email;
@synthesize phone, trips, userImage, levelNo, deviceKey, licenseClassKey;
@synthesize deviceFamily, expiresOn,startsOn, appVersion, status, pointsEarned;
@synthesize managerId,licenceSubscrptn;

+(SCProfile *) profileFromJSON: (NSString *) json {
	NSDictionary *dict = [JSONHelper dictFromString:json];
	return [SCProfile profileFromDictionary:dict];
}

+(SCProfile *) profileFromDictionary: (NSDictionary *) dict {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
	SCProfile *profile = [[[SCProfile alloc] init] autorelease];
	
	profile.profileId = [[dict objectForKey:@"id"] intValue];
	profile.accountId = [[dict objectForKey:@"account_id"] intValue];
    profile.managerId = [[dict objectForKey:@"manager_id"] intValue];
    if ([dict objectForKey:@"license_subsription"]!= [NSNull null]) {
        profile.licenceSubscrptn = [[dict objectForKey:@"license_subsription"] intValue];
        appDelegate.licenseSubsription = [[dict objectForKey:@"license_subsription"] intValue];
    }
    
    appDelegate.managerCheckingValue = [[dict objectForKey:@"manager_id"] intValue];
    NSLog(@"profile.managerId, appId = %d , %d",profile.managerId,appDelegate.managerCheckingValue);
	profile.firstName = [dict objectForKey:@"first_name"];
	profile.lastName = [dict objectForKey:@"last_name"];
	profile.email = [dict objectForKey:@"email"];
	profile.phone = [dict objectForKey:@"phone"];
	profile.deviceKey = [dict objectForKey:@"device_key"];
	profile.licenseClassKey = [dict objectForKey:@"license_class_key"];
    NSLog(@"licencse key = %@",profile.licenseClassKey);
	profile.deviceFamily = [JSONHelper stringForKey:@"device_family" fromDict:dict];
    profile.startsOn = [JSONHelper dateForKey:@"license_startdate" fromDict:dict];
    appDelegate.strStartDate = [JSONHelper dateForKey:@"license_startdate" fromDict:dict];
    NSLog(@"profile.startsOn = %@ ,appDelegate.strStartDate = %@",profile.startsOn,appDelegate.strStartDate);
	profile.expiresOn = [JSONHelper dateForKey:@"expires_on" fromDict:dict];
    appDelegate.strEndDate = [JSONHelper dateForKey:@"expires_on" fromDict:dict];
    NSLog(@"profile.expiresOn = %@ ,appDelegate.strEndDate = %@",profile.expiresOn,appDelegate.strEndDate);
	profile.appVersion = [JSONHelper stringForKey:@"app_version" fromDict:dict];
	profile.status = [JSONHelper stringForKey:@"status" fromDict:dict];
    appDelegate.profileStatusCheck = [JSONHelper stringForKey:@"status" fromDict:dict];
	profile.pointsEarned = [JSONHelper integerForKey:@"points_earned" fromDict:dict];
	
	return profile;
}

-(SCProfile*) copyWithZone: (NSZone*) zone {
    SCProfile *profile = [[SCProfile allocWithZone: zone] init];
	
	profile.profileId = profileId;
	profile.accountId = accountId;
    profile.managerId = managerId;
	profile.firstName = [firstName copy];
	profile.lastName = [lastName copy];
	profile.email = [email copy];
	profile.phone = [phone copy];
	
	profile.apiKey = [apiKey copy];
	profile.deviceKey = [deviceKey copy];
	profile.licenseClassKey = [licenseClassKey copy];
	
	profile.deviceFamily = [deviceFamily copy];
	profile.expiresOn = [expiresOn copy];
	profile.appVersion = [appVersion copy];
	profile.status = [status copy];
	profile.pointsEarned = pointsEarned;
	
	return profile;
}


-(NSString *) JSONForPost {
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: [self proxyForJson], @"profile", nil];
	SBJSON *jsonHelper = [[SBJSON alloc] init];
	jsonHelper.humanReadable = YES;
	NSString *jsonStr = [jsonHelper stringWithObject:dict];
	[jsonHelper release];
	
	return jsonStr;
}

-(NSString *) JSONRepresentation {
	SBJSON *jsonHelper = [[SBJSON alloc] init];
	jsonHelper.humanReadable = YES;
	NSString *jsonStr = [jsonHelper stringWithObject:self];
	[jsonHelper release];
	
	return jsonStr;
}

- (id)proxyForJson {
	 return	[NSDictionary dictionaryWithObjectsAndKeys:
			 [NSNumber numberWithInt:profileId], @"id",
			 [NSNumber numberWithInt:accountId], @"account_id",
             [NSNumber numberWithInt:managerId], @"manager_id",
			 self.firstName, @"first_name",
			 self.lastName, @"last_name",
			 self.email, @"email",
			 self.phone, @"phone",
			 self.deviceKey, @"device_key",
			 self.licenseClassKey, @"license_class_key",
			 self.deviceFamily, @"device_family",
			 [ServerDateFormatHelper formattedDateForJSON:self.expiresOn], @"expires_on",
			 self.appVersion, @"app_version",
			 self.status, @"status",
			 [NSNumber numberWithInt:self.pointsEarned], @"points_earned",
			 nil];
}

-(void) assignUniqueDeviceKey {
	CFUUIDRef uuid = CFUUIDCreate(0);
	CFStringRef deviceKeyStr = CFUUIDCreateString(0, uuid);
	self.deviceKey = (NSString *)deviceKeyStr;
	self.deviceKey = [self.deviceKey stringByReplacingOccurrencesOfString:@"-" withString:@""];
	CFRelease(deviceKeyStr);
	CFRelease(uuid);
}


- (void)dealloc {
	self.trips = nil;
	self.userImage = nil;
	self.apiKey = nil;
	self.firstName = nil;
	self.lastName = nil;
	self.email = nil;
	self.phone = nil;
	self.deviceKey = nil;
	self.licenseClassKey = nil;
	
	self.deviceFamily = nil;
	self.expiresOn = nil;
	self.appVersion = nil;
	self.status = nil;
	
	[super dealloc];
}

+(NSString *) driversLicenseNameForKey:(NSString *) key {
	LicenseClassRepository *licenseClassRepository = [[LicenseClassRepository alloc] init];
	NSString *name = [licenseClassRepository nameForLicenseClassKey:key];
	[licenseClassRepository release];
	
	return name;
}


+(int) daysTillAccountExpiry {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
	/*NSTimeInterval interval = [app.strStartDate timeIntervalSinceDate:app.strEndDate];
	if (interval < 0) {
		return -1;
	}
	int days = interval / 86400; // (24 * 60 * 60) - seconds of day
	NSLog(@"Expiry Date: %@, Current Date: %@", app.strStartDate, app.strEndDate);
	NSLog(@"Days Till Expiry: %d, Interval Seconds: %f", days, interval);*/
    
    
   /* NSDateFormatter *tempFormatter = [[[NSDateFormatter alloc]init]autorelease];
    [tempFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *start = [tempFormatter stringFromDate:app.strStartDate];
    NSDate *startdate = [tempFormatter dateFromString:start];
    NSLog(@"startdate ==%@",startdate);
    
    NSDateFormatter *tempFormatter1 = [[[NSDateFormatter alloc]init]autorelease];
    [tempFormatter1 setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString *end = [tempFormatter1 stringFromDate:app.strEndDate];
    NSDate *toDate = [tempFormatter1 dateFromString:end];
    NSLog(@"toDate ==%@",toDate);
    
    int i = [startdate timeIntervalSince1970];
    int j = [toDate timeIntervalSince1970];
    
    double X = j-i;
    
    int days=(int)((double)X/(3600.0*24.00));
    
	return days;*/
    NSDateFormatter *tempFormatter = [[[NSDateFormatter alloc]init]autorelease];
    [tempFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *start = [tempFormatter stringFromDate:app.strStartDate];
    NSDate *startdate = [tempFormatter dateFromString:start];
    NSLog(@"startdate ==%@",startdate);
    
    NSLog(@"app.licenseSubsription ==%d",app.licenseSubsription);
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:app.licenseSubsription];
    NSDate *expireDate = [gregorian dateByAddingComponents:offsetComponents toDate:startdate options:0];
    app.strExpiredDate = expireDate;
    NSLog(@"expireDate ==%@",expireDate);
    
    if ([startdate compare:[NSDate date]] == NSOrderedDescending) {
       /* NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setDay:-1];
        NSDate *nextDate = [gregorian dateByAddingComponents:offsetComponents toDate:startdate options:0];
        NSLog(@"2 nextDate %@", nextDate);*/
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        NSString *modifiedStr = [formatter stringFromDate:startdate];
        app.futuredateString = modifiedStr;
        NSLog(@"future  Date  ==%@", app.futuredateString);
        //[modifiedStr release];
        return 0;
        
    }
   
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval secondsBetween = [expireDate timeIntervalSinceDate:currentDate];
    int numberOfDays = secondsBetween / 86400;
    NSLog(@"There are %d days in between the two dates.", numberOfDays);
    
    NSDateComponents *countdown = [[NSCalendar currentCalendar] 
                                   components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) 
                                   fromDate:currentDate
                                   toDate:expireDate 
                                   options:0];
    NSLog(@"count down = %@",countdown);
    return numberOfDays;
    
}
@end
