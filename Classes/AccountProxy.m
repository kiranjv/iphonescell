//
//  AccountProxy.m
//  safecell
//
//  Created by Ben Scheirman on 4/22/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "AccountProxy.h"
#import "ASIFormDataRequest.h"
#import "JSONHelper.h"
#import "AccountRepository.h"
#import "ProfileRepository.h"
#import "AlertHelper.h"
#import "AppDelegate.h"
#import "BundleUtils.h"
#import "UserDefaults.h"

@implementation AccountProxy

@synthesize delegate = _delegate;

//data keys
static NSString* MASTER_ACCOUNT_PROFILE_FIRST_NAME = @"account[master_profile_attributes][first_name]";
static NSString* MASTER_ACCOUNT_PROFILE_LAST_NAME = @"account[master_profile_attributes][last_name]";
static NSString* MASTER_ACCOUNT_PROFILE_EMAIL = @"account[master_profile_attributes][email]";
static NSString* MASTER_ACCOUNT_PROFILE_PHONE = @"account[master_profile_attributes][phone]";
static NSString* MASTER_ACCOUNT_PROFILE_DEVICE_KEY = @"account[master_profile_attributes][device_key]";
static NSString* MASTER_ACCOUNT_PROFILE_LICENSE_CLASS_KEY = @"account[master_profile_attributes][license_class_key]";
static NSString* MASTER_ACCOUNT_PROFILE_ORIGINATOR_TOKEN = @"account[originator_token]";
// static NSString* MASTER_ACCOUNT_PROFILE_BUS_DRIVER = @"account[master_profile_attributes][bus_driver]";


static NSString* ACCOUNT_NOT_FOUND = @"Not found";


- (void) dealloc {
	[deleteProfileFailureTracker release];
	[getProfileFailureTracker release];
	[retrieveAccountFailureTracker release];
	[activateAccountFailureTracker release];
	[super dealloc];
}

#pragma mark -
#pragma mark createMasterProfile

-(void)createMasterProfile:(SCProfile *)profile {
	
	NSString *url = [NSString stringWithFormat:@"%@/accounts", [Config baseURL]];
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
	request.requestMethod = @"POST";
	
	[request setPostValue:profile.firstName forKey:MASTER_ACCOUNT_PROFILE_FIRST_NAME];
	[request setPostValue:profile.lastName  forKey:MASTER_ACCOUNT_PROFILE_LAST_NAME];
	[request setPostValue:profile.email		forKey:MASTER_ACCOUNT_PROFILE_EMAIL];
	[request setPostValue:profile.phone     forKey:MASTER_ACCOUNT_PROFILE_PHONE];
	[request setPostValue:profile.deviceKey forKey:MASTER_ACCOUNT_PROFILE_DEVICE_KEY];
	[request setPostValue:profile.licenseClassKey forKey:MASTER_ACCOUNT_PROFILE_LICENSE_CLASS_KEY];
	
	NSString *originatorKey = [UserDefaults valueForKey:kAccountGUID];
	
	if ((originatorKey != nil) && ![originatorKey isEqualToString:@""]) {
		[request setPostValue:originatorKey forKey:MASTER_ACCOUNT_PROFILE_ORIGINATOR_TOKEN];
	} else {
		NSLog(@"WARNING: Create Account - originator key not present.");
	}

	/*
	id busDriver = [NSNumber numberWithBool:profile.busDriver];
	[request setPostValue:busDriver forKey:MASTER_ACCOUNT_PROFILE_BUS_DRIVER];
	*/
	
	request.userInfo = [NSDictionary dictionaryWithObject:@"createMasterProfile" forKey:@"operation"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestDidFinish:)];
	[request setDidFailSelector:@selector(requestDidFail:)];	
	
	NSLog(@"Creating master profile...");
	
	//NSLog(@"Post Data: ");
//	
//	for (NSString *key in [[request postData] allKeys]) {
//	 	NSLog(@"%@=%@", key, [[request postData] objectForKey:key]);
//	}
	
	[request startAsynchronous];
}

