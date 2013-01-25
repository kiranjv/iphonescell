//
//  City.h
//  AdsAroundMe
//
//  Created by Adodis on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface City : NSObject {
	NSString*	mCityName;
	NSString*	mCityDescription;
}
@property (nonatomic, retain) NSString* mCityName;
@property (nonatomic, retain) NSString* mCityDescription;

@end
