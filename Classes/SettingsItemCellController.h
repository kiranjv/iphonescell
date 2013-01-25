//
//  SettingsCellController.h
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SettingsItem;

@interface SettingsItemCellController : C1DisclosureIndicatorCell {
	SettingsItem *settingsItem;
}

@property (nonatomic, retain) SettingsItem *settingsItem;

- (id) initWithParentController: (UIViewController *) parentController settingsItem: (SettingsItem *) item;

@end
