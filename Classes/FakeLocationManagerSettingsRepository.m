//
//  FakeLocationManagerSettingsRepository.m
//  safecell
//
//  Created by shail m on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FakeLocationManagerSettingsRepository.h"
#import "FMDatabaseAdditions.h"

static NSString *LAST_USED_DATA_FILE = @"last_used_data_file";

@implementation FakeLocationManagerSettingsRepository

-(void) setLastUsedDataFile:(NSString *) fileName {
	NSString *query =	@"UPDATE fake_location_manager_settings SET "
							@"value = ? "
						@"WHERE item = ?";
	[db executeUpdate:query, fileName, LAST_USED_DATA_FILE];
}

-(NSString *) lastUsedDataFile {
	NSString *query = @"SELECT value FROM fake_location_manager_settings WHERE item = ?";
	return [db stringForQuery:query, LAST_USED_DATA_FILE];
}


@end
