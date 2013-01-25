/*
 *  NetworkAware.h
 *  safecell
 *
 *  Created by shail on 13/05/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */


@protocol NetworkOperationDelegate<NSObject>

@optional

-(void) doneUploadingRequest;
-(void) networkOperationSucceeded: (NSString *) responseString;
-(void) networkOperationFailedWithStatusCode: (int) statusCode;
-(void) networkOpreationCancelled;

@end