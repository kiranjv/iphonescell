//
//  FaxUIViewController.m
//  safecell
//
//  Created by surjan singh on 1/24/13.
//
//

#import "FaxUIViewController.h"
#import "AppDelegate.h"
@interface FaxUIViewController ()

@end

@implementation FaxUIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) loadWebViewField {
    
    UIWebView *aWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 350)];
    //init and   create the UIWebView
    
    aWebView.autoresizesSubviews = YES;
    aWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    [aWebView setDelegate:self];
    NSString *urlAddress = @"http://www.safecellapp.mobi/api/1/site_setting/terms_of_service.html"; // test view is working with url to webpage
    
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [aWebView loadRequest:requestObj];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 350)];
    [[self view] addSubview:aWebView];
}

-(void) viewWillAppear:(BOOL)animated {
    
    NSLog(@"Fax view will appear");
    CGRect textViewFrame = CGRectMake(0, 0, 320, 350);
    
    //CGRect textViewFrame = CGRectMake(20.0f, 20.0f, 280.0f, 124.0f);
    UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
    [textView setEditable:NO];
    textView.text = @"";
    textView.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:textView];
    [self setUpNavigationBar];
    //[self loadFaxData];
    
    //[self loadWebViewField];
        
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setUpNavigationBar {
    
	DecorateNavBar(self);
   // DecorateNavBarWithLogo(self);
	self.navigationItem.title = @"FAQ";
	
}

-(void) loadFaxData {
    NSString *path;
    NSBundle *thisBundle = [NSBundle mainBundle];
    path = [thisBundle pathForResource:@"privacy-policy" ofType:@"html"];
    NSURL *instructionsURL = [NSURL fileURLWithPath:path];
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:instructionsURL];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    
    NSData *receivedData = [NSURLConnection  sendSynchronousRequest:urlReq
                                                  returningResponse:&response error:&error];
    NSString* newStr = [[[NSString alloc] initWithData:receivedData
                                              encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"receivedData = %@",newStr);
    
    
    
    CGRect textViewFrame = CGRectMake(0, 0, 320, 350);
    
    //CGRect textViewFrame = CGRectMake(20.0f, 20.0f, 280.0f, 124.0f);
    UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
    [textView setEditable:NO];
    textView.text = newStr;
    textView.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:textView];
    
    

}

@end
