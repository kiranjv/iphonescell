//
//  PrivacyPolicyViewController.m
//  safecell
//
//  Created by Mobisoft Infotech on 6/28/10.
//  Copyright 2010 University of Houston. All rights reserved.
//

#import "PrivacyPolicyViewController.h"
#import "AlertHelper.h"


@implementation PrivacyPolicyViewController

@synthesize userAcceptedPolicy;

-(void) addTranslucentView {
	UIView *translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
	translucentView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:translucentView];
	[translucentView release];
}

-(void) addImageView {
	UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 280, 360)];
	imageView.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
	[self.view addSubview:imageView];
	[imageView release];
}

-(void) addWebView {
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(30, 8, 260, 302)];
	webView.delegate = self;
	webView.backgroundColor = [UIColor blackColor];
	webView.opaque = YES;
	[self.view addSubview:webView];
	loadTOS = YES;
	NSString *loadingText = 
		@"<div style='margin:150px 0px 0px 90px; color:gray;font-size:14px;test-align:center;font-family:sans-serif'>Loading...</div>";
	[webView loadHTMLString:loadingText baseURL:nil];
	[webView release];
}

-(void) addButtons {
	agreeButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	agreeButton.frame = CGRectMake(160, 320, 60, 30);
	[agreeButton setTitle:@"Accept" forState:UIControlStateNormal];
	[agreeButton addTarget:self action:@selector(agreeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:agreeButton];
	agreeButton.enabled = NO;
	
	UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	cancleButton.frame = CGRectMake(230, 320, 60, 30);
	[cancleButton setTitle:@"Decline" forState:UIControlStateNormal];
	[cancleButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:cancleButton];
}

-(void) createContents {	
	//self.view.backgroundColor = [UIColor clearColor];
	self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:.3];
	
	[self addTranslucentView];
	[self addImageView];
	[self addWebView];
	[self addButtons];
}

/*-(NSString *)filePath{
    
    NSURL *url = [NSURL URLWithString:@"http://safecellapp.mobi/api/1/site_setting/terms_of_service.html"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *tcFilePath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0],@"terms_of_service.html"];
    
    // Download and write to file
    
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    [urlData writeToFile:tcFilePath atomically:YES];
    return tcFilePath;

}*/
- (id) init {
	self = [super init];
	if (self != nil) {
		[self createContents];
      
	}
	return self;
}

-(void) agreeButtonTapped {
	self.userAcceptedPolicy = YES;
	[self hide];
}

-(void) cancelButtonTapped {
	self.userAcceptedPolicy = NO;
	[self hide];
}
#pragma mark -
#pragma mark Clean Up

- (void) dealloc {
	[agreeButton release];
	[super dealloc];
}

#pragma mark -
#pragma mark UIWebViewDelegate

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return false;
    }
    return true;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
	NSLog(@"webViewDidFinishLoad");
 /* COMMENTED BY SURJAN TO AVOID THE LICNSE ALERT*/
 if (loadTOS) {
     NSString *path;
     NSBundle *thisBundle = [NSBundle mainBundle];
     path = [thisBundle pathForResource:@"privacy-policy" ofType:@"html"];
     NSURL *instructionsURL = [NSURL fileURLWithPath:path];
     [webView loadRequest:[NSURLRequest requestWithURL:instructionsURL]];
    
    // [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[self filePath]]]];
    
     // IF YOU WANT TO LOAD THE DATA FROM THE SERVER UNCOMMENT THIS 
	/*	NSString *url = [NSString stringWithFormat:@"%@/site_setting/terms_of_service.html", [Config baseURL]];
		
		NSLog(@"TOS url : %@", url);
		
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
		[webView loadRequest:request];*/
		loadTOS = NO;
	} else {
		agreeButton.enabled = YES;
	}
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSLog(@"didFailLoadWithError");
    NSString *errorMsg = [NSString stringWithFormat:@"The \"Terms and Conditions\" page failed to load.Because %@. Please try again later.",[error description]];
	SimpleAlertOK(@"Page Failed to Load", errorMsg);
}

@end
