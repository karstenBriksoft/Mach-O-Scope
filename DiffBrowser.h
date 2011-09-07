//
//  DiffBrowser.h
//  Mach-O-scope
//
//  Created by Karsten Kusche on 27.08.11.
//  Copyright 2011 Briksoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface DiffBrowser : NSWindowController <NSTableViewDataSource, NSTableViewDelegate> {
	IBOutlet NSTableView* tableView;
	IBOutlet WebView* diffView;
	NSArray* differences;
}

@property (retain) NSArray* differences;

@end
