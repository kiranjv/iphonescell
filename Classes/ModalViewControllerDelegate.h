/*
 *  ModalViewControllerDelegate.h
 *  safecell
 *
 *  Created by shail on 13/05/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

@protocol ModalViewControllerDelegate<NSObject>

@optional

-(void) modalViewDidShow;
-(void) modalViewDidHide;

@end