//
//  UserDefaults.h
//  safecell
//
//  Created by Mobisoft Infotech on 10/22/10.
//  Copyright 2010 Mobisoft Infotech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserDefaults : NSObject {

}

+ (BOOL) setValue: (NSString *) value forKey: (NSString *) key;
+ (NSString *) valueForKey: (NSString *) key;

@end
