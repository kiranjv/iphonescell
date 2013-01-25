//
//  UICGoogleMapsAPI.h
//  AdsAroundMe
//
//  Created by Adodis on 1/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICGoogleMapsAPI;

@protocol UICGoogleMapsAPIDelegate<NSObject>
@optional
- (void)goolgeMapsAPI:(UICGoogleMapsAPI *)goolgeMapsAPI didGetObject:(NSObject *)object;
- (void)goolgeMapsAPI:(UICGoogleMapsAPI *)goolgeMapsAPI didFailWithMessage:(NSString *)message;
@end

@interface UICGoogleMapsAPI : UIWebView<UIWebViewDelegate> 
//{
//	NSString *jsonRepresentation;
//}
//@property (nonatomic , retain) NSString *jsonRepresentation;
- (void)makeAvailable;
@end
