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

- (id) init
{
	self = [super init];
	if (self != nil) {
		diffString = nil;
	}
	return self;
}
- (void) dealloc
{
	[diffString release];
	self.mclass = nil;
	[super dealloc];
}

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

+ (id)differenceFromObject:(id)object
{
	MOSDifference* difference = [self difference];
	[difference initWithObject:object];
	return difference;
}

+ (NSArray*)differencesFromObjects:(NSArray*)objects
{
	NSMutableArray* differences = [NSMutableArray arrayWithCapacity:[objects count]];
	
	for (id object in objects)
	{
		[differences addObject:[self differenceFromObject: object]];
	}
	return differences;
}

- (NSColor*)color
{
	return [NSColor blackColor];
}

- (NSAttributedString*)richDescription
{
	NSDictionary* attributes = [NSDictionary dictionaryWithObject:[self color]
														   forKey:NSForegroundColorAttributeName];
	NSAttributedString* astring = [[NSAttributedString alloc] initWithString:[self differenceDetail] 
																  attributes:attributes];
	return [astring autorelease];
}

- (NSString*)leftDiffableString
{
	return @"Old version";
}

- (NSString*)rightDiffableString
{
	return @"new version";
}

- (NSString*)diffString
{
	if (diffString) return diffString;
	
	NSString* pathBase = [NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]];
	NSString* leftFile = [pathBase stringByAppendingPathExtension:@"left.txt"];
	NSString* rightFile = [pathBase stringByAppendingPathExtension:@"right.txt"];
	
	NSString* leftString = [self leftDiffableString];
	NSString* rightString = [self rightDiffableString];
	
	NSLog(@"leftString: %@",leftString);
	NSLog(@"rightString: %@",rightString);

	[leftString writeToFile:leftFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
	[rightString writeToFile:rightFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
	
	NSTask* task = [[NSTask alloc] init];
	[task setLaunchPath:@"/usr/bin/diff"];
	[task setArguments:[NSArray arrayWithObjects:@"-u", leftFile, rightFile, nil]];
	
    NSPipe* pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
	
    NSFileHandle* file = [pipe fileHandleForReading];
	
    [task launch];
	
    NSData* data = [file readDataToEndOfFile];
	
	[task release];
	[[NSFileManager defaultManager] removeItemAtPath:leftFile error:nil];
	[[NSFileManager defaultManager] removeItemAtPath:rightFile error:nil];

    diffString = [[NSString alloc] initWithData: data
									   encoding: NSUTF8StringEncoding];
	return diffString;
}

- (NSString*)htmlRepresentation
{
	return [NSString stringWithFormat:@"<html><body><pre>%@</pre></body></html>",[self diffString]];
}

@end
