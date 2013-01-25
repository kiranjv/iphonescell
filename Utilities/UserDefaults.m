//
//  UserDefaults.m
//  safecell
//
//  Created by Mobisoft Infotech on 10/22/10.
//  Copyright 2010 Mobisoft Infotech. All rights reserved.
//

#import "UserDefaults.h"


@implementation UserDefaults

+ (BOOL) setValue: (NSString *) value forKey: (NSString *) key {
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	
	if (standardUserDefaults) {
		[standardUserDefaults setObject:value forKey:key];
		[standardUserDefaults synchronize];
		
		return YES;
	} else {
		return NO;
	}
}

+ (NSString *) valueForKey: (NSString *) key {
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *val = nil;
	
	if (standardUserDefaults) {
		val = [standardUserDefaults objectForKey:key];
	}
	
	return val;
}

@end
