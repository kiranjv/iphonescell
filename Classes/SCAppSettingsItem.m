//
//  SCAppSettingsItem.m
//  safecell
//
//  Created by shail m on 6/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SCAppSettingsItem.h"


@implementation SCAppSettingsItem

@synthesize itemId;
@synthesize appSettingsItem;
@synthesize value;


- (void) dealloc {
	[appSettingsItem release];
	[value release];
	[super dealloc];
}


@end
