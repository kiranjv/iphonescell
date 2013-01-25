//
//  ConfigTests.m
//  safecell
//
//  Created by Ben Scheirman on 5/3/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "Config.h"

@interface ConfigTests : SenTestCase {	
}
@end


@implementation ConfigTests

-(void)testConfigDictionaryCanBeFound {
	NSBundle *bundle = [NSBundle bundleForClass:[Config class]];
	NSString* path = [bundle pathForResource:@"safecell" ofType:@"plist"];
	
	STAssertNotNil(path, @"Couldn't find safecell.plist in the resource path %@", [bundle resourcePath]);
}

-(void)testBaseURL {
	NSString *expected = @"http://safecell-test.heroku.com/api/1";
	NSString *actual = [Config baseURL];
	
	STAssertEqualObjects(expected, actual, @"Expected %@ but was %@", expected, actual);
}

@end
