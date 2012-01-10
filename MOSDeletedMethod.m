//
//  DeletedMethod.m
//  Mach-O-scope
//
//  Created by Karsten Kusche on 27.08.11.
//  Copyright 2011 Briksoftware.com. All rights reserved.
//

#import "MOSDeletedMethod.h"
#import "MOSMethod.h"

@implementation MOSDeletedMethod
@synthesize deletedMethod;

- (void)initWithObject:(id)object
{
	MOSMethod* method = object;
	[super initWithObject:method.mclass];
	self.deletedMethod = method;
}

- (NSString*)differenceDetail
{
	return [NSString stringWithFormat:@"%@>>%@",[super differenceDetail],deletedMethod.methodName];
}

@end
