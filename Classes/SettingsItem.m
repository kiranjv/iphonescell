//
//  SettingsItem.m
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsItem.h"


@implementation SettingsItem

@synthesize image;
@synthesize title;
@synthesize controllerClassName;

- (id) initWithImage:(UIImage *) iconImage title: (NSString *) itemTitle controller:(NSString *) contollerClass {
	self = [super init];
	if (self != nil) {
		self.image = iconImage;
		self.title = itemTitle;
		self.controllerClassName = contollerClass;
	}
	return self;
}


- (void) dealloc {
	[image release];
	[title release];
	[controllerClassName release];
	[super dealloc];
}

@end
