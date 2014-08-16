//
//  ItemDetailViewController.h
//  Homepwner
//
//  Created by Thomas Bennett on 6/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Possession;
@interface ItemDetailViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	IBOutlet UITextField *nameField;
	IBOutlet UITextField *serialNumberField;
	IBOutlet UITextField *valueField;
	IBOutlet UILabel *dateLabel;
	IBOutlet UIImageView *imageView;
	
	Possession *editingPossession;
}

@property (nonatomic, assign) Possession *editingPossession;
@end
