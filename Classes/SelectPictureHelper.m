//
//  SelectPictureHelper.m
//  safecell
//
//  Created by shail m on 6/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SelectPictureHelper.h"

static NSString* CAMERA = @"Camera";
static NSString* CAMERA_ROLL = @"Camera Roll";
static NSString* PHOTO_LIBRARY = @"Photo Library";

@implementation SelectPictureHelper

@synthesize parent;
@synthesize delegate = _delegate;

- (id) init {
	self = [super init];
	if (self != nil) {		
		options = [[NSMutableArray alloc] initWithCapacity:3];
		
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			[options addObject:CAMERA];
			
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
				[options addObject:CAMERA_ROLL];
			}
		}		
		
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
			[options addObject:PHOTO_LIBRARY];
		}
	}
	return self;
}


- (void) selectPictureFor:(UIViewController *) viewController {	

	self.parent = viewController;
	
	UIActionSheet *actionSheet = nil;
	
	if ([options containsObject:CAMERA]) {
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:[options objectAtIndex:0], [options objectAtIndex:1], [options objectAtIndex:2], nil];
	} else {
		actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:[options objectAtIndex:0], nil];
	}
		 
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:self.parent.view.window];
	[actionSheet release];
}


- (void) dealloc {
	[options release];
	[super dealloc];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex > ([options count] - 1)) {
		return;
	}
	
	NSString *option = [options objectAtIndex:buttonIndex];
	
	int source = UIImagePickerControllerSourceTypePhotoLibrary;
	
	if ([option isEqualToString:CAMERA]) {
		source = UIImagePickerControllerSourceTypeCamera;
	} 
	
	if([option isEqualToString:CAMERA_ROLL]) {
		source = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	}
	
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
#ifdef __IPHONE_3_1
	picker.allowsEditing = YES;
#else
	picker.allowsImageEditing = YES;
#endif
	picker.sourceType = source;
	picker.delegate = self;
	[self.parent presentModalViewController:picker animated:YES];
	[picker release];
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[self.parent dismissModalViewControllerAnimated:YES];
	if (self.delegate && [self.delegate respondsToSelector:@selector(didFinishPickingImageWithInfo:)]) {
		[self.delegate didFinishPickingImageWithInfo:info];
	}
														  
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self.parent dismissModalViewControllerAnimated:YES];	
}

@end
