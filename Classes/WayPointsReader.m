//
//  WayPointsReader.m
//  safecell
//
//  Created by shail on 12/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WayPointsReader.h"
#import "SCWayPoint.h"


@implementation WayPointsReader

- (id) initWithFileHandle: (NSFileHandle *) wayPointFileHandle {
	self = [super init];
	if (self != nil) {
		fileHandle = [wayPointFileHandle retain];
	}
	return self;
}

- (void) dealloc {
	[fileHandle release];
	[super dealloc];
}

//TODO: This method needs more testing with smaller buffer
-(SCWaypoint *) readNextWayPoint {
	BOOL continueReading = YES;
	
	NSMutableString *buffer = [[NSMutableString alloc] initWithCapacity:1024];
	
	BOOL foundWayPointStart = NO;
	BOOL endOfFileReached = NO;
	
	unsigned long long offsetToResetAt =  [fileHandle offsetInFile];
	
	while(continueReading) {
		NSData *data = [fileHandle readDataOfLength:1024];
		
		if([data length] < 1024) {
			continueReading = NO;
			endOfFileReached = YES;
		}
		
		NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		
		if(!foundWayPointStart) {
			NSRange range = [str rangeOfString:@"{"]; 
			if(range.location != NSNotFound) {
				foundWayPointStart = YES;
				offsetToResetAt += range.location;
				
				NSString *substring = [str substringFrom:range.location to:[str length]];
				
				NSRange subrange = [substring rangeOfString:@"}"]; 
				if(subrange.location != NSNotFound) {
					offsetToResetAt += subrange.location;
					substring = [substring substringFrom:0 to:subrange.location  + 1];
					[buffer appendString:substring];			
					[str release];
					break;
				} 
				
				[buffer appendString:substring];
			} else { 
				offsetToResetAt += [data length];
				[str release];
				continue;
			}
		} else {
			NSRange range = [str rangeOfString:@"}"]; 
			if(range.location != NSNotFound) {
				offsetToResetAt += range.location;
				foundWayPointStart = YES;				
				NSString *substring = [str substringFrom:0 to:range.location  + 1];
				[buffer appendString:substring];
				continueReading = NO;
			} else { 
				[buffer appendString:str];
			}
		}
		
		[str release];
	}
	
	[fileHandle seekToFileOffset:offsetToResetAt];
	SCWaypoint * wayPoint = [SCWaypoint wayPointWithJSON:buffer];
	[buffer release];
	return wayPoint;
}

@end
