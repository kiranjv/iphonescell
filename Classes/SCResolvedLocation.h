//
//  SCResolvedLocations.h
//  safecell
//
//  Created by shail m on 6/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SCResolvedLocation : NSObject {
	int resolvedLocationId;
	
	float latitude;
	float longitude;
	
	NSString *sublocality;
	NSString *city;
	NSString *state;
	NSString *zipCode;
}

@property(nonatomic, assign) int resolvedLocationId;
@property(nonatomic, assign) float latitude;
@property(nonatomic, assign) float longitude;

@property(nonatomic, retain) NSString *sublocality;
@property(nonatomic, retain) NSString *city;
@property(nonatomic, retain) NSString *state;
@property(nonatomic, retain) NSString *zipCode;

@end
