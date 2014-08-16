//
//  ItemDetailViewController.m
//  Homepwner
//
//  Created by Thomas Bennett on 6/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "Possession.h"
#import "ImageCache.h"

@implementation ItemDetailViewController
@synthesize editingPossession;

- (id)init {
	[super initWithNibName:@"ItemDetailViewController" bundle:nil];
	
	UIBarButtonItem *cameraBarButtonItem = [[UIBarButtonItem alloc] 
											initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
											target:self 
											action:@selector(takePicture:)];
	[[self navigationItem] setRightBarButtonItem:cameraBarButtonItem];
	// cameraCarButtonItem is retained by the nav item. 
	[cameraBarButtonItem release];
	return self;
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[nameField setText:[editingPossession possessionName]];
	[serialNumberField setText:[editingPossession serialNumber]];
	[valueField setText:[NSString stringWithFormat:@"%d", [editingPossession valueInDollars]]];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter new] autorelease];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	[dateLabel setText:[dateFormatter stringFromDate:[editingPossession dateCreated]]];
	
	NSString *imageKey = editingPossession.imageKey;
	if (imageKey) {
		UIImage *imageToDisplay = [[ImageCache sharedImageCache] imageForKey:imageKey];
		[imageView setImage:imageToDisplay];
	} else {
		// Clear the view since no image exists for this possession
		[imageView setImage:nil];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	// Clear first responder?
	[nameField resignFirstResponder];
	[valueField resignFirstResponder];
	[serialNumberField resignFirstResponder];
	
	// "Save" changes to editing possession.
	editingPossession.valueInDollars = [[valueField text] intValue];
	editingPossession.possessionName = [nameField text];
	editingPossession.serialNumber = [serialNumberField text];
}

- (void)takePicture:(id)sender {
	// Remove keyboard
	[[self view] endEditing:YES];
	
	UIImagePickerController *imagePicker = [UIImagePickerController new];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
	} else {
		[imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
	}
	
	[imagePicker setDelegate:self];
	[self presentModalViewController:imagePicker animated:YES];
	// retained until it has been dismissed.
	[imagePicker release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	NSString *oldKey = [editingPossession imageKey];
	if (oldKey) {
		// Delete the old image
		[[ImageCache sharedImageCache] deleteImageForKey:oldKey];
	}
	
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
	
	CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
	CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
	
	[editingPossession setImageKey:(NSString *)newUniqueIDString];
	
	// Create was using when constructing ids, need to release.
	CFRelease(newUniqueID);
	CFRelease(newUniqueIDString);
	
	[[ImageCache sharedImageCache] setImage:image forKey:[editingPossession imageKey]];
	
	[imageView setImage:image];
	[editingPossession setThumbnailDataFromImage:image];
	
	[self dismissModalViewControllerAnimated:YES];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	[nameField release];
	nameField = nil;
	
	[valueField release];
	valueField = nil;
	
	[dateLabel release];
	dateLabel = nil;
	
	[serialNumberField release];
	serialNumberField = nil;
	
	[imageView release];
	imageView = nil;
}

- (void)dealloc {	
	[nameField release];
	[serialNumberField release];
	[valueField release];
	[dateLabel release];
	[imageView release];
	
	[super dealloc];
}


@end
