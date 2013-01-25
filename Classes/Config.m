//
//  Config.m
//  safecell
//
//  Created by Ben Scheirman on 4/23/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "Config.h"


@implementation Config

+(NSDictionary *)configDictionary {
  	NSBundle *bundle = [NSBundle bundleForClass:[Config class]];

	NSString *plistPath = [bundle pathForResource:@"safecell" ofType:@"plist"];
	NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
	return [dict autorelease];
}

+(NSString *)baseURL {
	return [[self configDictionary] objectForKey:@"baseURL"];
}
/*+(NSString *)localURL {
	return [[self configDictionary] objectForKey:@"locaLURL"];
}*/

@end
