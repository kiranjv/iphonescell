//
//  AppSettingsItemRepository.m
//  safecell
//
//  Created by shail m on 6/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppSettingsItemRepository.h"
#import "ServerDateFormatHelper.h"

static NSString *BASE_SELECT_QUERY = @"SELECT id, settings_item, value FROM app_settings_items";

@implementation AppSettingsItemRepository

-(SCAppSettingsItem *) appSettingsItemFromResultSet: (FMResultSet *) resultSet {
	SCAppSettingsItem *item = [[[SCAppSettingsItem alloc] init] autorelease];
	
	item.itemId = [resultSet intForColumn:@"id"];
	item.appSettingsItem = [resultSet stringForColumn:@"settings_item"];
	item.value = [resultSet stringForColumn:@"value"];
	
	return item;
}

-(void) updateDate:(NSDate *) date forSettingsItem: (NSString *) settingsItem {
	NSString *dateStr = [ServerDateFormatHelper formattedDateForJSON:date];
	NSString *query = [NSString stringWithFormat:@"UPDATE app_settings_items SET value = ? WHERE settings_item = '%@'", settingsItem];
	[db executeUpdate:query, [NSString stringWithFormat:@"%@", dateStr]];
}

-(NSDate *) dateForSettingsItem: (NSString *) settingsItem {
	NSString *query = [NSString stringWithFormat:@"%@ WHERE settings_item = '%@'", BASE_SELECT_QUERY, settingsItem];
	
	FMResultSet *resultSet = [db executeQuery:query];
	[resultSet next];
	SCAppSettingsItem *settingsObject = [self appSettingsItemFromResultSet:resultSet];
	[resultSet close];
    
	NSDate *settingsItemDate = [ServerDateFormatHelper dateFormServerString:settingsObject.value];
	return settingsItemDate;
}

#pragma mark -
#pragma mark Game Play

-(void) updateGameplaySetting: (BOOL) gameplay {
	NSString *query = @"UPDATE app_settings_items SET value = ? WHERE settings_item = 'gameplay'";
	[db executeUpdate:query, [NSString stringWithFormat:@"%d", gameplay]];
}

-(BOOL) isGameplayOn {
	NSString *query = [NSString stringWithFormat:@"%@ WHERE settings_item = 'gameplay'", BASE_SELECT_QUERY];
	
	FMResultSet *resultSet = [db executeQuery:query];
	[resultSet next];
	SCAppSettingsItem *gamePlaySetting = [self appSettingsItemFromResultSet:resultSet];
	[resultSet close];
	
	BOOL gameplayOn = [gamePlaySetting.value boolValue];
	
	return gameplayOn;
}

#pragma mark -
#pragma mark Tracking State

-(void) updateTrackingState: (NSString *) trackingState {
    NSLog(@"trackingState = %@",trackingState);
	NSString *query = @"UPDATE app_settings_items SET value = ? WHERE settings_item = 'tracking state'";
	[db executeUpdate:query, [NSString stringWithFormat:@"%@", trackingState]];
}

-(NSString *) trackingState {
	NSString *query = [NSString stringWithFormat:@"%@ WHERE settings_item = 'tracking state'", BASE_SELECT_QUERY];
	
	FMResultSet *resultSet = [db executeQuery:query];
	[resultSet next];
	SCAppSettingsItem *gamePlaySetting = [self appSettingsItemFromResultSet:resultSet];
	[resultSet close];
	
	return gamePlaySetting.value;
}

#pragma mark -
#pragma mark Activation Date 

-(void) updateActivateShownOn: (NSDate *) date {
	NSString *dateStr = [ServerDateFormatHelper formattedDateForJSON:date];
	NSString *query = @"UPDATE app_settings_items SET value = ? WHERE settings_item = 'activate shown on'";
	[db executeUpdate:query, [NSString stringWithFormat:@"%@", dateStr]];
}

-(NSDate *) activateShownOn {
	NSString *query = [NSString stringWithFormat:@"%@ WHERE settings_item = 'activate shown on'", BASE_SELECT_QUERY];
	
	FMResultSet *resultSet = [db executeQuery:query];
	[resultSet next];
	SCAppSettingsItem *actiavtionShownOnSetting = [self appSettingsItemFromResultSet:resultSet];
	[resultSet close];
	
	NSDate *activationShownOnDate = [ServerDateFormatHelper dateFormServerString:actiavtionShownOnSetting.value];
	return activationShownOnDate;
}


#pragma mark -
#pragma mark Profile Downloaded On

-(void) updateProfileDownloadedOn:(NSDate *) date {
	NSLog(@"Updating Profile Downloading on to: %@", date);
	[self updateDate:date forSettingsItem:@"profile downloaded on"];
}

-(NSDate *) profileDownloadedOn {
	return [self dateForSettingsItem:@"profile downloaded on"];
}

#pragma mark -
#pragma mark Notification Sounds

-(void) updateNotificationSoundsSetting: (BOOL) soundsOn {
	NSString *query = @"UPDATE app_settings_items SET value = ? WHERE settings_item = 'notification sounds'";
	[db executeUpdate:query, [NSString stringWithFormat:@"%d", soundsOn]];
}

-(BOOL) areNotificationSoundsOn {
	NSString *query = [NSString stringWithFormat:@"%@ WHERE settings_item = 'notification sounds'", BASE_SELECT_QUERY];
	
	FMResultSet *resultSet = [db executeQuery:query];
	[resultSet next];
	SCAppSettingsItem *notificationSetting = [self appSettingsItemFromResultSet:resultSet];
	[resultSet close];
	
	BOOL soundsOn = [notificationSetting.value boolValue];
	
	return soundsOn;
}

@end
