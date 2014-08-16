//
//  Possession.h
//  RandomPossessions
//
//  Created by Thomas Bennett on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Possession : NSObject <NSCoding> {
	NSString *possessionName;
	NSString *serialNumber;
	int valueInDollars;
	NSDate *dateCreated;
	NSString *imageKey;
	
	UIImage *thumbnail;
	NSData *thumbnailData;
}
@property (nonatomic, copy) NSString *possessionName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly) NSDate *dateCreated;
@property (nonatomic, copy) NSString *imageKey;
@property (nonatomic, retain) UIImage *thumbnail;

+ (id)randomPossession;

- (id)initWithPossessionName:(NSString *)pName
			  valueInDollars:(int)value	
				serialNumber:(NSString *)sNumber;
- (id)initWithPossessionName:(NSString *)pName;
- (void)setThumbnailDataFromImage:(UIImage *)image;
@end
