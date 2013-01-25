//
//  AccountRepository.h
//  safecell
//
//  Created by Ben Scheirman on 5/13/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAccount.h"
#import "AbstractRepository.h"

@interface AccountRepository : AbstractRepository {

}

-(SCAccount *)currentAccount;
-(void)saveAccount:(SCAccount *)account;

-(BOOL) accountExists: (SCAccount *) account;
-(SCAccount *) accountFromResultSet: (FMResultSet *) resultSet;
-(void) deleteExistingAccount;

@end
