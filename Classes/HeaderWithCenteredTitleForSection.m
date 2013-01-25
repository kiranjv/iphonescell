//
//  CenteredHeaderForSection.m
//  safecell
//
//  Created by shail on 05/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HeaderWithCenteredTitleForSection.h"
#import "UIUtils.h"

@implementation HeaderWithCenteredTitleForSection


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		[self contentforHeaderView];
		self.backgroundColor = [UIUtils colorFromHexColor:@"9DB9D8"];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}

-(void)contentforHeaderView{	
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
	imageView.image = [UIImage imageNamed:@"section_header_back.png"];
	[self addSubview:imageView];
	[imageView release];
	
	
	headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 320, 20)];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.textAlignment = UITextAlignmentCenter;
	headerLabel.font = [UIFont boldSystemFontOfSize:13];
	headerLabel.shadowColor = [UIUtils colorFromHexColor:@"666666"];
	headerLabel.shadowOffset = CGSizeMake(0, 1);
	[self addSubview:headerLabel];
}

- (void)dealloc {
	[title release];
	[headerLabel release];
    [super dealloc];
}

-(NSString *) title {
	return title;
}

-(void) setTitle : (NSString *) titleValue {
	[title release];
	title = [titleValue retain];
	headerLabel.text = title;
}

@end
