//
//  AlertPrompt.m
//  Prompt
//
//  Created by Jeff LaMarche on 2/26/09.
//
//
//  http://iphonedevelopment.blogspot.com/2009/02/alert-view-with-prompt.html
//  Modified by Pritam Barhate on 05/13/2010 to accomodate bounce animations and 
//  some layouting improvements. 


#import "AlertPrompt.h"

@implementation AlertPrompt
@synthesize textField;
@synthesize enteredText;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{	
    if (self = [super initWithTitle:title message:@"Any Text" delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil])
    {
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 47.0, 260.0, 23.0)]; 
        [theTextField setBackgroundColor:[UIColor whiteColor]]; 
		theTextField.text = message;
		[self addSubview:theTextField];
        self.textField = theTextField;
        [theTextField release];
		
		CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 100); 
        [self setTransform:translate];		
    }
    return self;
}

- (void)show
{
	[super show];
	[self performSelector:@selector(showKeyboard) withObject:self afterDelay:0.5];
}

- (NSString *)enteredText
{
    return textField.text;
}

- (void)dealloc
{
    [textField release];
    [super dealloc];
}

-(void) showKeyboard {
	[textField becomeFirstResponder];
}

@end
