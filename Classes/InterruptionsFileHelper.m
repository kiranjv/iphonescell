//
//  InterruptionsFileHelper.m
//  safecell
//
//  Created by shail m on 5/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InterruptionsFileHelper.h"
#import "SCInterruption.h"

@implementation InterruptionsFileHelper

- (id) initWithNewFile: (BOOL) createNew
{
	self = [super init];
	if (self != nil) {
		
		if(createNew) {
			[self createInterruptionsFile];
		}
		
		NSString * interruptionsFilePath = [InterruptionsFileHelper interruptionsFilePath];	
		fileHandle = [[NSFileHandle fileHandleForUpdatingAtPath:interruptionsFilePath] retain];
		
		//wayPointsReader = [[WayPointsReader alloc] initWithFileHandle:fileHandle];
	}
	return self;
}

+(NSString *) interruptionsFilePath {
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString * interruptionFilePath = [documentsDirectory stringByAppendingPathComponent:kInterruptionsFileName];
	return interruptionFilePath;
}

+(BOOL) interruptionsFileExists {
	NSFileManager *fileManager = [NSFileManager defaultManager];	
	NSString * interruptionsFilePath = [InterruptionsFileHelper interruptionsFilePath];	
	
	if([fileManager fileExistsAtPath:interruptionsFilePath]) {
		return YES;
	} else {
		return NO;
	}
}

-(void) createInterruptionsFile {	
	NSFileManager *fileManager = [NSFileManager defaultManager];	
	NSString * interruptionsFilePath = [InterruptionsFileHelper interruptionsFilePath];	
	if([InterruptionsFileHelper interruptionsFileExists]) {
		BOOL deleted = [fileManager removeItemAtPath:interruptionsFilePath error:NULL];
		assert(deleted == YES);
	}
	
	[fileManager createFileAtPath:interruptionsFilePath contents:[@"" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];	
}

-(void) writeInterruption: (SCInterruption *) interruption withOptionalProperties: (BOOL) includeOptional{
	[fileHandle seekToEndOfFile];
	
	unsigned long long seekPoint = [fileHandle offsetInFile];
	
	if(seekPoint > 0) {
		[fileHandle writeData:[@"," dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	NSString *json = [interruption JSONRepresentationWithOptionalProperties:includeOptional];
    NSLog(@"interruption JSON = %@",json);
   	[fileHandle writeData:[json dataUsingEncoding:NSUTF8StringEncoding]];
}


/** 
 Note that this method depends upon the assumption that
 one json representation of an intrruption will not be longer then 
 512 characters.
 */
-(unsigned long long) offsetForLastInterruption {
	unsigned long long offsetToResetAt =  [fileHandle offsetInFile];
	
	[fileHandle seekToEndOfFile];
	unsigned long long currentOffset = [fileHandle offsetInFile];
	if(currentOffset == 0) {
		return -1;
	}
	
	int offsetShift = currentOffset < 512 ? currentOffset : 512;
	
	unsigned long long desiredOffsetPos = currentOffset - offsetShift;
	
	[fileHandle seekToFileOffset:desiredOffsetPos];
	
	NSData *data = [fileHandle readDataOfLength:offsetShift];
	
	NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
	int endofSecondLastInterruption = [str lastIndexOfString:@"},"];
	
	if(endofSecondLastInterruption == NSNotFound) {
		endofSecondLastInterruption = [str lastIndexOfString:@"{"];		
		
		//Assumption that intrruption will not be longer then 512 characters falied.
		assert(endofSecondLastInterruption != NSNotFound); 
	} else {
		endofSecondLastInterruption += 1; //We want to delete the comma too. It will will written again.
	}	
	
	[str release];
	[fileHandle seekToFileOffset:offsetToResetAt];
	return (desiredOffsetPos + endofSecondLastInterruption);
}

-(void) updateLastInterruption: (SCInterruption *) interruption withOptionalProperties: (BOOL) includeOptional {
	unsigned long long offsetForLastInterruption = [self offsetForLastInterruption];
	
	//updateLastInterruption should never be called in a situation
	//where there is no interruptions recorded in the file.
	assert(offsetForLastInterruption != -1);
	
	[fileHandle truncateFileAtOffset:offsetForLastInterruption];
	[self writeInterruption:interruption withOptionalProperties:includeOptional];
}

/** 
 Note that this method depends upon the assumption that
 one json representation of an interruption will not be longer then 
 512 characters.
 */
-(SCInterruption *) readNextInterruption {
	unsigned long long currentOffset = [fileHandle offsetInFile];
	
	unsigned long long offsetToReadFrom = 0;
	
	if(currentOffset != 0) {
		NSData *data = [fileHandle readDataOfLength:512];		
		NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		
		offsetToReadFrom = [str indexOfString:@"{"];
		[str release];
		
		if(offsetToReadFrom == NSNotFound) {
			NSLog(@"ReadNextInterruption : Returning nil");
			
			return nil;
		}
		
		offsetToReadFrom += currentOffset;
	}
	
	[fileHandle seekToFileOffset:offsetToReadFrom];
	
	NSData *data = [fileHandle readDataOfLength:512];
	NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	int offsetToReadTo = [str indexOfString:@"}"];
	
	//Assumption that intrruption will not be longer then 512 characters failed.
	assert(offsetToReadFrom != NSNotFound);
	
	NSLog(@"offsetToReadTo: %d", offsetToReadTo);
	
	NSString *json = nil;
	
	if ([str length] >= (offsetToReadTo + 1)) {
		json = [str substringFrom:0 to:(offsetToReadTo + 1)];
	} 
	
	[str release];
	
	if (json == nil) {
		return nil;
	}
	
	 NSLog(@" intrruption json: %@", json);
	
	SCInterruption *interruption = [SCInterruption interruptionWithJSON:json includeOptional:NO];
	unsigned long long offsetToSet = offsetToReadFrom + [json length];
	[fileHandle seekToFileOffset:offsetToSet];
	
	return interruption;
}

-(SCInterruption *) readLastInterruption {
	unsigned long long offsetForLastInterruption = [self offsetForLastInterruption];
	
	if(offsetForLastInterruption == -1) {
		return nil;
	}
	
	[fileHandle seekToFileOffset:offsetForLastInterruption];
	
	SCInterruption * interruption = [self readNextInterruption];
	
	return interruption;
}

-(void) deleteInterruptionsFile {
	if ([InterruptionsFileHelper interruptionsFileExists]) {
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString * interruptionsFilePath = [InterruptionsFileHelper interruptionsFilePath];
		[fileManager removeItemAtPath:interruptionsFilePath error:NULL];
	}
}

-(void) closeInterrutionsFile {
	[fileHandle closeFile];
}

- (void) dealloc {
	[self closeInterrutionsFile];
	[fileHandle release];
	[super dealloc];
}

@end
