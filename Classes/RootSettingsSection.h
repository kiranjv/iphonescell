//
//  RootSettingsSection.h
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RootSettingsSection : C1TableSection {
	NSMutableArray *settingsItems;
}

- (id) initWithParentController: (UIViewController *) parentController;
-(void) setUpSettingsItemsArray;
-(void) addSettingsRows;

@end
