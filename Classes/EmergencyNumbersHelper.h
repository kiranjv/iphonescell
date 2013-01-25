//
//  EmergencyNumbersHelper.h
//  safecell
//
//  Created by shail m on 6/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EmergencyNumbersHelper : NSObject<UIActionSheetDelegate> {
	NSMutableArray* emergencyContacts;
}

-(void) showEmergencyNumbers: (UIViewController *)viewController;

@end
