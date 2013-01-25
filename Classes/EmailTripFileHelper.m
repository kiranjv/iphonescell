//
//  EmailTripFileHelper.m
//  safecell
//
//  Created by Mobisoft Infotech on 6/23/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "EmailTripFileHelper.h"
#import "WayPointsFileHelper.h"
#import "InterruptionsFileHelper.h"
#import "ZipArchive.h"


@implementation EmailTripFileHelper

+(NSString *) emailTripFilePath {
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString * emailTripFilePath = [documentsDirectory stringByAppendingPathComponent:kTripEmailFileName];
	return emailTripFilePath;
}

+(BOOL) emailTripFileExists {
	NSFileManager *fileManager = [NSFileManager defaultManager];	
	NSString * emailTripFilePath = [EmailTripFileHelper emailTripFilePath];	
	
	if([fileManager fileExistsAtPath:emailTripFilePath]) {
		return YES;
	} else {
		return NO;
	}
}

+(NSString *) emailTripZipFilePath {
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString * emailTripZipFilePath = [documentsDirectory stringByAppendingPathComponent:kTripEmailZipFileName];
	return emailTripZipFilePath;
}

+(BOOL) emailTripZipFileExists {
	NSFileManager *fileManager = [NSFileManager defaultManager];	
	NSString * emailTripZipFilePath = [EmailTripFileHelper emailTripZipFilePath];	
	
	if([fileManager fileExistsAtPath:emailTripZipFilePath]) {
		return YES;
	} else {
		return NO;
	}
}

-(void) createEmailTripFile {
	NSFileManager *fileManager = [NSFileManager defaultManager];	
	NSString * emailFilePath =  [EmailTripFileHelper emailTripFilePath];
	if([EmailTripFileHelper emailTripFileExists]) {
		BOOL deleted = [fileManager removeItemAtPath:emailFilePath error:NULL];
		
		if (deleted) {
			NSLog(@"Email Trip File Deleted");
		} else {
			NSLog(@"Email Trip File Deletion Failed");
		}
	}
	
	[fileManager createFileAtPath:emailFilePath contents:[@"" dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}

-(void) writeDataFromFileHandle: (NSFileHandle *) source toFileHandle: (NSFileHandle *) destination {
	NSData *data = [source readDataOfLength:1024];
	
	while ([data length] > 0) {
		[destination writeData:data];
		data = [source readDataOfLength:1024];
	}
}

-(void) writeTripDataToEmailTripFile {
	NSString *emailTripFilePath = [EmailTripFileHelper emailTripFilePath];
	NSFileHandle *emailTripFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:emailTripFilePath];
	
	NSString *waypointFilePath = [WayPointsFileHelper wayPointsFilePath];
	NSFileHandle *waypointFileHandle = [NSFileHandle fileHandleForReadingAtPath:waypointFilePath];
	
	NSString *waypointsSectionTitle =	@"Waypoints:\n"
										@"----------\n\n";
	
	[emailTripFileHandle writeData:[waypointsSectionTitle dataUsingEncoding:NSUTF8StringEncoding]];
	
	[self writeDataFromFileHandle:waypointFileHandle toFileHandle:emailTripFileHandle];
	
	[waypointFileHandle closeFile];
	
	NSString *interruptionsFilePath = [InterruptionsFileHelper interruptionsFilePath];
	NSFileHandle *interruptionsFileHandle = [NSFileHandle fileHandleForReadingAtPath:interruptionsFilePath];
	
	NSString *interruptionsSectionTitle =	@"\n\n\nInterruptions:\n"
											@"----------\n\n";
	
	[emailTripFileHandle writeData:[interruptionsSectionTitle dataUsingEncoding:NSUTF8StringEncoding]];
	
	[self writeDataFromFileHandle:interruptionsFileHandle toFileHandle:emailTripFileHandle];
	
	[interruptionsFileHandle closeFile];
	
	NSString *endNote =		@"\n\n\nEnd of File\n";
	[emailTripFileHandle writeData:[endNote dataUsingEncoding:NSUTF8StringEncoding]];
	
	[emailTripFileHandle closeFile];
}

-(void) deleteEmailTripFile {
	NSFileManager *fileManager = [NSFileManager defaultManager];	
	NSString * emailFilePath =  [EmailTripFileHelper emailTripFilePath];
	if([EmailTripFileHelper emailTripFileExists]) {
		BOOL deleted = [fileManager removeItemAtPath:emailFilePath error:NULL];
		
		if (deleted) {
			NSLog(@"Email Trip File Deleted");
		} else {
			NSLog(@"Email Trip File Deletion Failed");
		}
	}
}

-(void) deleteEmailTripZipFile {
	if([EmailTripFileHelper emailTripZipFileExists]) {
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *emailTripZipFilePath = [EmailTripFileHelper emailTripZipFilePath];
		BOOL deleted = [fileManager removeItemAtPath:emailTripZipFilePath error:NULL];
		
		if (deleted) {
			NSLog(@"Email Trip Zip File Deleted");
		} else {
			NSLog(@"Email Trip Zip File Deletion Failed");
		}
	}
}

-(BOOL) archiveEmailTripFile {	
	
	[self deleteEmailTripZipFile];
	
	NSString *emailTripZipFilePath = [EmailTripFileHelper emailTripZipFilePath];
	
	ZipArchive* za = [[ZipArchive alloc] init];
	[za CreateZipFile2:emailTripZipFilePath];
	NSString *emailFilePath =  [EmailTripFileHelper emailTripFilePath];
	
	[za addFileToZip:emailFilePath newname:kTripEmailFileName];
	if( ![za CloseZipFile2] )
	{
		return NO;
	}
	[za release];
	
	return YES;
}

-(NSData *) emailTripZipFileData {
	NSString *emailTripZipFilePath = [EmailTripFileHelper emailTripZipFilePath];
	
	if([EmailTripFileHelper emailTripZipFileExists]) {
		NSFileHandle *zipFileHandle = [NSFileHandle fileHandleForReadingAtPath:	emailTripZipFilePath];
		NSData * zipFileData = [zipFileHandle readDataToEndOfFile];
		return zipFileData;
	} else {
		return nil;
	}
}

-(void) prepareEmailTripZipFile {
	[self createEmailTripFile];
	[self writeTripDataToEmailTripFile];
	[self archiveEmailTripFile];
}

-(void) deleteEmailTripRelatedFiles {
	[self deleteEmailTripFile];
	[self deleteEmailTripZipFile];
}

@end
