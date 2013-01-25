//
//  NSString+Common.h
//  Pocket Tabs
//
//  Created by Ben Scheirman on 12/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common) 

-(BOOL)isBlank;
-(BOOL)contains:(NSString *)string;
-(NSArray *)splitOnChar:(char)ch;
-(NSString *)substringFrom:(NSInteger)from to:(NSInteger)to;
-(NSString *)stringByStrippingWhitespace;

-(int) indexOfString: (NSString *) str;
-(int) lastIndexOfString:(NSString *) str;

-(BOOL) equalsIgnoreCase:(NSString *) str;

@end

NSString * EmptyIfNull(NSString *);