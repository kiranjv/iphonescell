//
//  UICGCheckPoint.h
//  AdsAroundMe
//
//  Created by Adodis on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UICGCheckPoint : NSObject {
	
	NSDictionary *dictionaryRepresentation;
	NSArray *step;
	NSString *summaryHtml;
	NSMutableArray *wayPoints;
	NSMutableArray *mPlaceTitle;
}

@property (nonatomic, retain, readonly) NSDictionary *dictionaryRepresentation;
@property (nonatomic, retain) NSArray *step;
@property (nonatomic, retain, readonly) NSString *summaryHtml;
@property (nonatomic, retain) NSMutableArray *wayPoints;
@property (nonatomic, retain) NSMutableArray *mPlaceTitle;

+ (UICGCheckPoint *)CheckPointWithDictionaryRepresentation:(NSDictionary *)dictionary;
- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary;
@end
