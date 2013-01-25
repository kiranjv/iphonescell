//
//  LocationStripeController.h
//  safecell
//
//  Created by shail m on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


static const int kLocationStripeHeight = 12;

@interface LocationStripeController : NSObject<MKReverseGeocoderDelegate> {
	NSString *location;
	UILabel *locationLabel;
	UIView *view;
	MKReverseGeocoder *geoCoder;
}

@property(nonatomic, retain) UIView *view;
@property(nonatomic, retain) NSString *location;
@property(nonatomic, retain) MKReverseGeocoder *geoCoder;

-(void) createContents;
-(void) locationChanged;

@end
