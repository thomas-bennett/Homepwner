    //
//  ItemViewController.m
//  Homepwner
//
//  Created by Thomas Bennett on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ItemsViewController.h"
#import "Possession.h"
#import "ItemDetailViewController.h"
#import "HomepwnerItemCell.h"

@implementation ItemsViewController
@synthesize possessions;

 -(id)init {
	 [super initWithStyle:UITableViewStyleGrouped];

	 // Update the nav items
	 [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
	 [[self navigationItem] setTitle:@"Homepwner"];
	 
	 return self;
 }

- (id)initWithStyle:(UITableViewStyle)style {
	return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int numOfRows = [possessions count];
	if ([self isEditing])
		numOfRows++;
	return numOfRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath row] >= [possessions count]) {
		// Check for a reusable cell first!
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
		
		// If no reusable cell, create a new one.
		if (!cell) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"] autorelease];
		}
		
		if ([indexPath row] < [possessions count]) {
			Possession *p = [possessions objectAtIndex:[indexPath row]];
			[[cell textLabel] setText:[p description]];
		} else {
			// Editing the additional row added for insertion.
			[[cell textLabel] setText:@"Add New Item..."];
		}
		return cell;
	}
	
	HomepwnerItemCell *cell = (HomepwnerItemCell *)[tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
	
	if (!cell) {
		cell = [[[HomepwnerItemCell alloc] initWithStyle:UITableViewCellStyleDefault 
										 reuseIdentifier:@"HomepwnerItemCell"] 
				autorelease];
	}
	
	Possession *p = [possessions objectAtIndex:[indexPath row]];
	[cell setPossession:p];
	return cell;
}

/* - (UIView *)headerView {
	if (headerView) {
		return headerView;	
	}
	
	UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[editButton setTitle:@"Edit" forState:UIControlStateNormal];
	
	// How wide is the screen?
	float w = [[UIScreen mainScreen] bounds].size.width;
	CGRect editButtonFrame = CGRectMake(8.0, 8.0, w - 16.0, 30.0);
	[editButton setFrame:editButtonFrame];
	
	[editButton addTarget:self action:@selector(editingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	CGRect headerViewFrame = CGRectMake(0, 0, w, 48);
	headerView = [[UIView alloc] initWithFrame:headerViewFrame];
	
	[headerView addSubview:editButton];
	
	return headerView;
} 
 
// Add header for the specified section in the table view.
- (UIView *)tableView:(UITableView *)tv viewForHeaderInSection:(NSInteger)sec {
	return [self headerView];
}

- (CGFloat)tableView:(UITableView *)tv heightForHeaderInSection:(NSInteger)sec {
	return [[self headerView] frame].size.height;
} 

- (void)editingButtonPressed:(id)sender {
	if ([self isEditing]) {
		[sender setTitle:@"Edit" forState:UIControlStateNormal];
		[self setEditing:NO animated:YES];
	} else {
		[sender setTitle:@"Done" forState:UIControlStateNormal];
		[self setEditing:YES animated:YES];
	}
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!detailViewController) {
		detailViewController = [ItemDetailViewController new];
	}
	detailViewController.editingPossession = [possessions objectAtIndex:[indexPath row]];
	[[self navigationController] pushViewController:detailViewController animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[possessions removeObjectAtIndex:[indexPath row]];
		 
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	} else if (editingStyle == UITableViewCellEditingStyleInsert) {
		if (!detailViewController) {
			detailViewController = [ItemDetailViewController new];
		}
		Possession *p = [Possession new];
		[possessions addObject:p];
		[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
		 						 withRowAnimation:UITableViewRowAnimationLeft];

		detailViewController.editingPossession = p;//[possessions objectAtIndex:[indexPath row]];
//		[possessions release];
		[[self navigationController] pushViewController:detailViewController animated:YES];
		
		
//		[possessions addObject:[Possession randomPossession]];
//		[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
//						 withRowAnimation:UITableViewRowAnimationLeft];
	}
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	Possession *p = [possessions objectAtIndex:[fromIndexPath row]];
	// We'll be deleting, so make sure to retain otherwise we'll dealloc.
	[p retain];
	
	[possessions removeObjectAtIndex:[fromIndexPath row]];
	
	[possessions insertObject:p atIndex:[toIndexPath row]];
	[p release];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath row] < [possessions count]) {
		return YES;
	}
	// Insert new item button
	return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)fromIndexPath 
	   toProposedIndexPath:(NSIndexPath *)toIndexPath {
	if ([toIndexPath row] < [possessions count]) {
		return toIndexPath;
	} 
	NSIndexPath *betterIndexPath = [NSIndexPath indexPathForRow:[possessions count] -1 inSection:0];
	return betterIndexPath;
}

- (void)setEditing:(BOOL)flag animated:(BOOL)animated {
	// super needs to do some work too
	[super setEditing:flag animated:animated];
	
	if (flag) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[possessions count] inSection:0];
		NSArray *paths = [NSArray arrayWithObject:indexPath];
		
		[[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];
	} else {
// Leaving editing mode - delete add button.
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[possessions count] inSection:0];
		NSArray *paths = [NSArray arrayWithObject:indexPath];
		
		[[self tableView] deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self isEditing] && [indexPath row] == [possessions count]) {
		return UITableViewCellEditingStyleInsert;
	}
	return UITableViewCellEditingStyleDelete;
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[self tableView] reloadData];
}

- (void)dealloc {
    [super dealloc];
}


@end
