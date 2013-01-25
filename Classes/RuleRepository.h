//
//  RuleRepository.h
//  safecell
//
//  Created by shail m on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractRepository.h"
#import "SCRule.h"


@interface RuleRepository : AbstractRepository {

}

-(int) totalNoOfRules;
-(BOOL) ruleExists:(SCRule *) rule;
-(void) saveRule: (SCRule *) rule;
-(void) updateRule: (SCRule *) rule;
-(void) saveOrUpdateRule: (SCRule *) rule;
-(void) saveOrUpdateRule: (SCRule *) rule;

-(void) setAllRulesToInactive;
-(NSMutableArray *) activeRules;
-(NSMutableArray *) inactiveRules;

-(void) cleanUpRules;
-(void) deleteAllRules;

@end
