//
//  NotificationSoundsSettingsViewController.m
//  safecell
//
//  Created by Mobisoft Infotech on 8/26/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "NotificationSoundsSettingsViewController.h"
#import "AppSettingsItemRepository.h"


@implementation NotificationSoundsSettingsViewController



- (void)viewWillAppear:(BOOL)animated {
	AppSettingsItemRepository *appSettingsItemsRepository = [[AppSettingsItemRepository alloc] init];
	BOOL soundsOn = [appSettingsItemsRepository areNotificationSoundsOn];	
	notificationSwitch.on = soundsOn;
	[appSettingsItemsRepository release];
}

-(void) addBackgroundImageView {
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	imageView.image = [UIImage imageNamed:@"background.png"];
	[self.view addSubview:imageView];
	[imageView release];
}

-(void) addToggleNotificationsLabel {
	UILabel *gameplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 28, 170, 30)];
	gameplayLabel.text = @"Notification Sounds";
	gameplayLabel.backgroundColor = [UIColor clearColor];
	gameplayLabel.font = [UIFont boldSystemFontOfSize:16];
	[self.view addSubview:gameplayLabel];	
	[gameplayLabel release];
}

-(void) addToggleNotificationsSwitch {
	notificationSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(190, 30, 120, 30)];
	[notificationSwitch addTarget:self action:@selector(notificationSwitchValueChanged) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:notificationSwitch];
}

-(void) addInstructionsLabel {
	UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 280, 80)];
	instructionsLabel.text = @"If you want audio notifications about school zones and driving rules during your trips, leave this on.";
	instructionsLabel.numberOfLines = 0;
	instructionsLabel.backgroundColor = [UIColor clearColor];
	instructionsLabel.font = [UIFont systemFontOfSize:14];
	[self.view addSubview:instructionsLabel];
	[instructionsLabel release];
}

-(void) createContents {
	DecorateNavBar(self);
	self.navigationItem.title = @"Notification Sounds";
	[self addBackgroundImageView];
	[self addToggleNotificationsLabel];
	[self addToggleNotificationsSwitch];
	[self addInstructionsLabel];
}

-(void) notificationSwitchValueChanged {
	AppSettingsItemRepository *appSettingsItemsRepository = [[AppSettingsItemRepository alloc] init];
	[appSettingsItemsRepository updateNotificationSoundsSetting:notificationSwitch.on];
	[appSettingsItemsRepository release];
}

- (id) init {
	self = [super init];
	if (self != nil) {
		[self createContents];
		
	}
	return self;
}

- (void)dealloc {
	[notificationSwitch release];
    [super dealloc];
}

@end
