//
//  ServerDateFormatHelper.h
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ServerDateFormatHelper : NSObject {

}

+(NSString *) formattedDateForJSON:(NSDate *) date;
+(NSDate *) dateFormServerString:(NSString *) dateStr;

@end
