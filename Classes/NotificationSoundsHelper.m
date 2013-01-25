//
//  NotificationSoundsHelper.m
//  safecell
//
//  Created by Mobisoft Infotech on 8/24/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "NotificationSoundsHelper.h"

static NSString *PHONE_STATUS = @"cell-phone";
static NSString *SMS_STATUS = @"texting";
static NSString *SCHOOL_STATUS = @"school-zone";

@implementation NotificationSoundsHelper

@synthesize player;
@synthesize currentPlayingSound;
@synthesize deactivateAudioSessionTimer;
@synthesize playNotifications;


-(void) startDeactivateAudioSessionTimer {
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.3
													  target:self
													selector:@selector(deactivateAudioSession)
													userInfo:nil
													 repeats:NO];
	
	self.deactivateAudioSessionTimer = timer;
}

-(void) stopDeactivateAudioSessionTimer {
	if (deactivateAudioSessionTimer != nil) {
		[deactivateAudioSessionTimer invalidate];
		self.deactivateAudioSessionTimer = nil;
	}
}

-(void) activateAudioSession {
	BOOL result = AudioSessionSetActive(YES);
	if (result) {
		NSLog(@"---------->Audio session activated");
	} else {
		NSLog(@"==========>Audio session activation failed");
	}

}

-(void) deactivateAudioSession {
	BOOL result = AudioSessionSetActive(NO);
	if (result) {
		NSLog(@"--------->Audio session deactivated");
	} else {
		NSLog(@"=========>Audio session deactivation failed");
	}

}

- (id) init {
	self = [super init];
	if (self != nil) {
		soundsQueue = [[NSMutableArray alloc] init];
	}
	return self;
}

-(BOOL) isPlaying {
	return (self.player != nil);
}

-(void) playSound: (NSString *) fileName {
	self.currentPlayingSound = fileName;
	NSLog(@"self.currentPlayingSound: %@", self.currentPlayingSound);
	
	NSString *soundFilePath = [[NSBundle mainBundle] pathForResource: fileName ofType: @"mp3"];
	
	NSURL *soundFileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
	AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: soundFileURL error: nil];
	
	self.player = newPlayer;
    	
	[soundFileURL release];
	[newPlayer release];
	
	self.player.delegate = self;
	[self.player prepareToPlay];
	[self activateAudioSession];
	
	// Following 2 statements are required because of a bug in iOS4
	// This bug renders a call to AudioSessionSetActive(NO) from
	// audioPlayerDidFinishPlaying method useless. Hence the use
	// of the timer to call it.
	
	[self stopDeactivateAudioSessionTimer];
	
	[self.player play];
}

-(void) enqueueSound: (NSString *) soundIdentifier {
	if ([soundsQueue containsObject:soundIdentifier] || 
		[soundIdentifier isEqualToString:self.currentPlayingSound]) {
		return;
	}
	
	[soundsQueue addObject:soundIdentifier];
}

-(void) enqueueSchoolStatusSound {
	[self enqueueSound:SCHOOL_STATUS];
}

-(void) enqueueSMSStatusSound {
	[self enqueueSound:SMS_STATUS];
}

-(void) enqueuePhoneStatusSound {
	[self enqueueSound:PHONE_STATUS];
}

-(void) enqueueSchoolActiveStatus: (BOOL) status {
	
	if (!self.playNotifications) {
		return;
	}
	
	NSLog(@"status: %d, previousPhoneActiveStatus: %d", status, previousPhoneActiveStatus);
	
	if ((status == YES) && (previousSchoolActiveStatus != status)) {
		
		if (![self isPlaying]) {
			NSLog(@"play");
			[self playSound:SCHOOL_STATUS];
		} else {
			NSLog(@"queue");
			[self enqueueSchoolStatusSound];
		}
		
	}
	
	previousSchoolActiveStatus = status;
}

-(void) enqueuePhoneActiveStatus: (BOOL) status {
	
	if (!self.playNotifications) {
		return;
	}
	
	NSLog(@"status: %d, previousPhoneActiveStatus: %d", status, previousPhoneActiveStatus);
	
	if ((status == YES) && (previousPhoneActiveStatus != status)) {
		
		if (![self isPlaying]) {
			NSLog(@"play");
			[self playSound:PHONE_STATUS];
		} else {
			NSLog(@"queue");
			[self enqueuePhoneStatusSound];
		}
		
	}
	
	previousPhoneActiveStatus = status;
}

-(void) enqueueSMSActiveStatus: (BOOL) status {
	
	if (!self.playNotifications) {
		return;
	}
	
	NSLog(@"status: %d, previousSMSActiveStatus: %d", status, previousSMSActiveStatus);
	
	if ((status == YES) && (previousSMSActiveStatus != status)) {
				
		if (![self isPlaying]) {
			NSLog(@"play");
			[self playSound:SMS_STATUS];
		} else {
			NSLog(@"queue");
			[self enqueueSMSStatusSound];
		}
		
	}
	
	previousSMSActiveStatus = status;
}

-(void) cleanUpBeforeStoppingTrip {
	[self stopDeactivateAudioSessionTimer];
	[soundsQueue removeAllObjects];
	self.player.delegate = nil;
	[self.player stop];
	self.player = nil;
	[self deactivateAudioSession];
}

- (void) dealloc  {
	
	[self stopDeactivateAudioSessionTimer];
	
	[currentPlayingSound release];
	[soundsQueue release];
	[player release];
	[super dealloc];
}

-(void) playNextNotification {
	NSLog(@"soundsQueue.count: %d", soundsQueue.count);
	if (soundsQueue.count == 0) {
		return;
	}	
	
	NSString *nextFileIdentifier = [soundsQueue objectAtIndex:0];
	
	BOOL skip = NO;
	
	
	// Here note that it is possible that when the actual notification comes up
	// for playing the respective status might have chaged. Hence we check
	// previous respective active status and if it is NO we just skip the 
	// the notification.
	
	if ([SCHOOL_STATUS isEqualToString:nextFileIdentifier] && (previousSchoolActiveStatus == NO)) {
		skip = YES;
	}
	
	if ([SMS_STATUS isEqualToString:nextFileIdentifier] && (previousSMSActiveStatus == NO)) {
		skip = YES;
	}
	
	if ([PHONE_STATUS isEqualToString:nextFileIdentifier] && (previousPhoneActiveStatus == NO)) {
		skip = YES;
	}
	
	[soundsQueue removeObjectAtIndex:0];
	NSLog(@"soundsQueue.count: %d", soundsQueue.count);
	if (skip) {
		[self playNextNotification];
	} else {
		[self playSound:nextFileIdentifier];
	}
}

#pragma mark -
#pragma mark AVAudioPlayerDelegate 

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	[self.player stop];
	self.player.delegate = nil;
	self.player = nil;
	[self startDeactivateAudioSessionTimer];
	[self playNextNotification];
}


@end
