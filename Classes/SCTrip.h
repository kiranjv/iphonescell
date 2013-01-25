//
//  SCTrip.h
//  safecell
//
//  Created by Ben Scheirman on 5/10/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SCTrip : NSObject {
	NSInteger tripId;
	NSString *name;
	
	NSMutableArray *trips;
}

@property (nonatomic) NSInteger tripId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSMutableArray *trips;

+(SCTrip *) tripWithDictionary: (NSDictionary *) dict;

@end
