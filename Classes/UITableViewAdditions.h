//
//  UITableViewAdditions.h
//  safecell
//
//  Created by Ben Scheirman on 9/20/10.
//  Copyright 2010 ChaiONE. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UITableView (Additions)

- (void)scrollToTop:(BOOL)animated;
- (void)scrollToBottom:(BOOL)animated;
- (void)scrollToFirstRow:(BOOL)animated;
- (void)scrollToLastRow:(BOOL)animated;

@end
