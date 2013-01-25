//
//  FakeLocationManagerSettingsRepository.h
//  safecell
//
//  Created by shail m on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractRepository.h"

@interface FakeLocationManagerSettingsRepository : AbstractRepository {

}

-(void) setLastUsedDataFile:(NSString *) fileName;
-(NSString *) lastUsedDataFile;

@end
