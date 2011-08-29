//
//  DiffBrowser.m
//  Mach-O-scope
//
//  Created by Karsten Kusche on 27.08.11.
//  Copyright 2011 Briksoftware.com. All rights reserved.
//

#import "DiffBrowser.h"


@implementation DiffBrowser
@synthesize differences;


-(id)init
{
	self = [super initWithWindowNibName:@"DiffBrowser"];
	if (self)
	{
		
	}
	return self;
}

- (void)showDifference:(id)difference
{

}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return [self.differences count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	return [self.differences objectAtIndex: row];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification;
{
	NSUInteger index = [[tableView selectedRowIndexes] firstIndex];
	id difference = nil;
	if (index >= 0)
	{
		difference = [self.differences objectAtIndex: index];
	}
	[self showDifference: difference];
}

@end
