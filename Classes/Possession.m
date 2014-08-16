//
//  Possession.m
//  RandomPossessions
//
//  Created by Thomas Bennett on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Possession.h"


@implementation Possession
@synthesize possessionName, serialNumber, valueInDollars, dateCreated, imageKey;

+ (id)randomPossession {
	static NSString *randomAdjectiveList[3] = {
		@"Fluffy", @"Shiny", @"Rusty"
	};
	static NSString *randomNounList[3] = {
		@"Bear", @"Spork", @"Mac"
	};
	
	NSString *randomName = [NSString stringWithFormat:@"%@ %@", randomAdjectiveList[random() % 3], randomNounList[random() % 3]];
	
	int randomValue = random() % 100;
	NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c", 
									'0' + random() % 10,
									'A' + random() % 26,
									'0' + random() % 10,
									'A' + random() % 26,
									'0' + random() % 10];
	
	Possession *possession = [[self alloc] initWithPossessionName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
	return [possession autorelease];
}

- (NSString *) description {
	return [NSString stringWithFormat:@"%@ (%@): Worth $%d, Recorded on %@",
								   possessionName,
								   serialNumber,
								   valueInDollars,
								   dateCreated];
}

- (id)initWithPossessionName:(NSString *)pName valueInDollars:(int)value serialNumber:(NSString *)sNumber {
	[super init];
	
	if (!self)
		return nil;
	
	[self setPossessionName:pName];
	[self setValueInDollars:value];
	[self setSerialNumber:sNumber];
	dateCreated = [NSDate new];
	
	return self;
}

- (id)initWithPossessionName:(NSString *) pName {
	return [self initWithPossessionName:pName valueInDollars:0 serialNumber:@""];
}

- (id)init {
	return [self initWithPossessionName:@"Possession" valueInDollars:0 serialNumber:@""];
}

- (void)dealloc {
	[possessionName release];
	[serialNumber release];
	[dateCreated release];
	[imageKey release];
	[thumbnail realease];
	[thumbnailData release];
	
	[super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:possessionName forKey:@"possessionName"];
	[encoder encodeObject:serialNumber forKey:@"serialNumber"];
	[encoder encodeInt:valueInDollars forKey:@"valueInDollars"];
	[encoder encodeObject:dateCreated forKey:@"dateCreated"];
	[encoder encodeObject:imageKey forKey:@"imageKey"];
	[encoder encodeObject:thumbnailData forKey:@"thumbnailData"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	[super init];
	
	self.possessionName = [decoder decodeObjectForKey:@"possessionName"];
	self.valueInDollars = [decoder decodeIntForKey:@"valueInDollars"];
	self.serialNumber = [decoder decodeObjectForKey:@"serialNumber"];
	self.imageKey = [decoder decodeObjectForKey:@"imageKey"];
	
	// No setter exists for date, so explictly set it and retain it.
	dateCreated = [[decoder decodeObjectForKey:@"dateCreated"] retain];
	thumbnailData = [[decoder decodeObjectForKey:@"thumbnailData"] retain];
	return self;
}

- (UIImage *)thumbnail {
	if (!thumbnailData) {
		return nil;
	}
	
	if (!thumbnail) {
		thumbnail = [[UIImage imageWithData:thumbnailData] retain];
	}
	
	return thumbnail;
}

- (void)setThumbnailDataFromImage:(UIImage *)image {
	[thumbnailData release];
	[thumbnail release];
	
	CGRect imageRect = CGRectMake(0, 0, 70, 70);
	UIGraphicsBeginImageContext(imageRect.size);
	
	[image drawInRect:imageRect];
	thumbnail = UIGraphicsGetImageFromCurrentImageContext();
	[thumbnail retain];
	
	UIGraphicsEndImageContext();
	
	thumbnailData = UIImageJPEGRepresentation(thumbnail, 0.5);
	[thumbnailData retain];
}
@end
