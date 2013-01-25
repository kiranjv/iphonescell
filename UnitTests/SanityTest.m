//
//  SanityTest.m
//  safecell
//
//  Created by Ben Scheirman on 5/3/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface SanityTest : SenTestCase {
	
}

- (void) testMath;

@end



@implementation SanityTest
- (void) testMath {    
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    
}

@end
