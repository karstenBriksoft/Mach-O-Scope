//
//  MOSNewClass.m
//  Mach-O-scope
//
//  Created by Karsten Kusche on 27.08.11.
//  Copyright 2011 Briksoftware.com. All rights reserved.
//

#import "MOSNewClass.h"


@implementation MOSNewClass

- (NSColor*)color
{
	return [NSColor greenColor];
}

- (NSString*)leftDiffableString
{
	return @"not there yet";
}

- (NSString*)rightDiffableString
{
	return [self.mclass className];
}

@end
