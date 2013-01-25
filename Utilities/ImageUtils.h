//
//  ImageUtils.h
//  Realtor
//
//  Created by prasad tandulwadkar on 11/10/09.
//  Copyright 2009 Acpce. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImageUtils : NSObject {

}

+ (UIImage *) scaleImageDisregardAspectRatio:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight;
+ (UIImage *) scaleImage:(UIImage *) image maxWidth:(float) maxWidth maxHeight:(float) maxHeight;
+ (UIImage *) scaleImage:(UIImage *) image maxWidth:(float) maxWidth;
+ (UIImage *) cropImage:(UIImage *)imageToCrop toRect:(CGRect)rect;
+ (UIImage *) scaleAndCropImage:(UIImage*) image maxWidth:(float)toWidth maxHeight:(float)toHeight;

@end
