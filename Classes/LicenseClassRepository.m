//
//  LicenseClassRepository.m
//  safecell
//
//  Created by Mobisoft Infotech on 8/23/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "LicenseClassRepository.h"
#import "FMDatabaseAdditions.h"


static NSString *BASE_SELECT_QUERY = @"SELECT id, key, name, description FROM license_classes"; 


@implementation LicenseClassRepository

-(void) saveLicenseClass: (SCLicenseClass *) licenseClass {
	NSString *query = @"INSERT INTO license_classes (id, key, name, description) VALUES (?, ?, ?, ?)";
	[db executeUpdate:query,
					 [NSNumber numberWithInt:licenseClass.licenseClassId],
					 licenseClass.key,
					 licenseClass.name,
					 licenseClass.description
					 ];
}

-(void) updateLicenseClass: (SCLicenseClass *) licenseClass {
	NSString *query = @"UPDATE license_classes SET key = ?, name = ?, description = ? WHERE id = ?";
	[db executeUpdate:query,
					 licenseClass.key,
					 licenseClass.name,
					 licenseClass.description,
					 [NSNumber numberWithInt:licenseClass.licenseClassId]
					 ];
}

-(BOOL) licenseClassExists: (int) licenseClassId {
	NSString *query = @"SELECT  COUNT(id) FROM  license_classes WHERE id = ?";
	int noOfRows = [db intForQuery:query, [NSNumber numberWithInt:licenseClassId]];
	
	if(noOfRows == 0) {
		return NO;
	} else {
		return YES;
	}	
}

-(void) saveOrUpdateLicenseClass: (SCLicenseClass *) licenseClass {
	if ([self licenseClassExists:licenseClass.licenseClassId]) {
		[self updateLicenseClass:licenseClass];
	} else {
		[self saveLicenseClass:licenseClass];
	}

}

-(NSString *) nameForLicenseClassKey: (NSString *) licenseClassKey {
	NSString *query = @"SELECT name FROM license_classes WHERE key = ?";
	NSString* name = [db stringForQuery:query, licenseClassKey];
	return name;
}

-(SCLicenseClass *) licenseClassWithResultSet: (FMResultSet *) resultSet {
	SCLicenseClass *licenseClass = [[[SCLicenseClass alloc] init] autorelease];
	
	licenseClass.licenseClassId = [resultSet intForColumn:@"id"];
	licenseClass.name = [resultSet stringForColumn:@"name"];
	licenseClass.key = [resultSet stringForColumn:@"key"];
	licenseClass.description = [resultSet stringForColumn:@"description"];

	
	return licenseClass;
}

-(NSArray *) allLicenseClasses {
	NSMutableArray *licenseClasses = [[NSMutableArray alloc] init];
	NSString *query = [NSString stringWithFormat:@"%@ ORDER BY id", BASE_SELECT_QUERY];
	
	FMResultSet *resultSet = [db executeQuery:query];
	
	while ([resultSet next]) {
		SCLicenseClass *licenseClass = [self licenseClassWithResultSet:resultSet];
		[licenseClasses addObject:licenseClass];
	}
	
	[resultSet close];
	
	return licenseClasses;
}

@end
