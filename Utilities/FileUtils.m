//
//  FileUtils.m
//  safecell
//
//  Created by shail m on 5/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FileUtils.h"


@implementation FileUtils

+(NSString *) textFromBundleFile:(NSString *) filename {
	NSString *strResourcePath = [[NSBundle mainBundle] resourcePath];		
	NSString *filepath = [NSString stringWithFormat:@"%@/%@", strResourcePath, filename];
	return [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:nil];
}

+(NSString *) dirFromPath: (NSString *) path {
	int lastIndexOfSlash = [path lastIndexOfString:@"/"];
	
	if (lastIndexOfSlash == NSNotFound) {
		return path;
	} 
	
	return [path substringFrom:0 to:lastIndexOfSlash];
}

+(void) copyFromBundelFile:(NSString *) fileName toDocumentsDirectory: (NSString *) destination {
	NSString *bundlePath = [[NSBundle mainBundle] resourcePath];		
	NSString *sourcePath = [NSString stringWithFormat:@"%@/%@", bundlePath, fileName];
	
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *destinationPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, destination];
		
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString* destinationDir = [FileUtils dirFromPath:destinationPath];
		
	[fileManager createDirectoryAtPath:destinationDir withIntermediateDirectories:YES attributes:nil error:NULL];
		
	if(![fileManager fileExistsAtPath:destinationPath]) {
		NSError *error = nil;
		
		[fileManager copyItemAtPath:sourcePath toPath:destinationPath error:&error];
		
		if (error) {
			NSLog(@"'%@' copy failed. Error: %@", fileName, [error localizedDescription]);
		} else {
			NSLog(@"'%@' copied to '%@'", fileName, destination);
		}

	} else {
		NSLog(@"'%@' already exists, will not be copied.", destination);
	}
}

@end
