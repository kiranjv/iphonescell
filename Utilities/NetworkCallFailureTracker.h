#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"



@interface NetworkCallFailureTracker : NSObject {
	NSMutableArray *responseCodesToTrack;
	int retriesExecuted;
	int retriesAllowed;
	
	id<NSObject> target;
	SEL startRequestSelector;
	SEL requestFinallyFailedSelector;
	
	BOOL finishedTracking;
	
	NSDictionary *requestInfo;
}

@property (nonatomic, assign) int retriesExecuted;
@property (nonatomic, assign) int retriesAllowed;
@property (nonatomic, readonly) BOOL finishedTracking;
@property (nonatomic, retain) NSDictionary *requestInfo; 

- (id) initWithRetriesAllowed:(int) retries;

-(void) addTarget: (id<NSObject>) targetObj startRequestSelector: (SEL) startRequest requestFinallyFailedSelector: (SEL) requestFinallyFailed;

-(void) start;
-(void) failedForOnce: (ASIHTTPRequest *) request;
-(void) trackResponseCodesWithTotalCount: (int) count, ...;

@end