- (void)handleCreateMasterProfileResponse:(NSString *)responseString {
	NSDictionary *responseDict = [JSONHelper dictFromString: responseString];
	
	if(responseDict == nil) {
		SimpleAlert(@"Account creation failed", 
					@"Account creation failed due to server error. Please try again later.", 
					@"Ok");
        
		return;
	}	
	
	// NSLog(@"Response Dict: %@", responseDict);
	
	NSDictionary *accountDict = [responseDict objectForKey:@"account"];
	
	SCAccount *account = [SCAccount accountWithDictionary:accountDict];
	
	NSArray * profiles = [accountDict objectForKey:@"profiles"];
	
	NSDictionary *profileDict = [profiles objectAtIndex:0];
	
	// NSLog(@"Profile Dict: %@", profileDict);
	
	SCProfile *profile = [SCProfile profileFromDictionary:profileDict];
	
	AccountRepository *accountRepository = [[AccountRepository alloc] init];
	
	//Delete any existing accounts that may be there
	//because of incomplete transactions before.
	[accountRepository deleteExistingAccount];		 
	
	[accountRepository saveAccount:account];
	[accountRepository release];
	
	//Update profile before saving
	profile.deviceFamily = @"iPhone";
	profile.appVersion = [BundleUtils bundleVersion];
	
	ProfileRepository *profileRepository = [[ProfileRepository alloc] init];
	[profileRepository saveProfile:profile];
	[profileRepository release];	
	
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(createdAccount:andProfile:)]) {
		[self.delegate createdAccount:account andProfile:profile];
	}
	
}


#pragma mark -
#pragma mark createSecondaryProfile

-(void)createSecondaryProfile:(SCProfile *) profile {
	NSString *url = [NSString stringWithFormat:@"%@/profiles", [Config baseURL]];
	
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
	request.requestMethod = @"POST";
	[request addRequestHeader:@"x-api-key" value:profile.apiKey];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	[request appendPostData:[[profile JSONForPost] dataUsingEncoding:NSUTF8StringEncoding]];	
	
	request.userInfo = [NSDictionary dictionaryWithObject:@"createSecondaryProfile" forKey:@"operation"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestDidFinish:)];
	[request setDidFailSelector:@selector(requestDidFail:)];
	
	
	NSLog(@"api key: %@", profile.deviceKey);
	NSLog(@"url: %@", url);
	NSLog(@"x-api-key: %@", profile.apiKey);
	NSLog(@"Content-Type: application/json");
	
	
	NSLog(@"Creating Secondry profile...");
	NSLog(@"Post Data: %@", [profile JSONForPost]);	
	
	
	[request startAsynchronous];
}

-(void) handleCreateSecondaryProfileResponse:(NSString *)responseString {
	
	NSDictionary *responseDict = [JSONHelper dictFromString: responseString];
	
	if(responseDict == nil) {
		SimpleAlert(@"Account creation failed", 
					@"Account creation failed due to server error. Please try again later.", 
					@"Ok");
		return;
	}	
	
	NSDictionary *profileDict = [responseDict objectForKey:@"profile"];
	
	SCProfile *profile = [SCProfile profileFromDictionary:profileDict];
	
	//Update profile before saving
	profile.deviceFamily = @"iPhone";
	profile.appVersion = [BundleUtils bundleVersion];
	
	ProfileRepository *profileRepository = [[ProfileRepository alloc] init];
	[profileRepository saveProfile:profile];
	[profileRepository release];
	
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(createdProfile:)]) {
		[self.delegate createdProfile:profile];
	}
}

-(void)registerProfile:(SCProfile *)profile {
	if(profile.apiKey == nil || [profile.apiKey isBlank]) {		
		[self createMasterProfile:profile];		
	} else {
		[self createSecondaryProfile:profile];
	}
}

#pragma mark -
#pragma mark checkCurrentProfileStatus


