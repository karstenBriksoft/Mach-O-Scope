//
//  MOSChangedMethod.h
//  Mach-O-scope
//
//  Created by Karsten Kusche on 27.08.11.
//  Copyright 2011 Briksoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MOSDifference.h"

@interface MOSChangedMethod : MOSDifference {
	MOSMethod* oldMethod;
	MOSMethod* newMethod;
}

@property (retain) MOSMethod* oldMethod;
@property (retain) MOSMethod* newMethod;

@end
