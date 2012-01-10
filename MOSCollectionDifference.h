//
//  Difference.h
//  Mach-O-scope
//
//  Created by Karsten Kusche on 26.08.11.
//  Copyright 2011 Briksoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MOSCollectionDifference : NSObject {
	NSMutableArray* newObjects;
	NSMutableArray* deletedObjects;
	NSMutableArray* modifiedObjects;
}

@property (retain) NSMutableArray* newObjects;
@property (retain) NSMutableArray* deletedObjects;
@property (retain) NSMutableArray* modifiedObjects;

+ (id)differenceForLeft:(NSArray*)leftObjects right:(NSArray*)rightObjects;

@end
