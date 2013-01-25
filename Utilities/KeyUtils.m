//
//  KeyUtils.m
//  safecell
//
//  Created by Mobisoft Infotech on 10/22/10.
//  Copyright 2010 Mobisoft Infotech. All rights reserved.
//

#import "KeyUtils.h"

@implementation KeyUtils


+(NSString *) GUID {
    

	CFUUIDRef uuid = CFUUIDCreate(0);
	CFStringRef GUIDStr = CFUUIDCreateString(0,uuid);
	NSString *GUID = (NSString *)GUIDStr;
	NSString *GUIDKey = [GUID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *newStr = [GUIDKey substringWithRange:NSMakeRange(14, [GUIDKey length]-14)];
    NSLog(@"newStr = %@",newStr);
    NSMutableString *mu = [NSMutableString stringWithString:newStr];
    [mu insertString:[NSString stringWithFormat:@"%@",[NSDate date]] atIndex:0];
    NSString *GUIDFinalString = (NSString *)mu;
    GUIDFinalString = [GUIDFinalString stringByReplacingOccurrencesOfString:@" +0000" withString:@""];
    GUIDFinalString = [GUIDFinalString stringByReplacingOccurrencesOfString:@":" withString:@""];
    GUIDFinalString = [GUIDFinalString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    GUIDFinalString = [GUIDFinalString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"GUIDFinalString = %@",GUIDFinalString);
	CFRelease(GUIDStr);
	CFRelease(uuid);
	return GUIDFinalString;
}

@end
