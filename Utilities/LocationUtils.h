//
//  LocationUtils.h
//  safecell
//
//  Created by shail on 07/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationUtils : NSObject {

}

+(double) distanceFrom: (CLLocationCoordinate2D) from to: (CLLocationCoordinate2D) to;

@end
