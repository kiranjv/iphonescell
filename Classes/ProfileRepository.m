//
//  ProfileRepository.m
//  safecell
//
//  Created by Ben Scheirman on 4/20/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "ProfileRepository.h"
#import "SCProfile.h"
#import "FMDatabaseAdditions.h"
#import "AccountRepository.h"
#import "SCAccount.h"

@implementation ProfileRepository

-(BOOL)profileExists {
	NSString *query = @"SELECT COUNT(id) FROM profiles";
	
	int noOfRows = [db intForQuery:query];
	
	if(noOfRows == 0) {
		return NO;
	} else {
		return YES;
	}
}

-(BOOL) profileExists: (SCProfile *) profile {
	NSString *query = @"SELECT COUNT(id) FROM profiles WHERE id = ?";
	
	int noOfRows = [db intForQuery:query];
	
	if(noOfRows == 0) {
		return NO;
	} else {
		return YES;
	}
}

-(SCProfile *)currentProfile { 
	NSString *query =	@"SELECT " 
							@"id, first_name, last_name, "
							@"email, phone, account_id, device_key, license_class_key, "
							@"device_family, expires_on, app_version, status, points_earned "
						@"FROM profiles LIMIT 0, 1";
	
	FMResultSet *resultSet = [db executeQuery:query];
	
	SCProfile *profile = nil;
	
	if([resultSet next]) {
		profile = [self profileFromResultSet:resultSet];	
	}
	[resultSet close];
							
	return profile;
}

-(void) saveProfile: (SCProfile *) profile {
	NSString *query =	@"INSERT INTO profiles ("
							@"id, first_name, last_name, email, phone, account_id, device_key, license_class_key, "
							@"device_family, expires_on, app_version, status, points_earned "
						@") VALUES ( "
							@"?, ?, ?, ?, ?, ?, ?, ?, "
							@"?, ?, ?, ?, ? "
						@")";
	
	[db executeUpdate:query,
					[NSNumber numberWithInt:profile.profileId],
					profile.firstName,
					profile.lastName,
					profile.email,
					profile.phone,
					[NSNumber numberWithInt:profile.accountId],
					profile.deviceKey,
					profile.licenseClassKey,
					profile.deviceFamily,
					profile.expiresOn,
					profile.appVersion,
					profile.status,
					[NSNumber numberWithInt:profile.pointsEarned]
	 ];
}

-(void) updateProfile: (SCProfile *) profile {
	NSString *query =	@"UPDATE profiles SET "
							@"first_name = ?, last_name = ?, "
							@"email = ?, phone = ?, account_id = ?, device_key = ?, license_class_key = ?, "
							@"device_family = ?, expires_on = ?, app_version = ?, status = ?, points_earned = ? "
						@"WHERE id = ?";
	[db executeUpdate:query,
					 profile.firstName,
					 profile.lastName,
					 profile.email,
					 profile.phone,
					 [NSNumber numberWithInt:profile.accountId],
					 profile.deviceKey,
					 profile.licenseClassKey,
					 profile.deviceFamily,
					 profile.expiresOn,
					 profile.appVersion,
					 profile.status,
					 [NSNumber numberWithInt:profile.pointsEarned],
					 [NSNumber numberWithInt:profile.profileId]];
}

-(SCProfile *) profileFromResultSet: (FMResultSet *) resultSet {
	SCProfile * profile = [[[SCProfile alloc] init] autorelease];
	
	profile.profileId = [resultSet intForColumn:@"id"];
	profile.firstName = [resultSet stringForColumn:@"first_name"];
	profile.lastName = [resultSet stringForColumn:@"last_name"];
	profile.email = [resultSet stringForColumn:@"email"];
	profile.phone = [resultSet stringForColumn:@"phone"];	
	profile.accountId = [resultSet intForColumn:@"account_id"];
	profile.deviceKey = [resultSet stringForColumn:@"device_key"];
	profile.licenseClassKey = [resultSet stringForColumn:@"license_class_key"];
	
	profile.deviceFamily = [resultSet stringForColumn:@"device_family"];
	profile.expiresOn = [resultSet dateForColumn:@"expires_on"];
	profile.appVersion = [resultSet stringForColumn:@"app_version"];
	profile.status = [resultSet stringForColumn:@"status"];
	profile.pointsEarned = [resultSet intForColumn:@"points_earned"];
	
	AccountRepository *accountRepository = [[AccountRepository alloc] init];
	SCAccount *currentAccount = [accountRepository currentAccount];
	[accountRepository release];
	
	profile.apiKey = currentAccount.apiKey;
	
	return profile;
}

-(void) deleteProfile {
	NSString *query = @"DELETE FROM profiles WHERE 1";
	
	[db executeUpdate:query];
}

@end
