//
//  WayPoint.m
//  safecell
//
//  Created by shail on 07/05/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "SCWaypoint.h"
#import "LocationUtils.h"
#import "ServerDateFormatHelper.h"

#define kTimeStampDateFormat @"yyyy-MM-dd HH:mm:ss zzz"


@implementation SCWaypoint

@synthesize waypointId;
@synthesize journeyId;
@synthesize timeStamp;
@synthesize latitude;
@synthesize longitude;
@synthesize estimatedSpeed;
@synthesize background;

-(SCWaypoint *) initWithCLLocation: (CLLocation *) location journeyId: (int) journey {
	self = [super init];
	if (self != nil) {
		self.journeyId = journey;
		self.latitude = location.coordinate.latitude;
		self.longitude = location.coordinate.longitude;
		self.timeStamp = location.timestamp;
		self.estimatedSpeed = 0;
		self.background = NO;
	}
	return self;	
}

+(SCWaypoint *) waypointWithServerDictionary: (NSDictionary *) dict {
	SCWaypoint *waypoint = [[[SCWaypoint alloc] init] autorelease];
	 NSLog(@"dictionary Values in SCWaypoint = %@",dict);
	waypoint.waypointId = [[dict objectForKey:@"id"] intValue];	
	waypoint.journeyId = [[dict objectForKey:@"journey_id"] intValue];	
	waypoint.latitude = [[dict objectForKey:@"latitude"] doubleValue];
	 NSLog(@"waypointserver.latitude = %f",waypoint.latitude);
	waypoint.longitude = [[dict objectForKey:@"longitude"] doubleValue];
	 NSLog(@"waypointserver.longitude = %f",waypoint.longitude);
	waypoint.estimatedSpeed = [[dict objectForKey:@"estimated_speed"] floatValue];
     NSLog(@"waypointserver.estimatedSpeed = %f",waypoint.estimatedSpeed);
	waypoint.timeStamp = [ServerDateFormatHelper dateFormServerString:[dict objectForKey:@"timestamp"]];
	
	if (kWaypointUseBackgroundField) {
		id backgroundObj = [dict objectForKey:@"background"];
		
		if (backgroundObj == nil) {
			waypoint.background = NO;
		} else {
			waypoint.background = [backgroundObj boolValue];
		}
	}
	
	return waypoint;
}
 
+(SCWaypoint *) waypointWithDictionary: (NSDictionary *) dict {
    
    NSLog(@"dictionary Values in SCWaypoint = %@",dict);
	SCWaypoint *waypoint = [[[SCWaypoint alloc] init] autorelease];
	waypoint.journeyId = [[dict objectForKey:@"tripId"] intValue];	
	waypoint.latitude = [[dict objectForKey:@"latitude"] doubleValue];
	NSLog(@"waypoint.latitude = %f",waypoint.latitude);
	waypoint.longitude = [[dict objectForKey:@"longitude"] doubleValue];
	 NSLog(@"waypoint.longitude = %f",waypoint.longitude);
	waypoint.estimatedSpeed = [[dict objectForKey:@"estimated_speed"] floatValue];
    NSLog(@"waypoint.estimatedSpeed = %f",waypoint.estimatedSpeed);
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:kTimeStampDateFormat];
   // [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	waypoint.timeStamp = [dateFormatter dateFromString:[dict objectForKey:@"timestamp"]];
	[dateFormatter release];
	
	if (kWaypointUseBackgroundField) {
		id backgroundObj = [dict objectForKey:@"background"];
		
		if (backgroundObj == nil) {
			waypoint.background = NO;
		} else {
			waypoint.background = [backgroundObj boolValue];
		}
	}
	
	return waypoint;
}

+(SCWaypoint *) wayPointWithJSON: (NSString *) JSONRepresentation {
	SBJSON *jsonHelper = [[SBJSON alloc] init];
	id obj = [jsonHelper objectWithString:JSONRepresentation];
	[jsonHelper release];
	
	if([obj isKindOfClass:[NSDictionary class]]) {
		NSDictionary * dict = (NSDictionary *) obj;
		return [SCWaypoint waypointWithDictionary:dict];
	} else {
		return nil;
	}
}


- (void) dealloc
{
	[timeStamp release];
	[super dealloc];
}

