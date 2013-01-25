//
//  EmailTripFileHelper.h
//  safecell
//
//  Created by Mobisoft Infotech on 6/23/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTripEmailFileName @"TripEmailFile.txt"
#define kTripEmailZipFileName @"TripEmailFile.zip"

@interface EmailTripFileHelper : NSObject {

}

+(NSString *) emailTripFilePath;
+(BOOL) emailTripFileExists;

-(void) prepareEmailTripZipFile;
-(void) deleteEmailTripRelatedFiles;

-(NSData *) emailTripZipFileData;

@end
