#import "NetworkCallFailureTracker.h"


@implementation NetworkCallFailureTracker


@synthesize retriesExecuted;
@synthesize retriesAllowed;
@synthesize finishedTracking;
@synthesize requestInfo;

#pragma mark Private Methods

-(void) setDefaultValuesForInstanceVariables {
	responseCodesToTrack = [[NSMutableArray alloc] init];
	retriesExecuted = 0;
	retriesAllowed = 0;
}

-(void) startRequest {
	if (requestInfo == nil) {
		[target performSelector:startRequestSelector];
	} else {
		[target performSelector:startRequestSelector withObject:requestInfo];
	}

}

-(void) invokeRequestFinallyFailedSelector:(ASIHTTPRequest *) request {
	NSLog(@"Request Finally Failed After retries : %d", retriesExecuted);
	if ((target != nil) && [target respondsToSelector:requestFinallyFailedSelector]) {
		[target performSelector:requestFinallyFailedSelector withObject:request];
	}
	
	finishedTracking = YES;
}


#pragma mark -
#pragma mark Public Methods

- (id) init {
	self = [super init];
	if (self != nil) {
		[self setDefaultValuesForInstanceVariables];
	}
	return self;
}

- (id) initWithRetriesAllowed:(int) retries {
	self = [super init];
	if (self != nil) {
		[self setDefaultValuesForInstanceVariables];
		retriesAllowed = retries;
	}
	return self;
}

-(void) trackResponseCodesWithTotalCount: (int) count, ... {
	va_list ap;

    va_start(ap, count); 
    for(int j = 0; j < count; j++) {
        int responseCode = va_arg(ap, int); 
		NSNumber *responseCodeNumber = [NSNumber numberWithInt:responseCode];
		[responseCodesToTrack addObject:responseCodeNumber];
	}
    va_end(ap);
}

-(void) addTarget: (id<NSObject>) targetObj startRequestSelector: (SEL) startRequest requestFinallyFailedSelector: (SEL) requestFinallyFailed {
	target = targetObj;
	startRequestSelector = startRequest;
	requestFinallyFailedSelector = requestFinallyFailed;
}

-(void) start {
	[self startRequest];
}

-(void) failedForOnce: (ASIHTTPRequest *) request {
	
	if (finishedTracking) {
		return;
	}
	
	BOOL retry = NO;
		
	NSNumber *responseCode = [NSNumber numberWithInt:[request responseStatusCode]];
	if ([responseCodesToTrack containsObject:responseCode]) {
		retriesExecuted += 1;
		NSLog(@"retriesExecuted : %d", retriesExecuted);
		if (retriesExecuted == retriesAllowed) {
			retry = NO;
		} else {
			retry = YES;
		}
	}

	if (retry) {
		[self startRequest];
	} else {
		[self invokeRequestFinallyFailedSelector: request];
	}
}

- (void) dealloc {
	[requestInfo release];
	[responseCodesToTrack release];
	[super dealloc];
}


@end
