//
//  SCLicenseClass.h
//  safecell
//
//  Created by Mobisoft Infotech on 8/23/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SCLicenseClass : NSObject {
	int licenseClassId;
	NSString *key;
	NSString *name;
	NSString *description;
}

@property (nonatomic, assign) int licenseClassId;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;

+(SCLicenseClass *) licenseClassFromJSON: (NSString *) json;
+(SCLicenseClass *) licenseClassFromDictionary: (NSDictionary *) dict;

@end
