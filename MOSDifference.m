//
//  ChangedMethod.m
//  Mach-O-scope
//
//  Created by Karsten Kusche on 27.08.11.
//  Copyright 2011 Briksoftware.com. All rights reserved.
//

#import "MOSDifference.h"
#import "MOSClass.h"

@implementation MOSDifference
@synthesize mclass;

- (NSString*)differenceKind
{
	return [self className];
}

- (NSString*)differenceDetail
{
	return self.mclass.className;
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"%@ - %@",[self differenceKind],[self differenceDetail]];
}

+ (id)difference
{
	MOSDifference* inst = [[self alloc] init];
	return [inst autorelease];
}

- (void)initWithObject:(id)object
{
	self.mclass = object;	
}

+ (NSArray*)differencesFromObjects:(NSArray*)objects
{
	NSMutableArray* differences = [NSMutableArray arrayWithCapacity:[objects count]];
	
	for (id object in objects)
	{
		MOSDifference* difference = [self difference];
		[difference initWithObject:object];
		[differences addObject:difference];
	}
	return differences;
}

@end
