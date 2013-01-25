//
//  AppSettingsItemRepository.h
//  safecell
//
//  Created by shail m on 6/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCAppSettingsItem.h"
#import "AbstractRepository.h"

#define TRACKING_OFF @"tracking off"
#define TRACKING_ON @"tracking"
#define TRACKING_TO_SAVE @"to save"

@interface AppSettingsItemRepository : AbstractRepository {

}

-(void) updateGameplaySetting: (BOOL) gameplay;
-(BOOL) isGameplayOn;

-(void) updateTrackingState: (NSString *) trackingState;
-(NSString *) trackingState;

-(void) updateActivateShownOn: (NSDate *) date;
-(NSDate *) activateShownOn;

-(void) updateProfileDownloadedOn:(NSDate *) date;
-(NSDate *) profileDownloadedOn;

-(BOOL) areNotificationSoundsOn;
-(void) updateNotificationSoundsSetting: (BOOL) soundsOn;

@end
