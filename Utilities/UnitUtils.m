//
//  UnitUtils.m
//  safecell
//
//  Created by shail on 08/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UnitUtils.h"


@implementation UnitUtils

+(float) kilometersToMiles: (float) kilometers {
	float conversionFactor = 0.621371192;
	return kilometers * conversionFactor;
}

@end
