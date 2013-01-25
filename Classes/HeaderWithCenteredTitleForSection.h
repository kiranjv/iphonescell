//
//  CenteredHeaderForSection.h
//  safecell
//
//  Created by shail on 05/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HeaderWithCenteredTitleForSection : UIView {
	UILabel *headerLabel;
	NSString *title;
}
@property (nonatomic, retain) NSString *title;

-(void)contentforHeaderView;
@end
