	//
//  GamePlaySettingsViewController.m
//  safecell
//
//  Created by shail on 20/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameplaySettingsViewController.h"
#import "NavBarHelper.h"
#import "AppSettingsItemRepository.h"


@implementation GameplaySettingsViewController

- (id) init {
	self = [super init];
	if (self != nil) {
		[self createContents];
		
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	AppSettingsItemRepository *appSettingsItemsRepository = [[AppSettingsItemRepository alloc] init];
	BOOL gameplay = [appSettingsItemsRepository isGameplayOn];	
	gameplaySwitch.on = gameplay;
	[appSettingsItemsRepository release];
}

-(void) addBackgroundImageView {
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	imageView.image = [UIImage imageNamed:@"background.png"];
	[self.view addSubview:imageView];
	[imageView release];
}

-(void) addToggleGameplayLabel {
	UILabel *gameplayLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 28, 150, 30)];
	gameplayLabel.text = @"Toggle Gameplay";
	gameplayLabel.backgroundColor = [UIColor clearColor];
	gameplayLabel.font = [UIFont boldSystemFontOfSize:16];
	[self.view addSubview:gameplayLabel];	
	[gameplayLabel release];
}

-(void) addToggleGameplaySwitch {
	gameplaySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(190, 30, 120, 30)];
	[gameplaySwitch addTarget:self action:@selector(gameplaySwitchValueChanged) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:gameplaySwitch];
}

-(void) addInstructionsLabel {
	UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 280, 80)];
	instructionsLabel.text = @"You can control gameplay settings. If you would like to participate in Safecell game make sure that the settings are on.";
	instructionsLabel.numberOfLines = 0;
	instructionsLabel.backgroundColor = [UIColor clearColor];
	instructionsLabel.font = [UIFont systemFontOfSize:14];
	[self.view addSubview:instructionsLabel];
	[instructionsLabel release];
}

-(void) createContents {
	DecorateNavBar(self);
	self.navigationItem.title = @"Gameplay";
	[self addBackgroundImageView];
	[self addToggleGameplayLabel];
	[self addToggleGameplaySwitch];
	[self addInstructionsLabel];
}

- (void)dealloc {
	[gameplaySwitch release];
    [super dealloc];
}

-(void) gameplaySwitchValueChanged {
	AppSettingsItemRepository *appSettingsItemsRepository = [[AppSettingsItemRepository alloc] init];
	[appSettingsItemsRepository updateGameplaySetting:gameplaySwitch.on];
	[appSettingsItemsRepository release];
}


@end
