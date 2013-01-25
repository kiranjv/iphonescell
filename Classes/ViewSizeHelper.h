//
//  ViewSizeHelper.h
//  safecell
//
//  Created by shail m on 6/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ViewSizeHelper : NSObject {

}

+(CGRect) potraitBoundsWithStatusBar: (BOOL) statusBar 
					   navigationBar: (BOOL) navigation 
							  tabBar: (BOOL) tabBar 
					  locationStripe: (BOOL) locationStripe;

@end
