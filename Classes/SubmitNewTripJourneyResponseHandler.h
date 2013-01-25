//
//  SubitNewTripJourneyResponseHandler.h
//  safecell
//
//  Created by shail m on 5/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SubmitNewTripJourneyResponseHandler : NSObject {
	NSString *jsonResponse;
}

@property (nonatomic, retain) NSString *jsonResponse;

-(void) process;

@end
