//
//  C1TableViewController.m
//  safecell
//
//  Created by Ben Scheirman on 4/21/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import "C1TableViewController.h"
#import "C1TableCellController.h"
#import "C1TableSection.h"
#import "RectHelper.h"
#import "AppDelegate.h"
#import "UIViewAdditions.h"

const CGFloat KEYBOARD_HEIGHT = 216;
const CGFloat TAB_BAR_HEIGHT = 49;
const float KEYBOARD_ANIMATION_DURATION = 0.3;
const int DONE_BUTTON_TAG = 68412;

@implementation C1TableViewController

@synthesize tableView = _tableView, style = _style;
@synthesize reactToKeyboard;
@synthesize tabBarPresent;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super init])) {
		_style = style;
		reactToKeyboard = YES;
		tabBarPresent = NO;
    }
    return self;
}

#pragma mark -
#pragma mark Section management

-(NSArray *)sections {
	return _sections;
}

-(void)addSection:(C1TableSection *)section {
	if(!_sections)
		_sections = [[NSMutableArray alloc] init];

	section.sectionIndex = [_sections count];
	[_sections addObject:section];
}

#pragma mark -
#pragma mark View lifecycle

- (void)createCustomDoneButton {
	NSLog(@"Creating the button instance...");
	doneButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	doneButton.frame = CGRectMake(0, 163, 106, 53);
	doneButton.adjustsImageWhenHighlighted = NO;
	doneButton.tag = DONE_BUTTON_TAG;
	[doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
	[doneButton setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];
    
	[doneButton addTarget:self action:@selector(onNumberPadDoneButton:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)loadView {
	[super loadView];
	
	//background
	UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
	[self.view addSubview:backgroundView];
	[backgroundView release];
	
	[self createCustomDoneButton];
	
	self.view.autoresizesSubviews = YES;
	
	CGRect tableFrame = self.view.bounds;
//	if(self.navigationController) {
//		tableFrame.size.height -= self.navigationController.navigationBar.frame.size.height;
//	}
//	
//	if(self.tabBarController) {
//		tableFrame.size.height -= self.tabBarController.tabBar.frame.size.height;
//	}
	
	_tableView = [[UITableView alloc] initWithFrame:tableFrame style:_style];
	_tableView.backgroundColor = [UIColor clearColor];
		
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	
	//set the tableview/parentViewController properties of each of the sections
	for(C1TableSection *section in _sections)
	{
		section.parentViewController = self;
		section.tableView = _tableView;
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardDidAppear:withBounds:)
												 name:UIKeyboardDidShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillDisappear:withBounds:)
												 name:UIKeyboardDidHideNotification object:nil];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark keyboard handling

- (UIView *)findFirstResponder {
	AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	
	UIView* firstResponder = [appDelegate.window findFirstResponder];
	return firstResponder;
}

- (void)onNumberPadDoneButton:(id)sender {
	UIView *senderView = (UIView *)sender;
	NSLog(@"Done tapped: %@, tag: %d", sender, senderView.tag);
	[[self findFirstResponder] resignFirstResponder];
}



-(UIView *) findKeyboardView {
	UIView *keyboard = nil;
	if ([[[UIApplication sharedApplication] windows] count] > 1) {
		
		NSArray *currentWindows = [[UIApplication sharedApplication] windows];
		int windowCount = [currentWindows count];
		UIWindow* tempWindow = [currentWindows objectAtIndex:(windowCount - 1)];
		
		UIView *tempView;
		for(int i=0; i<[tempWindow.subviews count]; i++) {
			tempView = [tempWindow.subviews objectAtIndex:i];
			
			if ([[tempView description] hasPrefix:@"<UIPeripheralHostView"]) {
				keyboard = [[tempView subviews] objectAtIndex:0];
			} 
			
			// keyboard view found; add the custom button to it
			if([[tempView  description] hasPrefix:@"<UIKeyboard"] == YES) {
				keyboard = tempView;
			}
		}
	}
	return keyboard;
}

-(UIView *) findDoneButtonInKeyboard {
	UIView *keyboard = [self findKeyboardView];
	UIView *doneButtonView = nil;
	UIView *tempView;
	if (keyboard != nil) {
		for(int i=0; i<[keyboard.subviews count]; i++) {
			tempView = [keyboard.subviews objectAtIndex:i];
			if (tempView.tag == DONE_BUTTON_TAG) {
				doneButtonView = tempView;
			}
		}
	}
	
	return doneButtonView;
}


-(void)forceNumberpadDoneButton {
	UIView *keyboard = [self findKeyboardView];
	if (!doneButtonVisible) {
		NSLog(@"Adding done button : ios4");
		[keyboard addSubview:doneButton];
		doneButtonVisible = YES;
	}
	/*
	// locate keyboard view
	UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView *keyboard;
	for(int i=0; i<[tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
		
		if ([[keyboard description] hasPrefix:@"<UIPeripheralHostView"]) {
			keyboard = [[keyboard subviews] objectAtIndex:0];
			if (!doneButtonVisible) {
				NSLog(@"Adding done button : ios4");
				[keyboard addSubview:doneButton];
				doneButtonVisible = YES;
			}
			
		} 
		
		// keyboard view found; add the custom button to it
		if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES) {
			NSLog(@"Keyboard height: %.1f", keyboard.frame.size.height);
			
			if (!doneButtonVisible) {
				NSLog(@"Adding done button");
				[keyboard addSubview:doneButton];
				doneButtonVisible = YES;
			}
		}
	}
	*/
}


-(void)scrollFirstResponderIntoView {
	UIView *firstResponder = [self findFirstResponder];
	
	
	CGRect responderRect = [self.view.window convertRect:firstResponder.frame fromView:firstResponder];
	
	
	CGRect innerViewableRect = CGRectInset(self.tableView.frame, 0, 20);
	LogRect(@"innerViewableRect", innerViewableRect);
	
	float keyboardY = 480 - KEYBOARD_HEIGHT;
	
	if((responderRect.origin.y + responderRect.size.height) > keyboardY) {
		[UIView beginAnimations:@"scroll table" context:nil];
		
		CGFloat responderCenterY = responderRect.origin.y + (responderRect.size.height / 2);
		
		//a negative value should cause a positive shift in offset
		CGFloat distanceFromCenterPoint =   responderCenterY - self.tableView.centerY;
		NSLog(@"Distance From Center: %.1f", distanceFromCenterPoint);
		
		CGFloat amountToScroll = distanceFromCenterPoint;
		if(distanceFromCenterPoint > self.tableView.contentSize.height)
			amountToScroll = self.tableView.contentSize.height;
		
		NSLog(@"Scrolling to (%.1f)", amountToScroll);
		self.tableView.contentOffset = CGPointMake(0, amountToScroll);
		
		[UIView commitAnimations];
	}	
}

/*
-(void)scrollFirstResponderIntoView {
	UIView *firstResponder = [self findFirstResponder];
	
	
	CGRect responderRect = [self.view.window convertRect:firstResponder.frame fromView:firstResponder];
	
	
	CGRect innerViewableRect = CGRectInset(self.tableView.frame, 0, 20);
	LogRect(@"innerViewableRect", innerViewableRect);
	
	if(!CGRectIntersectsRect(innerViewableRect, responderRect)) {
		[UIView beginAnimations:@"scroll table" context:nil];
		
		CGFloat responderCenterY = responderRect.origin.y + (responderRect.size.height / 2);
		
		//a negative value should cause a positive shift in offset
		CGFloat distanceFromCenterPoint =   responderCenterY - self.tableView.centerY;
		NSLog(@"Distance From Center: %.1f", distanceFromCenterPoint);

		CGFloat amountToScroll = distanceFromCenterPoint;
		if(distanceFromCenterPoint > self.tableView.contentSize.height)
			amountToScroll = self.tableView.contentSize.height;
		
		NSLog(@"Scrolling to (%.1f)", amountToScroll);
		self.tableView.contentOffset = CGPointMake(0, amountToScroll);
		
		[UIView commitAnimations];
	}
}
*/

-(BOOL) isNumberPad {
	BOOL isNumberPad = NO;
	UIView *firstResponder = [self findFirstResponder];
	if([firstResponder isKindOfClass:[UITextField class]]) {
		UITextField *currentTextField = (UITextField *)firstResponder;
		if(currentTextField.keyboardType == UIKeyboardTypePhonePad) {
			isNumberPad = YES;
		}	
	}
	
	return isNumberPad;
}

-(void) adjustNumberPad {
	BOOL isNumberPad = [self isNumberPad];

	if (isNumberPad) {
		[self forceNumberpadDoneButton];
	}
	
	if (!isNumberPad && doneButtonVisible) {
		NSLog(@"Removing done button");
		[doneButton removeFromSuperview];
		doneButtonVisible = NO;
	}
	
	//BruteForce: If it's not number pad we try to remove the done button.
#ifdef __IPHONE_4_0
	if (![self isNumberPad]) {
		[self performSelector:@selector(removeDoneButton) withObject:nil afterDelay:0.1];
	}
#endif

}

-(void) keyboardShown {
	if(reactToKeyboard) {		
		
		[self scrollFirstResponderIntoView];
		
		if(keyboardVisible)
			return;	
		
		keyboardVisible = YES;
		
		
		[UIView beginAnimations:@"autosize table" context:nil];
		
		CGRect tableRect = self.tableView.frame;
		
		if (self.tabBarPresent) {			
			tableRect.size.height -= (KEYBOARD_HEIGHT - TAB_BAR_HEIGHT);
		} else {
			tableRect.size.height -= KEYBOARD_HEIGHT;
		}
		
		self.tableView.frame = tableRect;
		
		[UIView commitAnimations];
	}
}


-(void) removeDoneButton {
	UIView *doneButtonView = [self findDoneButtonInKeyboard];
	NSLog(@"removeDoneButton - doneButton: %@, doneButtonSuperView: %@", doneButtonView, doneButtonView.superview);
	[doneButtonView removeFromSuperview];
	/*
	if (doneButton) {
		NSLog(@"removeDoneButton");
		NSLog(@"done button (%@) superview: %@", doneButton, doneButton.superview);
		[doneButton removeFromSuperview];
		doneButtonVisible = NO;
	}
	 */
}

-(void)keyboardWillShow:(id)sender {
	NSLog(@"keyboardWillShow:");
	
	if(reactToKeyboard) {
		// We must perform on delay (schedules on next run loop pass) for the keyboard subviews to be present.
		[self performSelector:@selector(adjustNumberPad) withObject:nil afterDelay:0.1]; 
		
	}
	
	//BruteForce: If it's not number pad we try to remove the done button.
#ifdef __IPHONE_4_0
	if (![self isNumberPad]) {
		[self performSelector:@selector(removeDoneButton) withObject:nil afterDelay:0.1];
	}
#endif
	
}


-(void)keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds {
	
	NSLog(@"keyboardDidAppear:");
	
	[self keyboardShown];
	
	
}

-(void)keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds {		
	
	if(reactToKeyboard) {
		
		keyboardVisible = NO;	
		CGRect viewFrame = self.view.frame;
		
		if (self.tabBarPresent) {			
			viewFrame.size.height += (KEYBOARD_HEIGHT - TAB_BAR_HEIGHT);
		} else {
			viewFrame.size.height += KEYBOARD_HEIGHT;
		}
		
		self.view.frame = viewFrame;
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if(!_sections)
		return 0;
	
   return [_sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)i {
	C1TableSection *section = [_sections objectAtIndex:i];
	
	return section.rows.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	C1TableSection *section = [_sections objectAtIndex:indexPath.section];
	id<C1TableCellController> cellController = [section.rows objectAtIndex:indexPath.row];
	
	return [cellController tableView:self.tableView cellForRowAtIndexPath:indexPath];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)i {

	C1TableSection *section = [_sections objectAtIndex:i];
	return section.headerText;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)i {
	
	C1TableSection *section = [_sections objectAtIndex:i];
	return section.footerText;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)i {
	C1TableSection *section = [_sections objectAtIndex:i];
	return section.headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)i {
	C1TableSection *section = [_sections objectAtIndex:i];
	return section.footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)i {
	C1TableSection *section = [_sections objectAtIndex:i];
	if(section.headerView != nil) {
		return section.headerView.frame.size.height;
	}
	
	return -1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)i {
	C1TableSection *section = [_sections objectAtIndex:i];
	if(section.footerView != nil) {
		return section.footerView.frame.size.height;
	}
	
	return -1;
}

#pragma mark -
#pragma mark tableView delegate methods

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	C1TableSection *section = [_sections objectAtIndex:indexPath.section];	
	NSObject<C1TableCellController> *controller = [section.rows objectAtIndex:indexPath.row];
	
	if([controller respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
		[controller tableView:self.tableView didSelectRowAtIndexPath:indexPath];
	} else {
		NSLog(@"Cell Controller [%@] didn't respond to row selection.", [controller class]);
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[doneButton release];
	[_sections release];
	[_tableView release];
	[super dealloc];
}


@end

