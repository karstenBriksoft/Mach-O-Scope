//
//  Difference.m
//  Mach-O-scope
//
//  Created by Karsten Kusche on 26.08.11.
//  Copyright 2011 Briksoftware.com. All rights reserved.
//

#import "MOSCollectionDifference.h"


@implementation MOSCollectionDifference

@synthesize newObjects, deletedObjects, modifiedObjects;

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.newObjects = [NSMutableArray array];
		self.deletedObjects = [NSMutableArray array];
		self.modifiedObjects = [NSMutableArray array];
	}
	return self;
}

- (void) dealloc
{
	self.newObjects = nil;
	self.deletedObjects = nil;
	self.modifiedObjects = nil;
	[super dealloc];
}

+ (id)differenceForLeft:(NSArray*)leftObjects right:(NSArray*)rightObjects
{
	MOSCollectionDifference* difference = [[self alloc] init];
	for (id object in leftObjects)
	{
		if ([rightObjects containsObject:object])
		{
			[difference.modifiedObjects addObject:object];
		}
		else
		{
			[difference.deletedObjects addObject:object];
		}
	}
	for (id object in rightObjects)
	{
		if (! [leftObjects containsObject: object])
		{
			[difference.newObjects addObject:object];
		}
	}
	return [difference autorelease];
}

@end
