//
//  untitled.h
//  safecell
//
//  Created by shail m on 6/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCSchool : NSObject {
	int schoolId;
	
	NSString *name;
	NSString *city;
	NSString *address;
	NSString *state;
	NSString *zipcode;
	
	float latitude;
	float longitude;
	
	float distance;
	
	NSDate *createdAt;
	NSDate *updatedAt;
}

@property(nonatomic, assign) int schoolId;

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *city;
@property(nonatomic, retain) NSString *address;
@property(nonatomic, retain) NSString *state;
@property(nonatomic, retain) NSString *zipcode;

@property(nonatomic, assign) float latitude;
@property(nonatomic, assign) float longitude;

@property(nonatomic, assign) float distance;

@property(nonatomic, retain) NSDate *createdAt;
@property(nonatomic, retain) NSDate *updatedAt;

+(SCSchool *) schoolWithDictionary:(NSDictionary *) dict;

@end