-(void) configureCurrentProfileStatusFailureTracker {
	if (currentProfileStatusFailureTracker) {
		[currentProfileStatusFailureTracker release];
		currentProfileStatusFailureTracker = nil;
	}
	currentProfileStatusFailureTracker = [[NetworkCallFailureTracker alloc] initWithRetriesAllowed:3];
	
	[currentProfileStatusFailureTracker trackResponseCodesWithTotalCount:1, 0];
	[currentProfileStatusFailureTracker addTarget:self 
							 startRequestSelector:@selector(startCheckCurrentProfileStatusRequest) 
					 requestFinallyFailedSelector:@selector(checkCurrentProfileStatusFailed:)];
}

-(void) startCheckCurrentProfileStatusRequest {
	AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	SCProfile *currentProfile = appDelegate.currentProfile;
	
	NSString *url = [NSString stringWithFormat:@"%@/accounts/show?account_id=%d&profile_id=%d&device_family=%@&app_version=%@", [Config baseURL], currentProfile.accountId, currentProfile.profileId, currentProfile.deviceFamily, currentProfile.appVersion];
	
	if (currentProfile.deviceKey != nil) {
		url = [NSString stringWithFormat:@"%@&device_key=%@", url, currentProfile.deviceKey];
	}
	
	//NSString *url = [NSString stringWithFormat:@"%@/accounts/show?account_id=%d&profile_id=%d", [Config baseURL], 146, 226];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	NSString *apiKey = [SCAccount currentAccountAPIKey];
	
	[request setTimeOutSeconds:60];
	[request addRequestHeader:@"x-api-key" value:apiKey];
	
	//[request addRequestHeader:@"x-api-key" value:@"4a4b06b9b5e86837cce0643aac661a34ff741974443e987996d8fff83f7332617d532d686c45b62663327445139e2a4bf3e3193a08c31bc1a1c943e71829129d"];
	
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	
	request.userInfo = [NSDictionary dictionaryWithObject:@"checkCurrentProfileStatus" forKey:@"operation"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestDidFinish:)];
	[request setDidFailSelector:@selector(requestDidFail:)];
	
	[request setRequestMethod:@"GET"];
	
	NSLog(@"GET Profile: %@", url);
	NSLog(@"x-api-key: %@", apiKey);
	NSLog(@"Content-Type: application/json");
	
	[request startAsynchronous];
}

-(void) checkCurrentProfileStatusFailed: (ASIHTTPRequest *) request {
	if(self.delegate && [self.delegate respondsToSelector:@selector(requestFailed:)]) {
		[self.delegate requestFailed: request];
	}	
}

-(void) handleCheckCurrentProfileStatus: (NSString *) responseString {
	SCAccount *account = [SCAccount accountWithJSON:responseString];
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(receivedCheckedProfileAndAccount:)]) {
		[self.delegate receivedCheckedProfileAndAccount:account];
	}
}


-(void) checkCurrentProfileStatus {
	[self configureCurrentProfileStatusFailureTracker];
	[currentProfileStatusFailureTracker start];
}

#pragma mark -
#pragma mark getAccount

-(void) getAccount: (int) accountId forProfile: (int) profileId deviceKey:(NSString *) deviceKey {
	
	NSString *url = [NSString stringWithFormat:@"%@/accounts/%d?profile_id=%d&device_key=%@", [Config baseURL], accountId, profileId, deviceKey];
	NSLog(@"getAccount: URL ==> %@", url);
	
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	request.requestMethod = @"GET";
	
	NSString *apiKey = [SCAccount currentAccountAPIKey];
	[request addRequestHeader:@"x-api-key" value:apiKey];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	
	NSLog(@"x-api-key: %@", apiKey);
	NSLog(@"Content-Type: application/json");
	
	request.userInfo = [NSDictionary dictionaryWithObject:@"getAccount" forKey:@"operation"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestDidFinish:)];
	[request setDidFailSelector:@selector(requestDidFail:)];
	
	[request startAsynchronous];
}

-(void) handleGetAccountResponse: (NSString *)responseString {	
	SCAccount *account = [SCAccount accountWithJSON:responseString];
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(receivedAccount:)]) {
		[self.delegate receivedAccount:account];
	}
}

