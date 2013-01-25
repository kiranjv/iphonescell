//
//  UIUtils.h
//  AwarenessRibbons
//
//  Created by Prasad Tandulwadkar on 25/11/09.
//  Copyright 2009 Mobisoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIUtils : NSObject {

}

+ (float) heightOfText:(NSString *) text withWidth:(float) width font:(UIFont *) font  lineBreakMode:(UILineBreakMode) lineBreakMode;

+ (UIColor *) colorFromHexColor: (NSString *) hexColor;

@end
