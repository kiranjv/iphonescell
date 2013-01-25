//
//  ProfileRowCellController.h
//  safecell
//
//  Created by Mobisoft Infotech on 7/19/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCProfile;

@interface ProfileRowCellController : C1RightAlignedInfoCell {
	SCProfile *profile;
}

@property (nonatomic, retain) SCProfile *profile;

@end
