//
//  HomepwnerAppDelegate.m
//  Homepwner
//
//  Created by Thomas Bennett on 6/6/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "HomepwnerAppDelegate.h"
#import "ItemsViewController.h"

@implementation HomepwnerAppDelegate

@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	NSString *possessionPath = [self possessionArrayPath];
	NSMutableArray *possessions = [NSKeyedUnarchiver unarchiveObjectWithFile:possessionPath];
	
	if (possessions) {
		possessions = [NSMutableArray array];
	}

	itemsViewController = [ItemsViewController new];
	[itemsViewController setPossessions:possessions];	
	
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:itemsViewController];
	[window addSubview:[navController view]];
	
    [window makeKeyAndVisible];
	
	return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	NSString *possessionPath = [self possessionArrayPath];
	NSMutableArray *possessions = [itemsViewController possessions];
	[NSKeyedArchiver archiveRootObject:possessions toFile:possessionPath];
}

- (NSString *)possessionArrayPath {
	return pathInDocumentDirectory(@"Possessions.data");
}

- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
