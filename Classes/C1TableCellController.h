//
//  C1TableSectionController.h
//  safecell
//
//  Created by Ben Scheirman on 4/21/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol C1TableCellController

@required
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, assign) UIViewController *parentViewController;


@optional
-(NSString *)headerText;
-(NSString *)footerText;
-(UIView *)headerView;
-(UIView *)footerView;
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


@end