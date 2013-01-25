//
//  ProfilePicHelper.h
//  safecell
//
//  Created by shail m on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int kProfilePicHeight = 84;
static const int kProfilePicWidth = 84;

@interface ProfilePicHelper : NSObject {

}

-(NSString *) profilePicPath;
-(UIImage *) profilePic;
-(void) writeProfilePic: (UIImage *) image;

@end
