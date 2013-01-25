//
//  ResolvedLocationRepository.h
//  safecell
//
//  Created by shail m on 6/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCResolvedLocation.h"
#import "AbstractRepository.h"

@interface ResolvedLocationRepository : AbstractRepository {

}

-(void) saveResolvedLocation: (SCResolvedLocation *)location;
-(SCResolvedLocation *) reslovedLocationWithLatitude: (float) latitude longitude: (float) longitude;

@end
