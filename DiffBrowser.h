//
//  DiffBrowser.h
//  Mach-O-scope
//
//  Created by Karsten Kusche on 27.08.11.
//  Copyright 2011 Briksoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DiffBrowser : NSWindowController <NSTableViewDataSource, NSTableViewDelegate> {
	IBOutlet NSTableView* tableView;
	IBOutlet NSView* diffView;
	NSArray* differences;
}

@property (retain) NSArray* differences;

@end
