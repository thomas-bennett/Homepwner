//
//  ItemViewController.h
//  Homepwner
//
//  Created by Thomas Bennett on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemDetailViewController;
@interface ItemsViewController : UITableViewController {
	NSMutableArray *possessions;
	ItemDetailViewController *detailViewController;
//	UIView *headerView;
}

@property (nonatomic, retain) NSMutableArray* possessions;
//- (UIView *)headerView;
@end