#pragma mark -
#pragma mark validateAccountCode

-(void) validateAccountCode: (NSString *) accountCode {
	NSString *url = [NSString stringWithFormat:@"%@/accounts/%@/validate", [Config baseURL], accountCode];
	
	NSLog(@"ValidateAccountCode: URL ==> %@", url);
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	
	request.userInfo = [NSDictionary dictionaryWithObject:@"validateAccountCode" forKey:@"operation"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestDidFinish:)];
	[request setDidFailSelector:@selector(requestDidFail:)];
	
	NSLog(@"Validating account code...");
	
	[request startAsynchronous];
}

- (void) handleValidateAccountCodeResponse:(NSString *)responseString {	
	if([ACCOUNT_NOT_FOUND isEqualToString: responseString]) {
		if( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(accountNotFound)] ) {
			[self.delegate accountNotFound];
		}
	} else {
		
		NSDictionary *responseDict = [JSONHelper dictFromString: responseString];
		
		if(responseDict == nil) {
			if( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(invalidAccountCreationResponse)] ) {
				[self.delegate invalidAccountCreationResponse];
			}
			
			return;
		}	
		
		// NSLog(@"Response Dict: %@", responseDict);
		
		NSDictionary *accountDict = [responseDict objectForKey:@"account"];
		
		SCAccount *account = [SCAccount accountWithDictionary:accountDict];		
		
		AccountRepository *accountRepository = [[AccountRepository alloc] init];
		
		if(![accountRepository accountExists:account]) {
			//Delete any existing accounts that may be there
			//because of incomplete transactions before.
			[accountRepository deleteExistingAccount];
		}
		
		[accountRepository saveAccount:account];
		
		[accountRepository release];
		
		if( (self.delegate != nil) && [self.delegate respondsToSelector:@selector(validatedAccount:)] ) {
			[self.delegate validatedAccount: account];
		}
	}	
}

#pragma mark -
#pragma mark getProfile


-(void) configureGetProfileFailureTracker: (int) profileId; {
	if (getProfileFailureTracker) {
		[getProfileFailureTracker release];
		getProfileFailureTracker = nil;
	}
	getProfileFailureTracker = [[NetworkCallFailureTracker alloc] initWithRetriesAllowed:3];
	
	NSDictionary *requestInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:profileId], @"profileId", nil];
	getProfileFailureTracker.requestInfo = requestInfo;
	[requestInfo release];
	
	[getProfileFailureTracker trackResponseCodesWithTotalCount:1, 0];
	[getProfileFailureTracker addTarget:self startRequestSelector:@selector(startGetProfileRequest:) requestFinallyFailedSelector:@selector(getProfileRequestFailed:)];
}

-(void) startGetProfileRequest: (NSDictionary *) requestInfo {
	
	NSNumber *profileId = [requestInfo objectForKey:@"profileId"];
	
	NSString *url = [NSString stringWithFormat:@"%@/profiles/%d", [Config baseURL], [profileId intValue]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	NSString *apiKey = [SCAccount currentAccountAPIKey];
	
	[request setTimeOutSeconds:60];
	[request addRequestHeader:@"x-api-key" value:apiKey];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	
	request.userInfo = [NSDictionary dictionaryWithObject:@"getProfile" forKey:@"operation"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestDidFinish:)];
	[request setDidFailSelector:@selector(requestDidFail:)];
	
	[request setRequestMethod:@"GET"];
	
	NSLog(@"GET Profile: %@", url);
	NSLog(@"x-api-key: %@", apiKey);
	NSLog(@"Content-Type: application/json");
	
	[request startAsynchronous];
}

-(void) getProfileRequestFailed: (ASIHTTPRequest *) request {
	if(self.delegate && [self.delegate respondsToSelector:@selector(requestFailed:)]) {
		[self.delegate requestFailed: request];
	}	
}

-(void) getProfile: (int) profileId {
	[self configureGetProfileFailureTracker:profileId];
	[getProfileFailureTracker start];
}


