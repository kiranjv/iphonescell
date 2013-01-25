//
//  BundleUtils.m
//  safecell
//
//  Created by Mobisoft Infotech on 9/15/10.
//  Copyright 2010 Mobisoft Infotech. All rights reserved.
//

#import "BundleUtils.h"


@implementation BundleUtils

+(NSString *) bundleVersion {
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

@end
