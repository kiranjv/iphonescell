//
//  ResolvedLocationRepository.m
//  safecell
//
//  Created by shail m on 6/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ResolvedLocationRepository.h"


@implementation ResolvedLocationRepository

-(void) saveResolvedLocation: (SCResolvedLocation *)location {
	NSString *query =	@"INSERT INTO resolved_locations ("
							@"latitude, longitude, sublocality, "
							@"city, state, zip_code "
						@") VALUES ("
							@"?, ?, ?, "
							@"?, ?, ? "
						@")";
	
	[db executeUpdate:query,
	 [[NSNumber numberWithFloat:location.latitude] description],
	 [[NSNumber numberWithFloat:location.longitude] description],
	 location.sublocality,
	 location.city,
	 location.state, 
	 location.zipCode];
	
	location.resolvedLocationId = [self lastInsertRowId];
}

-(SCResolvedLocation *) reslovedLocationWithResultSet: (FMResultSet *) resultSet {
	SCResolvedLocation *resolvedLocation = [[[SCResolvedLocation alloc] init] autorelease];
	
	resolvedLocation.resolvedLocationId = [resultSet intForColumn:@"id"];
	
	NSString *latitudeStr = [resultSet stringForColumn:@"latitude"];
	resolvedLocation.latitude = [latitudeStr floatValue];
	
	NSString *longitudeStr = [resultSet stringForColumn:@"longitude"];
	resolvedLocation.longitude = [longitudeStr floatValue];
	
	resolvedLocation.sublocality = [resultSet stringForColumn:@"sublocality"];
	resolvedLocation.city = [resultSet stringForColumn:@"city"];
	resolvedLocation.state = [resultSet stringForColumn:@"state"];
	resolvedLocation.zipCode = [resultSet stringForColumn:@"zip_code"];
	
	return resolvedLocation;
}

-(SCResolvedLocation *) reslovedLocationWithLatitude: (float) latitude longitude: (float) longitude {
	NSString *query =	@"SELECT "
							@"id, latitude, longitude, "
							@"sublocality, city, state, zip_code "
						@"FROM resolved_locations "
						@"WHERE latitude = ? AND longitude = ?";
	
	FMResultSet *resultSet = [db executeQuery:query, 
							  [[NSNumber numberWithFloat:latitude] description], 
							  [[NSNumber numberWithFloat:longitude] description]];
	
	SCResolvedLocation *resolvedLocation = nil;
	
	if ([resultSet next]) {
		resolvedLocation = [self reslovedLocationWithResultSet:resultSet];
	}
	
	[resultSet close];
	
	return resolvedLocation;
}

@end
