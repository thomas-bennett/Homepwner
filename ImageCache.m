//
//  ImageCache.m
//  Homepwner
//
//  Created by Thomas Bennett on 6/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ImageCache.h"

// Making this a singleton.
static ImageCache *sharedImageCache;

@implementation ImageCache

- (id)init {
	[super init];
	
	dictionary = [NSMutableDictionary new];
	
	// Register to receive low memory warnings.
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self 
		   selector:@selector(clearCache:) 
			   name:UIApplicationDidReceiveMemoryWarningNotification 
			 object:nil];
	
	return self;
}

#pragma mark Accessing the cache
- (void)setImage:(UIImage *)image forKey:(NSString *)key {
	[dictionary setObject:image forKey:key];
	
	NSString *imagePath = pathInDocumentDirectory(key);
	NSData *d = UIImageJPEGRepresentation(image, 0.5);
	[d writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)key {
	// Go to the dictionary first
	UIImage *image = [dictionary objectForKey:key];
	
	if (!image) {
		image = [UIImage imageWithContentsOfFile:pathInDocumentDirectory(key)];
		
		if (image) {
			// Place in dictionary
			[dictionary setObject:image forKey:key];
		} else {
			NSLog(@"Error: Unable to find %@", pathInDocumentDirectory(key));
		}
	}
	
	return image;
	
}

- (void)deleteImageForKey:(NSString *)key {
	[dictionary removeObjectForKey:key];
	
	// Delete from file system.
	NSString *imagePath = pathInDocumentDirectory(key);
	[[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
}

#pragma mark Singleton stuff
+ (ImageCache *)sharedImageCache {
	if (!sharedImageCache) {
		sharedImageCache = [ImageCache new];
	}
	return sharedImageCache;
}

+ (id)allocWithZone:(NSZone *)zone {
	if (!sharedImageCache) {
		sharedImageCache = [ImageCache new];
		return sharedImageCache;
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (void)release {
	// Noop.
}

- (void)clearCache:(NSNotification *)note {
	NSLog(@"Flushing %d images out of the cache", [dictionary count]);
	[dictionary removeAllObjects];
}

- (void)dealloc {
	// Should never be called, but implementing for practice.
	[dictionary release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	 [super dealloc];
}
@end
