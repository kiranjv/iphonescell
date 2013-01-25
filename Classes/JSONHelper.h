//
//  JSONHelper.h
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JSONHelper : NSObject {

}

+(NSDictionary *) dictFromString:(NSString *) jsonStr;
+(NSArray *) arrayFromString:(NSString *) jsonStr;

+(NSString *) jsonFromDict: (NSDictionary *) dict;


+(NSDate *) dateForKey: (NSString *) key fromDict: (NSDictionary *) dict;
+(NSString *) stringForKey: (NSString *) key fromDict: (NSDictionary *) dict;
+(BOOL) boolForKey: (NSString *) key fromDict: (NSDictionary *) dict;
+(int) integerForKey: (NSString *) key fromDict: (NSDictionary *) dict;

@end
