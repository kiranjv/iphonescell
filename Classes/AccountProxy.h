//
//  AccountProxy.h
//  safecell
//
//  Created by Ben Scheirman on 4/22/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAccount.h"
#import "SCProfile.h"
#import "RegisterProfileResponse.h"
#import "NetworkCallFailureTracker.h"
#import "SCActivation.h"


@protocol AccountProxyDelegate;

@interface AccountProxy : NSObject {
	NSObject<AccountProxyDelegate> *_delegate;
	
	NetworkCallFailureTracker *deleteProfileFailureTracker;
	NetworkCallFailureTracker *getProfileFailureTracker;
	NetworkCallFailureTracker *retrieveAccountFailureTracker;
	NetworkCallFailureTracker *activateAccountFailureTracker; 
	NetworkCallFailureTracker *currentProfileStatusFailureTracker;
   
}

@property (nonatomic, assign) NSObject<AccountProxyDelegate> * delegate;

-(void) registerProfile:(SCProfile *)profile;
-(void) validateAccountCode: (NSString *) accountCode;
-(void) getAccount: (int) accountId forProfile: (int) profileId deviceKey:(NSString *) deviceKey;

-(void) checkCurrentProfileStatus;
-(void) getProfile: (int) profileId;
-(void) updateProfile: (SCProfile *) profile;
-(void) deleteProfile:(int)profileId;
-(void) activateAccount;

-(void) retrieveAccountWithUsername: (NSString *) username password: (NSString *) password;

@end

@protocol AccountProxyDelegate 

@optional

-(void) createdAccount: (SCAccount *) account andProfile: (SCProfile *) profile;
-(void) receivedAccount: (SCAccount *) account;
-(void) accountNotFound;
-(void) invalidAccountCreationResponse;
-(void) validatedAccount: (SCAccount *) account;
-(void) activatedAccount: (SCActivation *) activation;
-(void) activationFailedWithMessage: (NSString *) message;
-(void) accountCreationFaliedWithMessage: (NSString *) message;


-(void) receivedCheckedProfileAndAccount: (SCAccount *) account;
-(void) receivedProfile: (SCProfile *) profile;
-(void) createdProfile: (SCProfile *) profile;
-(void) updatedProfile: (SCProfile *) profile;
-(void) deletedProfile;
-(void) retrievedProfile: (SCProfile *) profile;
-(void) invalidCredentials;
-(void) managerCheck;
-(void) profileCheck;


@required
-(void) requestFailed: (ASIHTTPRequest *) request;


@end


//Response Structures
typedef struct {
	BOOL success;
	BOOL accountCreated;
	SCProfile *profile;
	SCAccount *account;
} RegisterProfileResponse;

