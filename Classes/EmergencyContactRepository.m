//
//  EmergencyContactRepository.m
//  safecell
//
//  Created by shail m on 6/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EmergencyContactRepository.h"
#import "FMDatabaseAdditions.h"

@implementation EmergencyContactRepository

-(void) saveContact: (SCEmergencyContact *) contact {
	NSString *query =	@"INSERT INTO emergency_contacts ("
							@"name, number "
						@") VALUES ("
							@"?, ? "
						@")";
	
	[db executeUpdate:query, contact.name, contact.number];
	
	contact.emergencyContactId = [self lastInsertRowId];
}

-(void) updateContact: (SCEmergencyContact *) contact {
	NSString *query =	@"UPDATE emergency_contacts SET "
							@"name = ?, number = ? "
						@"WHERE id = ?";
	
	[db executeUpdate:query, contact.name, contact.number, [NSNumber numberWithInt:contact.emergencyContactId]];
}

-(void) saveOrUpdateContact: (SCEmergencyContact *) contact {
	if ([self contactExists:contact]) {
		[self updateContact:contact];
	} else {
		[self saveContact: contact];
	}
}

-(BOOL) contactExists: (SCEmergencyContact *) contact {
	NSString *query = @"SELECT COUNT(*) FROM emergency_contacts WHERE id = ?";
	int count = [db intForQuery:query, [NSNumber numberWithInt:contact.emergencyContactId]];
	
	if (count > 0) {
		return YES;
	} else {
		return NO;
	}
}

-(SCEmergencyContact *) contactWithResultSet: (FMResultSet *) resultset {
	SCEmergencyContact *contact = [[[SCEmergencyContact alloc] init] autorelease];
	
	contact.emergencyContactId = [resultset intForColumn:@"id"];
	contact.name = [resultset stringForColumn:@"name"];
	contact.number = [resultset stringForColumn:@"number"];
	NSLog(@"contact.number = %@",contact.number);
	return contact;
}

-(NSMutableArray *) contacts {
	NSString *query = @"SELECT id, name, number FROM emergency_contacts ORDER BY id";
	
	NSMutableArray *contacts = [[[NSMutableArray alloc] init] autorelease];
	
	FMResultSet *resulSet = [db executeQuery:query];
	
	while ([resulSet next]) {
		SCEmergencyContact *contact = [self contactWithResultSet:resulSet];
		[contacts addObject:contact];
	}
	
	[resulSet close];
	NSLog(@"contacts = %@",contacts);
    
	return contacts;
}

-(void) deleteAllContacts {
	NSString *query = @"DELETE FROM emergency_contacts WHERE 1";
	
	[db executeUpdate:query];
}



@end
