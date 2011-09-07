//
//  ChangedMethod.h
//  Mach-O-scope
//
//  Created by Karsten Kusche on 27.08.11.
//  Copyright 2011 Briksoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MOSMethod;
@class MOSClass;

@interface MOSDifference : NSObject {
	MOSClass* mclass;
	NSString* diffString;
}
@property (retain) MOSClass* mclass;

+ (id)difference;
+ (NSArray*)differencesFromObjects:(NSArray*)objects;

- (NSString*)differenceKind;
- (NSString*)differenceDetail;
- (NSAttributedString*)richDescription;

- (void)initWithObject:(id)object;
- (NSString*)htmlRepresentation;

@end
