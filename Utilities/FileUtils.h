//
//  FileUtils.h
//  safecell
//
//  Created by shail m on 5/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileUtils : NSObject {

}

+(NSString *) textFromBundleFile:(NSString *) filename;
+(void) copyFromBundelFile:(NSString *) fileName toDocumentsDirectory: (NSString *) destination;
+(NSString *) dirFromPath: (NSString *) path;

@end
