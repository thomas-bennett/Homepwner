//
//  HomepwnerAppDelegate.h
//  Homepwner
//
//  Created by Thomas Bennett on 6/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemsViewController;

@interface HomepwnerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	ItemsViewController *itemsViewController;
}
- (NSString *)possessionArrayPath;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@end

