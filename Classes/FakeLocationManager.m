//
//  FakeLocationManager.m
//  safecell
//
//  Created by shail on 12/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FakeLocationManager.h"
#import "WayPointsReader.h"
#import "SCWaypoint.h"
#import "AppDelegate.h"
#import "WayPointsFileHelper.h"
#import "FakeLocationManagerSettingsRepository.h"

const static float kFirstTimerInterval = 1.0f;
const static float kFastForwardSpeed = 33.0f;
const static float kRaceToEndTimerInterval = 0.0025f;

@implementation FakeLocationManager

@synthesize delegate;
@synthesize firstInQue;
@synthesize secondInQue;
@synthesize updateLocationTimer;

- (id) init {
	self = [super init];
	if (self != nil) {
		
		nextTimerInterval = kFirstTimerInterval;
		lastSentLocation = nil;
		
		raceToEnd = NO;
		reachedToEOF = NO;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive) name:@"applicationWillResignActive" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:@"applicationDidBecomeActive" object:nil];
		
		[self configureWayPointsReader];
		[self forwardJourneyToLastStopped];
	}
	return self;
}

-(void) configureWayPointsReader {	
	FakeLocationManagerSettingsRepository *settingsRepository = [[FakeLocationManagerSettingsRepository alloc] init];
	
	NSString *strResourcePath = [[NSBundle mainBundle] resourcePath];		
	NSString *wayPointsFilePath = [NSString stringWithFormat:@"%@/%@", strResourcePath, [settingsRepository lastUsedDataFile]];
	NSLog(@"wayPointsFilePath: %@", wayPointsFilePath);
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:wayPointsFilePath];
	wayPointsReader = [[WayPointsReader alloc] initWithFileHandle:fileHandle];
	[settingsRepository release];
	/*
	if ([WayPointsFileHelper wayPointsFileExists]) {
		WayPointsFileHelper *wayPointsFileHelper = [[WayPointsFileHelper alloc] initWithNewFile:NO];
		int count = [wayPointsFileHelper countWaypointsInFile];		
		[wayPointsFileHelper release];
		
		
		int noOfWayPointsRead = 0;
		
		while (noOfWayPointsRead < count) {
			[wayPointsReader readNextWayPoint];
			noOfWayPointsRead++;
		}		
	}
	 */
}

-(void) forwardJourneyToLastStopped {
	if ([WayPointsFileHelper wayPointsFileExists]) {
		WayPointsFileHelper *wayPointsFileHelper = [[WayPointsFileHelper alloc] initWithNewFile:NO];
		int count = [wayPointsFileHelper countWaypointsInFile];		
		[wayPointsFileHelper release];
				
		int noOfWayPointsRead = 0;
		
		while (noOfWayPointsRead < count) {	
			[wayPointsReader readNextWayPoint];
			noOfWayPointsRead++;
			NSLog(@"noOfWayPointsRead: %d", noOfWayPointsRead);
		}		
	}
}


-(void) readNextWayPoints {
	
	if(secondInQue != nil) {
		self.firstInQue = secondInQue;
	} else {
		self.firstInQue = [wayPointsReader readNextWayPoint];
	}
	
	self.secondInQue = [wayPointsReader readNextWayPoint];	
}

-(void) configureTimer {
	if(updateLocationTimer && [updateLocationTimer isValid]) {
		[updateLocationTimer invalidate];
	}
	
	self.updateLocationTimer = [NSTimer scheduledTimerWithTimeInterval: nextTimerInterval
											 target: self
										   selector: @selector(handleTimer:)
										   userInfo: nil
											repeats: YES];
}

- (void) dealloc {	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicationWillResignActive" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicationDidBecomeActive" object:nil];
	
	[firstInQue release];
	[secondInQue release];
	
	[wayPointsReader release];
	
	if([updateLocationTimer isValid]) {
		[updateLocationTimer invalidate];
	}
	
	[updateLocationTimer release];	
	
	[super dealloc];
}

-(void) startUpdatingLocation {
	
	if (reachedToEOF) {
		if( (delegate != nil) && [delegate respondsToSelector:@selector(reachedToEndofRecordedWayPointsFile)] ) {
			[delegate reachedToEndofRecordedWayPointsFile];
		}
		
		return;
	}
	
	[self configureTimer];
}

-(void) stopUpdatingLocation {
	if([self.updateLocationTimer isValid]) {
		[self.updateLocationTimer invalidate];
		self.updateLocationTimer = nil;
	}
}

-(BOOL) raceToEnd {
	return raceToEnd;
}

-(void) setRaceToEnd: (BOOL) value {
	raceToEnd = value;
	
	[updateLocationTimer invalidate];
	self.updateLocationTimer = [NSTimer scheduledTimerWithTimeInterval: kRaceToEndTimerInterval
																target: self
															  selector: @selector(handleTimer:)
															  userInfo: nil
															   repeats: YES];
}

-(void) handleTimer: (NSTimer *) timer {
	[self readNextWayPoints];
	
	CLLocation *newLocation = [self.firstInQue toCLLocation];
	
	// NSLog(@"1");
	
	if( (delegate != nil) && [delegate respondsToSelector:@selector(locationManager:didUpdateToLocation:fromLocation:)] ) {
		[delegate locationManager:nil didUpdateToLocation:newLocation fromLocation:lastSentLocation];
	}
	
	lastSentLocation = newLocation; 
    //float speed = lastSentLocation.speed;
   // NSLog(@"speed in fake location manger = %f",speed);
	
	if(secondInQue == nil) {
		
		[updateLocationTimer invalidate];
		
		// NSLog(@"2");
		if( (delegate != nil) && [delegate respondsToSelector:@selector(reachedToEndofRecordedWayPointsFile)] ) {
			[delegate reachedToEndofRecordedWayPointsFile];
		}
		reachedToEOF = YES;
		NSLog(@"Done");
	} else {
		
		nextTimerInterval = [secondInQue.timeStamp timeIntervalSinceDate:firstInQue.timeStamp];
		
		nextTimerInterval /= kFastForwardSpeed;
		
		if(nextTimerInterval <= 0) { // indicates we received 2 GPS updates within a second while recording
			nextTimerInterval = 0.9;
		}
		
		if(raceToEnd) {
			nextTimerInterval = kRaceToEndTimerInterval;
		}
		
		[updateLocationTimer invalidate];
		self.updateLocationTimer = [NSTimer scheduledTimerWithTimeInterval: nextTimerInterval
												 target: self
											   selector: @selector(handleTimer:)
											   userInfo: nil
												repeats: YES];
		
		NSLog(@"Set Next Timer After: %f", nextTimerInterval);
	}
}

-(void) applicationWillResignActive {
	[self stopUpdatingLocation];
}

-(void) applicationDidBecomeActive {
	[self startUpdatingLocation];
}


@end
