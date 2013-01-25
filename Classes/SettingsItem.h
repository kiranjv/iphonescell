//
//  SettingsItem.h
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SettingsItem : NSObject {
	UIImage *image;
	NSString *title;
	NSString *controllerClassName;
}

@property(nonatomic, retain) UIImage *image;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *controllerClassName;

- (id) initWithImage:(UIImage *) iconImage title: (NSString *) itemTitle controller:(NSString *) contollerClass;

@end
