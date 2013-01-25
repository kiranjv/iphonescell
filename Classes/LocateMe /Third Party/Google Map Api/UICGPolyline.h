//
//  UICGPolyline.h
//  AdsAroundMe
//
//  Created by Adodis on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UICGPolyline : NSObject {
	NSDictionary *dictionaryRepresentation;
	NSArray *vertices;
	NSMutableArray *routePoints;
	NSInteger vertexCount;
	NSInteger length;
}

@property (nonatomic, retain, readonly) NSDictionary *dictionaryRepresentation;
@property (nonatomic, retain, readonly) NSMutableArray *routePoints;
@property (nonatomic, readonly) NSInteger vertexCount;
@property (nonatomic, readonly) NSInteger length;
@property (nonatomic, retain) NSArray *vertices;

+ (UICGPolyline *)polylineWithDictionaryRepresentation:(NSDictionary *)dictionary;
- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary;
- (CLLocation *)vertexAtIndex:(NSInteger)index;
- (void)insertVertexAtIndex:(NSInteger)index inLocation:(CLLocation *)location;

@end
