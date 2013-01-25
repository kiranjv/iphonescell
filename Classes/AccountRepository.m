//
//  AccountRepository.m
//  safecell
//
//  Created by Ben Scheirman on 5/13/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "AccountRepository.h"
#import "FMDatabaseAdditions.h"


@implementation AccountRepository

-(SCAccount *)currentAccount {
	NSString *query =	@"SELECT "
							@"id, master_profile_id, api_key, account_code, archived, "
							@"point_balance, chargify_id, status, perks_id "
						@"FROM accounts LIMIT 0 , 1";
	
	FMResultSet *resultSet = [db executeQuery:query];	
	
	SCAccount *account = nil;
	
	if([resultSet next]) {
		account = [self accountFromResultSet:resultSet];
	}
	[resultSet close];
	
	return account;
}

-(void)saveAccount:(SCAccount *)account {
	NSString * query = @"INSERT INTO accounts ("
							@"id, master_profile_id, api_key, account_code, "
							@"archived, point_balance, chargify_id, status, perks_id "
						@") VALUES ( "
							@"?, ?, ?, ?, "
							@"?, ?, ?, ?, ? "
						@")";
	
	[db executeUpdate:query, 
					[NSNumber numberWithInt:account.accountId],
					[NSNumber numberWithInt:account.masterProfileId],
					account.apiKey,
					account.accountCode,
					[NSNumber numberWithBool:account.archived],
					[NSNumber numberWithInt:account.pointBalance],
					account.chargifyId,
					account.status,
					account.perksId];
}

-(BOOL) accountExists: (SCAccount *) account {
	NSString *query = @"SELECT COUNT(id) FROM accounts WHERE api_key = ?";
	
	int count = [db intForQuery:query, account.apiKey];
	
	if(count > 0) {
		return TRUE;
	} else {
		return FALSE;
	}
}

-(void) deleteExistingAccount {
	NSString *query = @"DELETE FROM accounts WHERE 1";
	
	[db executeUpdate:query];
}

-(SCAccount *) accountFromResultSet: (FMResultSet *) resultSet {
	SCAccount *account = [[[SCAccount alloc] init] autorelease];
	
	account.accountId = [resultSet intForColumn:@"id"];
	account.masterProfileId = [resultSet intForColumn:@"master_profile_id"];
	account.apiKey = [resultSet stringForColumn:@"api_key"];
	account.accountCode = [resultSet stringForColumn:@"account_code"];
	account.archived = [resultSet boolForColumn:@"archived"];
	account.pointBalance = [resultSet intForColumn:@"point_balance"];
	account.chargifyId = [resultSet stringForColumn:@"chargify_id"];
	account.status = [resultSet stringForColumn:@"status"];
	account.perksId = [resultSet stringForColumn:@"perks_id"];
	
	return account;
}

@end
