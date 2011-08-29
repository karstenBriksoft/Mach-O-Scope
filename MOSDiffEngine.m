//
//  DiffEngine.m
//  Mach-O-scope
//
//  Created by Karsten Kusche on 26.08.11.
//  Copyright 2011 Briksoftware.com. All rights reserved.
//

#import "MOSDiffEngine.h"
#import "MOSCollectionDifference.h"
#import "MOSClass.h"
#import "MOSMethod.h"
#import "MOSOperation.h"
#import "MOSNewClass.h"
#import "MOSDeletedClass.h"
#import "MOSNewMethod.h"
#import "MOSDeletedMethod.h"
#import "MOSChangedMethod.h"

@implementation MOSDiffEngine
@synthesize left,right;

- (id) initWithLeftFile:(NSString*)leftPath rightFile:(NSString*)rightPath
{
	self = [super init];
	if (self != nil) {
		left = [[MOSDatabase alloc] initWithPath:leftPath andDelegate:nil];
		right = [[MOSDatabase alloc] initWithPath:rightPath andDelegate:nil];
	}
	return self;
}

- (void) dealloc
{
	self.left = nil;
	self.right = nil;
	[super dealloc];
}

- (NSDictionary*)dictionaryFromClasses:(NSArray*)classes
{
	NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
	for (MOSClass* class in classes)
	{
		[dictionary setObject:class forKey:class.className];
	}
	return dictionary;
}

- (NSArray*)differences
{
	NSMutableArray* differences = [NSMutableArray array];
	
	NSDictionary* leftClasses = [self dictionaryFromClasses:[MOSClass classesForDatabase:self.left]];
	NSDictionary* rightClasses = [self dictionaryFromClasses:[MOSClass classesForDatabase: self.right]];
	
	MOSCollectionDifference* classDifference = [MOSCollectionDifference differenceForLeft: [leftClasses allValues] right: [rightClasses allValues]];
	
	[differences addObjectsFromArray:[MOSNewClass differencesFromObjects:classDifference.newObjects]];
	[differences addObjectsFromArray:[MOSDeletedClass differencesFromObjects:classDifference.deletedObjects]];

	for (MOSClass* class in classDifference.modifiedObjects)
	{
		MOSClass* leftClass = [leftClasses objectForKey:class.className];
		MOSClass* rightClass = [rightClasses objectForKey:class.className];
		
		MOSCollectionDifference* methodDifference = [MOSCollectionDifference differenceForLeft:[leftClass methods] right:[rightClass methods]];
		[differences addObjectsFromArray:[MOSNewMethod differencesFromObjects:methodDifference.newObjects]];
		[differences addObjectsFromArray:[MOSDeletedMethod differencesFromObjects:methodDifference.deletedObjects]];
	}
	NSLog(@"differences: %@",differences);
	return differences;
}
							   
@end
