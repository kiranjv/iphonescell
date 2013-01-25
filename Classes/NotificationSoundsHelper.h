//
//  NotificationSoundsHelper.h
//  safecell
//
//  Created by Mobisoft Infotech on 8/24/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface NotificationSoundsHelper : NSObject<AVAudioPlayerDelegate> {
	NSMutableArray *soundsQueue;
	AVAudioPlayer *player;
	
	BOOL previousSchoolActiveStatus;
	BOOL previousPhoneActiveStatus;
	BOOL previousSMSActiveStatus;
	
	BOOL playNotifications;
	
	NSString *currentPlayingSound;
	
	NSTimer *deactivateAudioSessionTimer;
}

@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) NSString *currentPlayingSound;
@property (nonatomic, retain) NSTimer *deactivateAudioSessionTimer;
@property (nonatomic, assign) BOOL playNotifications;

-(void) enqueueSchoolActiveStatus: (BOOL) status;
-(void) enqueuePhoneActiveStatus: (BOOL) status;
-(void) enqueueSMSActiveStatus: (BOOL) status;

-(void) cleanUpBeforeStoppingTrip;

@end
