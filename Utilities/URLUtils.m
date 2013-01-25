//
//  URLUtils.m
//  safecell
//
//  Created by shail m on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "URLUtils.h"


@implementation URLUtils


+ (NSString *)urlEncodeValue:(NSString *)str {
	NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)str, NULL, CFSTR(":/?#[]@!$&'()*+,;=\""), kCFStringEncodingUTF8);
	return [result autorelease];
}

@end