+(double) distanceFromWayPoint:(SCWaypoint *) from toWayPoint:(SCWaypoint *) to {
	
	CLLocationCoordinate2D fromLocation, toLocation;
	
	fromLocation.latitude = from.latitude;
	fromLocation.longitude = from.longitude;
	
	toLocation.latitude = to.latitude;
	toLocation.longitude = to.longitude;
	//NSLog(@"from lat longg = %f,%f",fromLocation.latitude,fromLocation.longitude);
    //NSLog(@"to lat longg = %f,%f",toLocation.latitude,toLocation.longitude);
	double distance = [LocationUtils distanceFrom:fromLocation to:toLocation];
    NSLog(@"distance between two waypoints = %f",distance);
	return distance;
}

-(NSString *) JSONRepresentation {
	SBJSON *jsonHelper = [[SBJSON alloc] init];
	jsonHelper.humanReadable = NO;
	NSString *jsonStr = [jsonHelper stringWithObject:self];
	[jsonHelper release];
	
	return jsonStr;
}

-(NSDictionary *) asDictForServer {
	NSString *timeStampStr = [ServerDateFormatHelper formattedDateForJSON:self.timeStamp];
	
   /* NSMutableDictionary *dict =	[NSMutableDictionary dictionaryWithObjectsAndKeys:
								 [NSNumber numberWithDouble:self.latitude], @"latitude",
								 [NSNumber numberWithDouble:self.longitude], @"longitude",
								 [NSNumber numberWithFloat:self.estimatedSpeed], @"estimated_speed",
								 timeStampStr, @"timestamp",
								 nil];*/
    NSMutableDictionary *dict =	[NSMutableDictionary dictionaryWithObjectsAndKeys:
								 [NSString stringWithFormat:@"%f",self.latitude], @"latitude",
								 [NSString stringWithFormat:@"%f",self.longitude], @"longitude",
								 [NSNumber numberWithFloat:self.estimatedSpeed], @"estimated_speed",
								 timeStampStr, @"timestamp",
								 nil];
	
	if (kWaypointUseBackgroundField) {
		[dict setObject:[NSNumber numberWithBool:self.background] forKey:@"background"];
	}
	
	return dict;
}

// Overridden method from NSObject(SBProxyForJson) to support JSON formatting for custom class
- (id)proxyForJson {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:kTimeStampDateFormat];
	//[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	NSString *timeStampStr = nil;
	
	if(self.timeStamp) {
		timeStampStr = [dateFormatter stringFromDate:self.timeStamp];
	}
	
	[dateFormatter release];
	
   /* NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithInt:journeyId], @"tripId",
										[NSNumber numberWithDouble:self.latitude], @"latitude",
										[NSNumber numberWithDouble:self.longitude], @"longitude",
										[NSNumber numberWithFloat:self.estimatedSpeed], @"estimated_speed",
										timeStampStr, @"timestamp",
										nil];*/
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInt:journeyId], @"tripId",
                                 [NSString stringWithFormat:@"%f",self.latitude], @"latitude",
                                 [NSString stringWithFormat:@"%f",self.longitude], @"longitude",
                                 [NSNumber numberWithFloat:self.estimatedSpeed], @"estimated_speed",
                                 timeStampStr, @"timestamp",
                                 nil];
	if (kWaypointUseBackgroundField) {
		[dict setObject:[NSNumber numberWithBool:self.background] forKey:@"background"];
	}
	
	return dict;
}




-(CLLocation *) toCLLocation {
	
	CLLocationCoordinate2D locationCordinates;
	locationCordinates.latitude = self.latitude;
	locationCordinates.longitude = self.longitude;
		
	CLLocation * location = [[[CLLocation alloc] initWithCoordinate:locationCordinates 
														   altitude:0 
												 horizontalAccuracy:kCLLocationAccuracyBest 
												   verticalAccuracy:kCLLocationAccuracyBest 
														  timestamp:self.timeStamp] autorelease];
	return location;	
}

-(CLLocationCoordinate2D) toCoordinates {
	CLLocationCoordinate2D locationCordinates;
	locationCordinates.latitude = self.latitude;
	locationCordinates.longitude = self.longitude;
	
	return locationCordinates;
}

#pragma mark -
#pragma mark Map Annotations

-(CLLocationCoordinate2D)coordinate {
	CLLocation *loc = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
	return [loc coordinate];
}


@end