-(void) handleGetProfileResponse: (NSString *) responseString {
	SCProfile *profile = [SCProfile profileFromJSON:responseString];
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(receivedProfile:)]) {
		[self.delegate receivedProfile:profile];
	}
}


#pragma mark -
#pragma mark updateProfile

-(void) updateProfile: (SCProfile *) profile {
	NSString *url = [NSString stringWithFormat:@"%@/profiles/%d", [Config baseURL], profile.profileId];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	
	[request addRequestHeader:@"x-api-key" value:profile.apiKey];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	[request appendPostData:[[profile JSONForPost] dataUsingEncoding:NSUTF8StringEncoding]];	
	
	request.userInfo = [NSDictionary dictionaryWithObject:@"updateProfile" forKey:@"operation"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestDidFinish:)];
	[request setDidFailSelector:@selector(requestDidFail:)];
	
	[request setRequestMethod:@"PUT"]; // Default becomes POST when you use appendPostData: / appendPostDataFromFile: / setPostBody:
	
	NSLog(@"url: %@", url);
	
	
	NSLog(@"x-api-key: %@", profile.apiKey);
	NSLog(@"Content-Type: application/json");
	
	NSLog(@"PUT Data: %@", [profile JSONForPost]);	

	[request startAsynchronous];
}


- (void) handleUpdateProfileResponse:(NSString *)responseString {	
	NSDictionary *responseDict = [JSONHelper dictFromString: responseString];
	
	if(responseDict == nil) {
		SimpleAlert(@"Profile update failed", @"Profile update failed. Please try again.", @"Ok");
		return;
	}	
	
	NSDictionary *profileDict = [responseDict objectForKey:@"profile"];
	
	SCProfile *profile = [SCProfile profileFromDictionary:profileDict];
	
	ProfileRepository *profileRepository = [[ProfileRepository alloc] init];
	[profileRepository updateProfile:profile];
	[profileRepository release];
	
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(updatedProfile:)]) {
		[self.delegate updatedProfile:profile];
	}
}


#pragma mark -
#pragma mark Delete Profile

-(void) configureDeleteProfileFailureTracker: (int) profileId; {
	if (deleteProfileFailureTracker) {
		[deleteProfileFailureTracker release];
		deleteProfileFailureTracker = nil;
	}
	deleteProfileFailureTracker = [[NetworkCallFailureTracker alloc] initWithRetriesAllowed:3];
	
	NSDictionary *requestInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:profileId], @"profileId", nil];
	deleteProfileFailureTracker.requestInfo = requestInfo;
	[requestInfo release];
	
	[deleteProfileFailureTracker trackResponseCodesWithTotalCount:1, 0];
	[deleteProfileFailureTracker addTarget:self startRequestSelector:@selector(startDeleteProfileRequest:) requestFinallyFailedSelector:@selector(deleteProfileRequestFailed:)];
}

-(void) startDeleteProfileRequest: (NSDictionary *) requestInfo {
	
	NSNumber *profileId = [requestInfo objectForKey:@"profileId"];
	
	NSString *url = [NSString stringWithFormat:@"%@/profiles/%d", [Config baseURL], [profileId intValue]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	NSString *apiKey = [SCAccount currentAccountAPIKey];
	
	[request setTimeOutSeconds:60];
	[request addRequestHeader:@"x-api-key" value:apiKey];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	
	request.userInfo = [NSDictionary dictionaryWithObject:@"deleteProfile" forKey:@"operation"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestDidFinish:)];
	[request setDidFailSelector:@selector(requestDidFail:)];
	
	[request setRequestMethod:@"DELETE"];
	
	NSLog(@"Delete Profile: %@", url);
	NSLog(@"x-api-key: %@", apiKey);
	NSLog(@"Content-Type: application/json");
	
	[request startAsynchronous];
}

-(void) deleteProfileRequestFailed: (ASIHTTPRequest *) request {
	if(self.delegate && [self.delegate respondsToSelector:@selector(requestFailed:)]) {
		[self.delegate requestFailed: request];
	}	
}

-(void) deleteProfile: (int) profileId {
	[self configureDeleteProfileFailureTracker:profileId];
	[deleteProfileFailureTracker start];
}

