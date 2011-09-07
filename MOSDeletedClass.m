//
//  MOSDeletedClass.m
//  Mach-O-scope
//
//  Created by Karsten Kusche on 27.08.11.
//  Copyright 2011 Briksoftware.com. All rights reserved.
//

#import "MOSDeletedClass.h"


@implementation MOSDeletedClass

- (NSColor*)color
{
	return [NSColor redColor];
}

- (NSString*)leftDiffableString
{
	return [self.mclass className];
}

- (NSString*)rightDiffableString
{
	return @"deleted";
}

@end
