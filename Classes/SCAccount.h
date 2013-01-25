//
//  Account.h
//  safecell
//
//  Created by Ben Scheirman on 4/23/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SCAccount : NSObject {
	NSInteger accountId;
	NSInteger masterProfileId;
	NSString *accountCode;
 	NSString *apiKey;
	
	NSMutableArray *profiles;
	BOOL activated;
	
	BOOL archived;
	int pointBalance;
	NSString *chargifyId;
	NSString *status;
	NSString *perksId;
    NSDate *validStart;
    NSDate *validUntil;

}

@property (nonatomic, assign) NSInteger accountId;
@property (nonatomic, assign) NSInteger masterProfileId;
@property (nonatomic, copy) NSString *accountCode;
@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, retain) NSMutableArray *profiles;
@property (nonatomic, assign, getter=isActivated) BOOL activated;

@property (nonatomic, assign) BOOL archived;
@property (nonatomic, assign) int pointBalance;
@property (nonatomic, retain) NSString *chargifyId;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *perksId;

@property (nonatomic, retain) NSDate *validStart;
@property (nonatomic, retain) NSDate *validUntil;

+(SCAccount *) accountWithDictionary: (NSDictionary *) dict;
+(NSString *) currentAccountAPIKey;
+(SCAccount *) accountWithJSON:(NSString *) json;

-(void) sortProfilesById;

//-(int) daysTillAccountExpiry;

@end