-(void) handleDeleteProfileResponse: (NSString *) responseString {
	if(self.delegate && [self.delegate respondsToSelector:@selector(deletedProfile)]) {
		[self.delegate deletedProfile];
	}
}

#pragma mark -
#pragma mark Retrieve Account

-(void) configureRetrieveAccountFailureTracker: (NSString *) username password: (NSString *) password {
	if (retrieveAccountFailureTracker) {
		[retrieveAccountFailureTracker release];
		retrieveAccountFailureTracker = nil;
	}
	retrieveAccountFailureTracker = [[NetworkCallFailureTracker alloc] initWithRetriesAllowed:3];
	
	NSDictionary *requestInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
								 username, @"username", 
								 password, @"password",
								 nil];
	retrieveAccountFailureTracker.requestInfo = requestInfo;
	[requestInfo release];
	
	[retrieveAccountFailureTracker trackResponseCodesWithTotalCount:1, 0];
	[retrieveAccountFailureTracker addTarget:self startRequestSelector:@selector(startRetrieveAccountRequest:) requestFinallyFailedSelector:@selector(retrieveAccountRequestFailed:)];
}


-(void) startRetrieveAccountRequest: (NSDictionary *) requestInfo {
	
	NSString *url = [NSString stringWithFormat:@"%@/user_session", [Config baseURL]];
  //  NSString *url = [NSString stringWithFormat:@"%@/user_session", [Config localURL]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	
	[request setTimeOutSeconds:60];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	
	request.userInfo = [NSDictionary dictionaryWithObject:@"retrieveAccount" forKey:@"operation"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestDidFinish:)];
	[request setDidFailSelector:@selector(requestDidFail:)];
	
	NSDictionary *requestBody = [NSDictionary dictionaryWithObject:requestInfo forKey:@"user_session"];
	NSString *requestJSON = [JSONHelper jsonFromDict:requestBody];
	[request appendPostData:[requestJSON dataUsingEncoding:NSUTF8StringEncoding]];
	[request setRequestMethod:@"POST"];
	
	NSLog(@"Retrieve Profile: %@", url);
	NSLog(@"Content-Type: application/json");
	NSLog(@"Request Body: %@", requestJSON);
	
	[request startAsynchronous];
}

-(void) retrieveAccountRequestFailed: (ASIHTTPRequest *) request {
	if(self.delegate && [self.delegate respondsToSelector:@selector(requestFailed:)]) {
		[self.delegate requestFailed: request];
	}	
}

-(void) retrieveAccountWithUsername: (NSString *) username password: (NSString *) password {
	[self configureRetrieveAccountFailureTracker:username password:password];
	[retrieveAccountFailureTracker start];
}

-(void) handleRetrieveAccountResponse: (NSString *) responseString {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
	SCAccount *account = [SCAccount accountWithJSON:responseString];
     
    if (appDelegate.managerCheckingValue == 0) {
            
        if(self.delegate && [self.delegate respondsToSelector:@selector(managerCheck)]) {
            [self.delegate managerCheck];
            return;
        }
    }
    
    if ([appDelegate.profileStatusCheck isEqualToString:@"closed"]) {
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(profileCheck)]) {
            [self.delegate profileCheck];
            return;
        }
        
    }
    
	if(self.delegate && [self.delegate respondsToSelector:@selector(receivedAccount:)]) {
		[self.delegate  receivedAccount:account];
       // [self.delegate licenceCheck];
	}
}

-(void) handleRetrieveAccountInvalidCredentials: (ASIHTTPRequest *) request {
	if(self.delegate && [self.delegate respondsToSelector:@selector(invalidCredentials)]) {
		[self.delegate invalidCredentials];
	}
}

#pragma mark -
#pragma mark Activate Account

