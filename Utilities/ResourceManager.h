//
//  ResourceManager.h
//  safecell
//
//  Created by shail m on 6/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ResourceManager : NSObject {
	NSString *dataFileName;
}

@property(nonatomic, retain) NSString *dataFileName;

-(void) copyResourcesToDocumentsDirectory;

@end
