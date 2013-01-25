//
//  Profile.h
//  safecell
//
//  Created by Ben Scheirman on 4/19/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCProfile : NSObject<NSCopying> {
	NSString *apiKey;
	
	NSInteger profileId;
	NSInteger accountId;
    NSInteger managerId;
	NSString *firstName;
	NSString *lastName;
	NSString *email;
	NSString *phone;
	
	NSMutableArray *trips;
	UIImage *userImage;
	int levelNo;
	
	NSString *deviceKey;
	
	NSString *licenseClassKey;
	
	NSString *deviceFamily; 
	NSDate *expiresOn;
    NSDate *startsOn;
	NSString *appVersion;
	NSString *status;
	int pointsEarned;
    int licenceSubscrptn;
}

@property (nonatomic, assign) NSInteger profileId;
@property (nonatomic, assign) NSInteger accountId;
@property (nonatomic, assign) NSInteger managerId;
@property (nonatomic, assign) int licenceSubscrptn;
@property (nonatomic, retain) NSString *apiKey;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *deviceKey;

@property (nonatomic, retain) NSString *licenseClassKey;

@property (nonatomic, retain) NSMutableArray *trips;
@property (nonatomic, retain) UIImage *userImage;
@property (nonatomic, assign) int levelNo;

@property (nonatomic, retain) NSString *deviceFamily;
@property (nonatomic, retain) NSDate *expiresOn;
@property (nonatomic, retain) NSDate *startsOn;
@property (nonatomic, retain) NSString *appVersion;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, assign) int pointsEarned;

+(SCProfile *) profileFromJSON: (NSString *) json;
+(SCProfile *) profileFromDictionary: (NSDictionary *) dict;
+(NSString *) driversLicenseNameForKey:(NSString *) key;
 

-(NSString *) JSONRepresentation;

-(NSString *) JSONForPost;

-(void) assignUniqueDeviceKey;
+(int) daysTillAccountExpiry;

@end