-(void) configureActivateAccountFailureTracker {
	if (activateAccountFailureTracker) {
		[activateAccountFailureTracker release];
		activateAccountFailureTracker = nil;
	}
	activateAccountFailureTracker = [[NetworkCallFailureTracker alloc] initWithRetriesAllowed:3];
	
	[activateAccountFailureTracker trackResponseCodesWithTotalCount:1, 0];
	[activateAccountFailureTracker addTarget:self startRequestSelector:@selector(startActivateAccountRequest) requestFinallyFailedSelector:@selector(activateAccountRequestFailed:)];
}


-(void) startActivateAccountRequest {
	
	NSString *url = [NSString stringWithFormat:@"%@/account_activation", [Config baseURL]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
	NSString *apiKey = [SCAccount currentAccountAPIKey];
	
	[request setTimeOutSeconds:60];
	[request addRequestHeader:@"x-api-key" value:apiKey];
	[request addRequestHeader:@"Content-Type" value:@"application/json"];
	
	request.userInfo = [NSDictionary dictionaryWithObject:@"activateAccount" forKey:@"operation"];
	[request setDelegate:self];
	[request setDidFinishSelector:@selector(requestDidFinish:)];
	[request setDidFailSelector:@selector(requestDidFail:)];
	
	[request setRequestMethod:@"POST"];
	
	NSLog(@"Activate Account: %@", url);
	NSLog(@"Content-Type: application/json");
	NSLog(@"x-api-key: %@", apiKey);
	
	[request startAsynchronous];
}

-(void) activateAccountRequestFailed: (ASIHTTPRequest *) request {
	if(self.delegate && [self.delegate respondsToSelector:@selector(requestFailed:)]) {
		[self.delegate requestFailed: request];
	}	
}

-(void) activateAccount {
	[self configureActivateAccountFailureTracker];
	[activateAccountFailureTracker start];
}

-(void) handleActivateAccountResponse: (ASIHTTPRequest *) request {
	SCActivation *activation = [SCActivation activationWithJSON:request.responseString];
	
	if (activation == nil) {
		if(self.delegate && [self.delegate respondsToSelector:@selector(requestFailed:)]) {
			[self.delegate requestFailed: request];
		}
		
		return;
	}
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(activatedAccount:)]) {
		[self.delegate activatedAccount: activation];
	}
}

-(void) handleAccountIdAlreadyTaken: (ASIHTTPRequest *) request {
	NSArray *response = [JSONHelper arrayFromString:[request responseString]];
	NSString *message = nil;
	
	if (response.count > 0) {
		response = [response objectAtIndex:0];
		if (response.count > 1) {
			NSString *part2 = [response objectAtIndex:1];
			
			if ([part2 isEqualToString:@"has already been taken"]) {
				message = @"Activation Email has already been sent to your email.";
			}
		}
	}
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(activationFailedWithMessage:)]) {
		[self.delegate activationFailedWithMessage: message];
	}
}

-(void) handleEmailAlreadyTaken: (ASIHTTPRequest *) request {
	NSArray *response = [JSONHelper arrayFromString:[request responseString]];
	NSString *message = nil;
	
	if (response.count > 0) {
		response = [response objectAtIndex:0];
		if (response.count > 1) {
			NSString *part1 = [response objectAtIndex:0];
			NSString *part2 = [response objectAtIndex:1];
			
			if ([part1 isEqualToString:@"email"] && [part2 isEqualToString:@"has already been taken"]) {
				message = @"The email is already associated with another account.";
			}
		}
	}
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(accountCreationFaliedWithMessage:)]) {
		[self.delegate accountCreationFaliedWithMessage: message];
	}
}

#pragma mark -
#pragma mark Request delegate Methods

