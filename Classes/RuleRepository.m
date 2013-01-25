//
//  RuleRepository.m
//  safecell
//
//  Created by shail m on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RuleRepository.h"
#import "FMDatabaseAdditions.h"

// 30 days * 24 hours * 60 min. * 60 sec.
static const NSTimeInterval kCleanupInterval = 30 * 24 * 60 * 60; 

@implementation RuleRepository

-(int) totalNoOfRules {
	NSString *query = @"SELECT COUNT(rule_id) FROM rules";
	int ruleCount = [db intForQuery:query];
	return ruleCount;
}

-(BOOL) ruleExists:(SCRule *) rule {
	NSString *query = @"SELECT COUNT(rule_id) FROM rules WHERE rule_id = ?";
	int ruleCount = [db intForQuery:query, [NSNumber numberWithInt:rule.ruleId]];
	
	if(ruleCount > 0) {
		return YES;
	} else {
		return NO;
	}
}

-(void) saveRule: (SCRule *) rule {
	NSString *query =	@"INSERT INTO rules ("
							@"rule_id, zone_id, bus_driver, novice, "
							@"primary_rule, crash_collection, preemption, all_drivers, "
							@"rule_type, label, created_at, updated_at, " 
							@"active, when_enforced, zone_name, detail, licenses "
						@") VALUES ("
							@"?, ?, ?, ?, "
							@"?, ?, ?, ?, "
							@"?, ?, ?, ?, "
							@"?, ?, ?, ?, ? "
						@")";
	
	NSLog(@"SDate: %@", rule.createdAt);
	NSLog(@"SDate: %@", rule.updatedAt);
	
	[db executeUpdate:query, 
						[NSNumber numberWithInt:rule.ruleId],
						[NSNumber numberWithInt:rule.zoneId],
						[NSNumber numberWithBool:rule.busDirver],
						[NSNumber numberWithBool:rule.novice],
						[NSNumber numberWithBool:rule.primary],
						[NSNumber numberWithBool:rule.crashCollection],
						[NSNumber numberWithBool:rule.preemption],
						[NSNumber numberWithBool:rule.allDrivers],
						rule.ruleType,
						rule.label,
						rule.createdAt,
						[NSDate date],		// Updated at ignores server update date rule since 
											// we are using this for checking local updates to the rule.
						[NSNumber numberWithBool:rule.isActive],
						rule.whenEnforced,
						rule.zoneName,
						rule.detail,
						rule.licenses
	 ];
}

-(void) updateRule: (SCRule *) rule {	
	NSString *query =	@"UPDATE rules SET "
							@"zone_id = ?, bus_driver = ?, novice = ?, "
							@"primary_rule = ?, crash_collection = ?,  preemption = ?, all_drivers = ?, "
							@"rule_type = ?, label = ?, created_at = ?, updated_at = ?, " 
							@"active = ?, when_enforced = ?, zone_name = ?, detail = ?, licenses = ? "
						@"WHERE "
							@"rule_id = ?";
	
	[db executeUpdate:query, 
					 [NSNumber numberWithInt:rule.zoneId],
					 [NSNumber numberWithBool:rule.busDirver],
					 [NSNumber numberWithBool:rule.novice],
					 [NSNumber numberWithBool:rule.primary],
					 [NSNumber numberWithBool:rule.crashCollection],
					 [NSNumber numberWithBool:rule.preemption],
					 [NSNumber numberWithBool:rule.allDrivers],
					 rule.ruleType,
					 rule.label,
					 rule.createdAt,
					 [NSDate date],			// Updated at ignores server update date rule since 
											// we are using this for checking local updates to the rule.
					 [NSNumber numberWithBool:rule.isActive],
					 rule.whenEnforced,
					 rule.zoneName,
					 rule.detail,
					 rule.licenses,
					 [NSNumber numberWithInt:rule.ruleId]];
}

-(void) saveOrUpdateRule: (SCRule *) rule {
	if ([self ruleExists:rule]) {
		[self updateRule:rule];
	} else {
		[self saveRule:rule];
	}

}

-(void) setAllRulesToInactive {
	NSString *query = @"UPDATE rules SET active = 0 WHERE active = 1";
	[db executeUpdate:query];
}

-(SCRule *) ruleWithResultset: (FMResultSet *) resultSet {
	SCRule *rule = [[[SCRule alloc] init] autorelease];
	
	rule.ruleId = [resultSet intForColumn:@"rule_id"];
	rule.zoneId = [resultSet intForColumn:@"zone_id"];
	
	rule.busDirver = [resultSet boolForColumn:@"bus_driver"];
	rule.novice = [resultSet boolForColumn:@"novice"];
	
	rule.primary = [resultSet boolForColumn:@"primary_rule"];
	rule.crashCollection = [resultSet boolForColumn:@"crash_collection"];
	rule.preemption = [resultSet boolForColumn:@"preemption"];
	rule.allDrivers = [resultSet boolForColumn:@"all_drivers"];
	
	rule.ruleType = [resultSet stringForColumn:@"rule_type"];
	rule.label = [resultSet stringForColumn:@"label"];
		
	rule.createdAt = [resultSet dateForColumn:@"created_at"];
	rule.updatedAt = [resultSet dateForColumn:@"updated_at"];
	
	rule.active = [resultSet boolForColumn:@"active"];
	rule.whenEnforced = [resultSet stringForColumn:@"when_enforced"];
	rule.zoneName = [resultSet stringForColumn:@"zone_name"];
	rule.detail = [resultSet stringForColumn:@"detail"];
	rule.licenses = [resultSet stringForColumn:@"licenses"];
	
	return rule;
}


-(NSMutableArray *) activeRules {
	NSString *query =	@"SELECT "
								@"rule_id, zone_id, bus_driver, novice, "
								@"primary_rule, crash_collection, preemption, all_drivers, "
								@"rule_type, label, created_at, updated_at, " 
								@"active, when_enforced, zone_name, detail, licenses "
						@"FROM rules WHERE active = 1";
	
	NSMutableArray *rulesArr = [[[NSMutableArray alloc] init] autorelease];
	
	FMResultSet *resultSet = [db executeQuery:query];
	
	while ([resultSet next]) {
		SCRule *rule = [self ruleWithResultset:resultSet];
		[rulesArr addObject:rule];
	}
	
	[resultSet close];
	
	
	return rulesArr;
}

-(NSMutableArray *) inactiveRules {
	NSString *query =	@"SELECT "
							@"rule_id, zone_id, bus_driver, novice, "
							@"primary_rule, crash_collection, preemption, all_drivers, "
							@"rule_type, label, created_at, updated_at, " 
							@"active, when_enforced, zone_name, detail, licenses "
						@"FROM rules WHERE active = 0 ORDER BY zone_id";
	
	NSMutableArray *rulesArr = [[[NSMutableArray alloc] init] autorelease];
	
	FMResultSet *resultSet = [db executeQuery:query];
	
	while ([resultSet next]) {
		SCRule *rule = [self ruleWithResultset:resultSet];
		[rulesArr addObject:rule];
	}
	
	[resultSet close];
	
	
	return rulesArr;
	
}

-(void) cleanUpRules {
	NSTimeInterval difference = -kCleanupInterval;	
	NSDate *cleanUpDate = [NSDate dateWithTimeIntervalSinceNow:difference];
	
	NSString* query = @"DELETE FROM rules WHERE updated_at < ?";
	[db executeUpdate:query, cleanUpDate];
}

-(void) deleteAllRules {
	NSString *query = @"DELETE FROM rules WHERE 1";
	[db executeUpdate:query];
}

@end
