//
//  SCJourneyEvent.h
//  safecell
//
//  Created by shail m on 5/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SCJourneyEvent : NSObject {
	int eventId;
	int journeyId;
	
	float points;
	
	NSString *near;
	NSString *description;
	
	NSDate *timestamp;
}


@property(nonatomic, assign) int eventId;
@property(nonatomic, assign) int journeyId;
@property(nonatomic, assign) float points;

@property(nonatomic, retain) NSString *near;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSDate *timestamp;

@property(nonatomic, readonly) BOOL isInterruption;

+(SCJourneyEvent *) eventWithDictionary: (NSDictionary *) dict;
+(SCJourneyEvent *) eventWithJSON: (NSString *) json;

@end
