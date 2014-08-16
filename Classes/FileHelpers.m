/*
 *  FileHelpers.m
 *  Homepwner
 *
 *  Created by Thomas Bennett on 6/20/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include "FileHelpers.h"

NSString *pathInDocumentDirectory(NSString *fileName) {
	// Get list of document directories
	NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	// Get the one (and only one) document directory
	NSString *documentDirectory = [documentDirectories objectAtIndex:0];
	
	return [documentDirectory stringByAppendingPathComponent:fileName];
}