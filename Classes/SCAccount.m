//
//  Account.m
//  safecell
//
//  Created by Ben Scheirman on 4/23/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "SCAccount.h"
#import "AccountRepository.h"
#import "SCProfile.h"
#import "ServerDateFormatHelper.h"
#import "JSONHelper.h"
#import "AppDelegate.h"


NSInteger compareByProfileId(id profile1, id profile2, void *reverse)
{
    SCProfile *profileObj1 = (SCProfile *) profile1;
    SCProfile *profileObj2 = (SCProfile *) profile2;
	
	NSNumber *profileId1 = [NSNumber numberWithInt:profileObj1.profileId];
	NSNumber *profileId2 = [NSNumber numberWithInt:profileObj2.profileId];
	
    NSComparisonResult comparison = [profileId1 compare:profileId2];
	
    if ((BOOL *)reverse == NO) {
        return 0 - comparison;
    }
    return comparison;
}


@implementation SCAccount

@synthesize accountId;
@synthesize masterProfileId;
@synthesize accountCode;
@synthesize apiKey;
@synthesize profiles;

@synthesize activated;

@synthesize archived;
@synthesize pointBalance;
@synthesize chargifyId;
@synthesize status;
@synthesize perksId;
@synthesize validStart,validUntil;

+(SCAccount *) accountWithDictionary: (NSDictionary *) dict {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
	SCAccount *account = [[[SCAccount alloc] init] autorelease];
		
	account.accountId = [[dict objectForKey:@"id"] intValue];
	account.masterProfileId = [[dict objectForKey:@"master_profile_id"] intValue];
    appDelegate.masterProfileKeyValue = [[dict objectForKey:@"master_profile_id"] intValue];
    NSLog(@"account.masterProfileId,appDelegate.masterProfileKeyValue = %d,%d",account.masterProfileId,appDelegate.masterProfileKeyValue);
	account.accountCode = [dict objectForKey:@"validation_code"];
	account.apiKey = [dict objectForKey:@"apikey"];	
	account.archived = [[dict objectForKey:@"activated"] boolValue];	
	account.pointBalance = [[dict objectForKey:@"point_balance"] intValue];
	account.chargifyId = [JSONHelper stringForKey:@"chargify_id" fromDict:dict];
	account.status = [JSONHelper stringForKey:@"status" fromDict:dict];
	account.perksId = [JSONHelper stringForKey:@"perks_id" fromDict:dict];
	
	return account;
}

+(NSString *) currentAccountAPIKey {
	AccountRepository *accountRepository = [[AccountRepository alloc] init];
	SCAccount *account = [accountRepository currentAccount];
	[accountRepository release];
	
	return account.apiKey;
}


+(SCAccount *) accountWithJSON:(NSString *) json {
	NSDictionary *responseDict = [JSONHelper dictFromString: json];
	
	NSDictionary *accountDict = [responseDict objectForKey:@"account"];
	
	SCAccount *account = [SCAccount accountWithDictionary:accountDict];
	
	NSArray * profileDicts= [accountDict objectForKey:@"profiles"];
	
	NSMutableArray *profiles = [[NSMutableArray alloc] initWithCapacity:[profileDicts count]];
	
	for (NSDictionary * dict in profileDicts) {
		SCProfile *profile = [SCProfile profileFromDictionary:dict];
		[profiles addObject:profile];
	}
	
	account.profiles = profiles;
    
	[profiles release];
	
	return account;
}

- (void) dealloc {
	[chargifyId release];
	[status release];
	[perksId release];
	[apiKey release];
	[accountCode release];
	[profiles release];
	[super dealloc];
}

-(void) sortProfilesById {
	int reverseSort = NO;
	[self.profiles sortUsingFunction:compareByProfileId context:&reverseSort];
}

/*
-(int) daysTillAccountExpiry {
	NSDate *currentDate = [NSDate date];
	NSTimeInterval interval = [self.validUntil timeIntervalSinceDate:currentDate];
	if (interval < 0) {
		return -1;
	}
	
	int days = interval / 86400; // (24 * 60 * 60) - seconds of day
	
	NSLog(@"Expiry Date: %@, Current Date: %@", self.validUntil, currentDate);
	NSLog(@"Days Till Expiry: %d, Interval Seconds: %d", days, interval);
	
	return days;
}
*/


@end
