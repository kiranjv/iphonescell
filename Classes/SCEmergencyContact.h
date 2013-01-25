//
//  SCEmergencyNumber.h
//  safecell
//
//  Created by shail m on 6/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SCEmergencyContact : NSObject {
	int emergencyContactId;
	NSString *name;
	NSString *number;
}

@property (nonatomic, assign) int emergencyContactId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *number;

@end
