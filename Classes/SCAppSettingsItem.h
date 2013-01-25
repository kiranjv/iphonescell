//
//  SCAppSettingsItem.h
//  safecell
//
//  Created by shail m on 6/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SCAppSettingsItem : NSObject {
	int itemId;
	NSString *appSettingsItem;
	NSString *value;
}

@property (nonatomic, assign) int itemId;
@property (nonatomic, retain) NSString *appSettingsItem;
@property (nonatomic, retain) NSString *value;

@end