- (void)requestDidFail:(ASIHTTPRequest *)request {
	NSLog(@"REQUEST FAILED: %@", request.url);
	NSLog(@"Response Status: %d", request.responseStatusCode);
	NSLog(@"OPERATION: %@", [[request userInfo] objectForKey:@"operation"]);
	NSError *error = [request error];
	if (error) {
		NSLog(@"ERROR: %@", [request.error localizedDescription]);
	}
	
	NSString *operation = [[request userInfo] objectForKey:@"operation"];
	
	if([operation isEqualToString:@"deleteProfile"]) {
		if (deleteProfileFailureTracker) {
			[deleteProfileFailureTracker failedForOnce:request];
		}
		
		return;
	}
	
	if([operation isEqualToString:@"getProfile"]) {
		if (getProfileFailureTracker) {
			[getProfileFailureTracker failedForOnce:request];
		}
		
		return;
	}
	
	if([operation isEqualToString:@"retriveProfile"]) {	
		if (retrieveAccountFailureTracker) {
			[retrieveAccountFailureTracker failedForOnce:request];
		}
		
		return;
	}
	
	if([operation isEqualToString:@"checkCurrentProfileStatus"]) {	
		if (currentProfileStatusFailureTracker) {
			[currentProfileStatusFailureTracker failedForOnce:request];
		}
		
		return;
	}
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(requestFailed:)]) {
		[self.delegate requestFailed: request];
	}
}


- (void)requestDidFinish:(ASIHTTPRequest *)request {
	
     NSLog(@"request userInfo is = %@",[request userInfo]);
	NSString *operation = [[request userInfo] objectForKey:@"operation"];
    
    NSLog(@"operation is = %@",operation);
	
	NSLog(@"Retrieved %d bytes from the request for %@", [[request responseData] length], request.url);
	
	NSString *responseString = [request responseString];
	
	NSLog(@"responseStatusCode: %d", request.responseStatusCode);
	NSLog(@"Response: %@", responseString);
    
    
	
	if([operation isEqualToString:@"validateAccountCode"]) {
		[self handleValidateAccountCodeResponse:responseString];
		return;
	}
	
	
	if ([operation isEqualToString:@"activateAccount"]) {
		if (request.responseStatusCode == 422) {
			[self handleAccountIdAlreadyTaken:request];
			return;
		}
	}
	
	if([operation isEqualToString:@"createMasterProfile"]) {
		if (request.responseStatusCode == 422) {
			[self handleEmailAlreadyTaken:request];
			return;
		}
	}
	
	if([operation isEqualToString:@"createSecondaryProfile"]) {
		if (request.responseStatusCode == 422) {
			[self handleEmailAlreadyTaken:request];
			return;
		}
	}
	
	if([operation isEqualToString:@"retrieveAccount"]) {
		if (request.responseStatusCode == 422) {
			[self handleRetrieveAccountInvalidCredentials:request];
			return;
		}
	}
	
	// We are checking response status code after validateAccountCode
	// operation because validateAccountCode uses 404 to specify
	// invalid account code.
	if(request.responseStatusCode != 200) {
		[self requestDidFail:request];
		return;
	}
	
	if([operation isEqualToString:@"deleteProfile"]) {
		[self handleDeleteProfileResponse:responseString];
		return;
	}
	
	if([operation isEqualToString:@"getAccount"]) {
		[self handleGetAccountResponse:responseString];
		return;
	}
	
	if([operation isEqualToString:@"createMasterProfile"]) {
		[self handleCreateMasterProfileResponse:responseString];
		return;
	}
	
	if([operation isEqualToString:@"createSecondaryProfile"]) {
		[self handleCreateSecondaryProfileResponse:responseString];
		return;
	}
	
	if([operation isEqualToString:@"updateProfile"]) {		
		[self handleUpdateProfileResponse:responseString];
		return;
	}
	
	if([operation isEqualToString:@"getProfile"]) {		
		[self handleGetProfileResponse:responseString];
		return;
	}
	
	if([operation isEqualToString:@"retrieveAccount"]) {
		/*if (request.responseStatusCode == 200) {
			//[self handleRetrieveAccountInvalidCredentials:request];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Failure" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
			return;
		}
        else{*/
            [self handleRetrieveAccountResponse:responseString];
            return;
		
        //}
	}
	
	if([operation isEqualToString:@"checkCurrentProfileStatus"]) {		
		[self handleCheckCurrentProfileStatus:responseString];
		return;
	}
	
	if([operation isEqualToString:@"activateAccount"]) {		
		[self handleActivateAccountResponse:request];
		return;
	}
	
}


@end
