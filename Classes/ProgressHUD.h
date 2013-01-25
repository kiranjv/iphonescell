//
//  ProgressHUD.h
//  safecell
//
//  Created by shail m on 6/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBProgressHUD.h"

@interface ProgressHUD : NSObject<MBProgressHUDDelegate> {
	MBProgressHUD *progressHUD;
	BOOL shownAnimated;
}

@property(nonatomic, retain) MBProgressHUD *progressHUD;

-(void) showHUDWithLable:(NSString *) label inView:(UIView *) view animated: (BOOL) animated;
-(void) showHUDWithLable:(NSString *) label inView:(UIView *) view;
-(void) hideHUD;
-(void) setLabel: (NSString *) newLabel;

@end
