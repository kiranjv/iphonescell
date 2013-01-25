//
//  ProfileRepository.h
//  safecell
//
//  Created by Ben Scheirman on 4/20/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCProfile.h"
#import "AccountRepository.h"


@interface ProfileRepository : AbstractRepository {

}

-(BOOL) profileExists;

-(BOOL) profileExists: (SCProfile *) profile;

-(SCProfile *) currentProfile;

-(void) saveProfile: (SCProfile *) profile;

-(SCProfile *) profileFromResultSet: (FMResultSet *) resultSet;

-(void) updateProfile: (SCProfile *) profile;

-(void) deleteProfile;

@end
