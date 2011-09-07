//
//  NewMethod.m
//  Mach-O-scope
//
//  Created by Karsten Kusche on 27.08.11.
//  Copyright 2011 Briksoftware.com. All rights reserved.
//

#import "MOSNewMethod.h"
#import "MOSMethod.h"

@implementation MOSNewMethod
@synthesize newMethod;

- (void)initWithObject:(id)object
{
	MOSMethod* method = object;
	[super initWithObject:method.mclass];
	self.newMethod = method;
}

- (NSString*)differenceDetail
{
	return [NSString stringWithFormat:@"%@>>%@",[super differenceDetail],newMethod.methodName];
}

- (NSColor*)color
{
	return [NSColor greenColor];
}

- (NSString*)leftDiffableString
{
	return @"";
}

- (NSString*)rightDiffableString
{
	return [self.newMethod diffableString];
}

@end
