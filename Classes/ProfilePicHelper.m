//
//  ProfilePicHelper.m
//  safecell
//
//  Created by shail m on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProfilePicHelper.h"

static NSString *PROFILE_PIC_NAME = @"images/profile_pic.png";

@implementation ProfilePicHelper

-(NSString *) profilePicPath {
	NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *destinationPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, PROFILE_PIC_NAME];
	return destinationPath;
}

-(UIImage *) profilePic {
	NSString * profilePicPath = [self profilePicPath];
	UIImage *profileImage = [UIImage imageWithContentsOfFile:profilePicPath];
	return profileImage;
}

-(void) writeProfilePic: (UIImage *) image {
	NSString * profilePicPath = [self profilePicPath];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:profilePicPath]) {
		NSError *deleteError = nil;
		[fileManager removeItemAtPath:profilePicPath error:&deleteError];
		
		if (deleteError) {
			NSLog(@"Delete profile pic failed. Reason: %@", [deleteError localizedDescription]);
		}
	}
	
	NSData* imageData = UIImagePNGRepresentation(image);
	BOOL written = [imageData writeToFile:profilePicPath atomically:YES];
	
	if (!written) {
		NSLog(@"Profile Pic writing failed.");
	}
}

@end
