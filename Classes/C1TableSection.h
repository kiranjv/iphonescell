//
//  C1TableSection.h
//  safecell
//
//  Created by Ben Scheirman on 4/21/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "C1TableCellController.h"

@interface C1TableSection : NSObject {
	NSString *_headerText;
	NSString *_footerText;
	NSMutableArray *_rows;
	UITableView *_tableView;
	NSInteger _sectionIndex;
	
	UIView *_headerView;
	UIView *_footerView;
	UIViewController *_parentViewController;
}

@property (nonatomic, readonly) NSMutableArray *rows;
@property (nonatomic, copy) NSString *headerText;
@property (nonatomic, copy) NSString *footerText;
@property (nonatomic, assign) UITableView *tableView;
@property (nonatomic) NSInteger sectionIndex;

@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIView *footerView;

@property (nonatomic, assign) UIViewController *parentViewController;

-(id) initWithoutSetup;
-(void)reloadData;
-(void)setupSection;
-(BOOL)validateSection;
-(void)dynamicAddRow:(id<C1TableCellController>)row;
-(void)dynamicRemoveRowAtIndex:(NSInteger)rowIndex;

@end
