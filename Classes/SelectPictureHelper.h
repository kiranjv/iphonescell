//
//  SelectPictureHelper.h
//  safecell
//
//  Created by shail m on 6/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SelectPictureHelperDelegate;

@interface SelectPictureHelper : NSObject<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	NSMutableArray *options;
	UIViewController *parent;
	NSObject<SelectPictureHelperDelegate> *_delegate;
}

@property(nonatomic, assign) UIViewController *parent;
@property(nonatomic, assign) NSObject<SelectPictureHelperDelegate> *delegate;

- (void) selectPictureFor:(UIViewController *) viewController;

@end

@protocol SelectPictureHelperDelegate 

@optional

-(void) didFinishPickingImageWithInfo: (NSDictionary *) imageInfo;

@end