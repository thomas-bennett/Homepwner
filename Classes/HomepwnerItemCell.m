//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Thomas Bennett on 6/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HomepwnerItemCell.h"
#import "Possession.h"


@implementation HomepwnerItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[[self contentView] addSubview:valueLabel];
		[valueLabel release];
		
		nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[[self contentView] addSubview:nameLabel];
		[nameLabel release];
		
		imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[[self contentView] addSubview:imageView];
		[imageView release];
    }
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	float inset = 5.0;
	CGRect bounds = [[self contentView] bounds];
	float h = bounds.size.height;
	float w = bounds.size.width;
	float valueWidth = 40.0;
	
	CGRect innerFrame = CGRectMake(inset, inset, h, h - inset * 2.0);
	[imageView setFrame:innerFrame];
	
	innerFrame.origin.x += innerFrame.size.width + inset;
	innerFrame.size.width = w - (h + valueWidth + inset * 4);
	[nameLabel setFrame:innerFrame];
	
	innerFrame.origin.x += innerFrame.size.width + inset;
	innerFrame.size.width = valueWidth;
	[valueLabel setFrame:innerFrame];
}

- (void)setPossession:(Possession *)possession {
	valueLabel.text = [NSString stringWithFormat:@"$%d", possession.valueInDollars];
	[nameLabel setText:possession.possessionName];
	imageView.image = possession.thumbnail;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
