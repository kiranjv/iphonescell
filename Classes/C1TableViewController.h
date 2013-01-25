//
//  C1TableViewController.h
//  safecell
//
//  Created by Ben Scheirman on 4/21/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol C1TableCellController;
@class C1TableSection;

@interface C1TableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableViewStyle _style;
	UITableView *_tableView;
	NSMutableArray *_sections;
	UIButton *doneButton;
	BOOL doneButtonVisible;
	BOOL keyboardVisible;
	
	BOOL reactToKeyboard;
	BOOL tabBarPresent;
}

@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, assign) BOOL reactToKeyboard;
@property (nonatomic, assign) UITableViewStyle style;
@property (nonatomic, assign) BOOL tabBarPresent;


-(id)initWithStyle:(UITableViewStyle)style;
-(void)addSection:(C1TableSection *)section;
-(NSArray *)sections;
-(void)onNumberPadDoneButton:(id)sender;
-(void)adjustNumberPad;
-(void)keyboardShown;
-(void) removeDoneButton;

@end
