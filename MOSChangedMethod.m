//
//  MOSChangedMethod.m
//  Mach-O-scope
//
//  Created by Karsten Kusche on 27.08.11.
//  Copyright 2011 Briksoftware.com. All rights reserved.
//

#import "MOSChangedMethod.h"
#import "MOSMethod.h"

@implementation MOSChangedMethod
@synthesize newMethod, oldMethod;

- (NSColor*)color
{
	return [NSColor blueColor];
}

- (NSString*)differenceDetail
{
	return [NSString stringWithFormat:@"%@>>%@",[self.mclass className],[self.oldMethod rawInfo]];
}

- (NSString*)leftDiffableString
{
	return [self.oldMethod diffableString];
}

- (NSString*)rightDiffableString
{
	return [self.newMethod diffableString];
}

@end
