//
//  NewMethod.h
//  Mach-O-scope
//
//  Created by Karsten Kusche on 27.08.11.
//  Copyright 2011 Briksoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MOSDifference.h"

@interface MOSNewMethod : MOSDifference {
	MOSMethod* newMethod;
}

@property (retain) MOSMethod* newMethod;

@end
