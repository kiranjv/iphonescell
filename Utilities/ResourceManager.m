//
//  ResourceManager.m
//  safecell
//
//  Created by shail m on 6/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ResourceManager.h"
#import "FileUtils.h"

static NSString* DEFAULT_DATA_FILENAME = @"resources";

@implementation ResourceManager

@synthesize dataFileName;


- (id) init {
	self = [super init];
	if (self != nil) {
		self.dataFileName = DEFAULT_DATA_FILENAME;
	}
	return self;
}

-(void) copyResourcesToDocumentsDirectory {
	NSString *path = [[NSBundle mainBundle] pathForResource:self.dataFileName ofType:@"plist"];
	NSDictionary *dataDict = [[NSDictionary alloc] initWithContentsOfFile:path];
	
	NSArray *sourceFiles = [dataDict allKeys];
	
	for (NSString *sourceFile in sourceFiles) {
		NSString *destination = [dataDict objectForKey:sourceFile];
		[FileUtils copyFromBundelFile:sourceFile toDocumentsDirectory:destination];
	}
	
	[dataDict release];
}

- (void) dealloc {	
	[dataFileName release];	
	[super dealloc];
}

@end
