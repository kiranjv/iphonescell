//
//  ModalViewController.m
//  safecell
//
//  Created by shail on 13/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ModalViewController.h"
#import "AppDelegate.h"


@implementation ModalViewController

@synthesize delegate;

- (id) init {
	self = [super init];
	if (self != nil) {
		[self.view setFrame:CGRectMake(0, 20, 320, 460)];
		self.view.userInteractionEnabled = YES;
	}
	return self;
}

-(void) showModalFromTop {
	fromBottom = NO;
	[self.view setFrame:CGRectMake(0, -460, 320, 460)];
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.window addSubview:self.view];
	
	[UIView beginAnimations:nil context:NULL];	
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector: @selector(showModalAnimationDidStop)];
	[self.view setFrame:CGRectMake(0, 20, 320, 460)];
	[UIView commitAnimations];
}

-(void) showModelFromBottom {
	fromBottom = YES;
	[self.view setFrame:CGRectMake(0, 480, 320, 460)];
	AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate.window addSubview:self.view];	
	
	[UIView beginAnimations:nil context:NULL];	
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector: @selector(showModalAnimationDidStop)];
	[self.view setFrame:CGRectMake(0, 20, 320, 460)];
	[UIView commitAnimations];
}

-(void) showModalAnimationDidStop {
	if(delegate && [delegate respondsToSelector:@selector(modalViewDidShow)]) {
		[delegate modalViewDidShow];
	}  
}

-(void) hide {
	[UIView beginAnimations:nil context:NULL];	
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector: @selector(hideAnimationDidStop)];
	if (fromBottom) {
		[self.view setFrame:CGRectMake(0, 480, 320, 460)];
	} else {
		[self.view setFrame:CGRectMake(0, -460, 320, 460)];
	}
	
	[UIView commitAnimations];
}

//Subclasses must give a call to super while overriding this method.
-(void) hideAnimationDidStop {
	[self.view removeFromSuperview];
	
	if(delegate && [delegate respondsToSelector:@selector(modalViewDidHide)]) {
		[delegate modalViewDidHide];
	}  
}


@end
