//
//  InterruptionsFileHelper.h
//  safecell
//
//  Created by shail m on 5/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCInterruption.h"

#define kInterruptionsFileName @"interruptions.json"

@interface InterruptionsFileHelper : NSObject {
	NSFileHandle *fileHandle;
}


+(NSString *) interruptionsFilePath;
+(BOOL) interruptionsFileExists;

-(id) initWithNewFile: (BOOL) createNew;
-(void) createInterruptionsFile;
-(void) closeInterrutionsFile;
-(void) writeInterruption: (SCInterruption *) interruption withOptionalProperties: (BOOL) includeOptional;
-(void) updateLastInterruption: (SCInterruption *) interruption withOptionalProperties: (BOOL) includeOptional;
-(void) deleteInterruptionsFile;
-(SCInterruption *) readNextInterruption;
-(SCInterruption *) readLastInterruption;

@end
