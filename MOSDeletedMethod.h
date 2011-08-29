//
//  DeletedMethod.h
//  Mach-O-scope
//
//  Created by Karsten Kusche on 27.08.11.
//  Copyright 2011 Briksoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MOSDifference.h"

@interface MOSDeletedMethod : MOSDifference {
	MOSMethod* deletedMethod;
}

@property (retain) MOSMethod* deletedMethod;
@end
