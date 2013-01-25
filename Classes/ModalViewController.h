//
//  ModalViewController.h
//  safecell
//
//  Created by shail on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModalViewControllerDelegate.h"

@interface ModalViewController : UIViewController {
	id<ModalViewControllerDelegate> delegate;
	
	BOOL fromBottom;
}

@property(nonatomic, assign) id<ModalViewControllerDelegate> delegate;

-(void) showModelFromBottom;
-(void) showModalFromTop;
-(void) showModalAnimationDidStop;

-(void) hide;
//Subclasses must give a call to super while overriding this method.
-(void) hideAnimationDidStop;

@end
