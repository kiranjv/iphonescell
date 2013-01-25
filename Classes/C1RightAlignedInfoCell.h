//
//  C1RightAlignedInfoCell.h
//  safecell
//
//  Created by shail on 08/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface C1RightAlignedInfoCell : C1TableCell {
	NSString *label;
	NSString *info;
	
	BOOL cellSelectionAllowed;
	BOOL showDiscloserIndicator;
}

@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, assign) BOOL cellSelectionAllowed;
@property (nonatomic, assign) BOOL showDiscloserIndicator;

- (id) initWithLabel:(NSString *) labelStr info: (NSString *) infoStr;

@end
