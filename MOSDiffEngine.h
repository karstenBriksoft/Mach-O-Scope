//
//  DiffEngine.h
//  Mach-O-scope
//
//  Created by Karsten Kusche on 26.08.11.
//  Copyright 2011 Briksoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MOSDatabase.h"

@interface MOSDiffEngine : NSObject {
	MOSDatabase* left;
	MOSDatabase* right;
}

@property (retain) MOSDatabase* left;
@property (retain) MOSDatabase* right;
- (id) initWithLeftFile:(NSString*)leftPath rightFile:(NSString*)rightPath;
- (NSArray*)differences;


@end
