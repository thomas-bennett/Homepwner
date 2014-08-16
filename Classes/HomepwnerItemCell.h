//
//  HomepwnerItemCell.h
//  Homepwner
//
//  Created by Thomas Bennett on 6/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Possession;
@interface HomepwnerItemCell : UITableViewCell {
	UILabel *valueLabel;
	UILabel *nameLabel;
	UIImageView *imageView;
}
- (void)setPossession:(Possession *)possession;
@end
