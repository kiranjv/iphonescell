//
//  SCActivation.h
//  safecell
//
//  Created by Mobisoft Infotech on 7/12/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SCActivation : NSObject {
	int activationId;
	int accountId;
	NSString *activationcode;
	NSDate *validUntil;
	NSDate *createdAt;
	NSDate *updatedAt;
}

@property (nonatomic, assign) int activationId;
@property (nonatomic, assign) int accountId;

@property (nonatomic, retain) NSString *activationcode;
@property (nonatomic, retain) NSDate *validUntil;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, retain) NSDate *updatedAt;

+(SCActivation *) activationWithJSON: (NSString *) json;
+(SCActivation *) activationWithDictionary: (NSDictionary *) dict;

@end
