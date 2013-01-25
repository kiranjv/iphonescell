//
//  ProgressHUD.m
//  safecell
//
//  Created by shail m on 6/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProgressHUD.h"

@implementation ProgressHUD

@synthesize progressHUD;

-(void) showHUDWithLable:(NSString *) label inView:(UIView *) view {
	[self showHUDWithLable:label inView:view animated: YES]; 
}

-(void) hideHUD {
	[progressHUD hide:shownAnimated];
}

-(void) showHUDWithLable:(NSString *) label inView:(UIView *) view animated: (BOOL) animated {
	MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:view];
	self.progressHUD = HUD;
	[HUD release];
	
	progressHUD.labelText = label;
	progressHUD.labelFont = [UIFont boldSystemFontOfSize:14];
	progressHUD.delegate = self;
	[view addSubview:progressHUD];
	shownAnimated = animated;
	[progressHUD show:shownAnimated];
}

-(void) setLabel: (NSString *) newLabel {
	progressHUD.labelText = newLabel;
}

- (void) dealloc {
	[progressHUD release];
	[super dealloc];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate

- (void)hudWasHidden {
	// Remove HUD from screen when the HUD was hidded
	[progressHUD removeFromSuperview];
}

@end
