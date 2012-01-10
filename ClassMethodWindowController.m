//
//  ClassMethodWindowController.m
//  Mach-O-scope
//
//  Created by Scott Morrison on 10-05-08.
//  Copyright 2010 Indev Software, Inc. All rights reserved.
//

// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     1. Redistributions of source code must retain the above copyright
//          notice, this list of conditions and the following disclaimer.
//     2. Redistributions in binary form must reproduce the above copyright
//          notice, this list of conditions and the following disclaimer in the
//          documentation and/or other materials provided with the distribution.
//     3. Neither the name of Indev Software nor the
//          names of its contributors may be used to endorse or promote products
//          derived from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY INDEV SOFTWARE ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL INDEV SOFTWARE BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "ClassMethodWindowController.h"
#import "OTXDisassemblyScanner.h"
#import "MOSClass.h"
#import "MOSMethod.h"
#import "DisassemblyWindowController.h"

NSString * myNibName = @"ClassMethodBrowser";

@interface ClassMethodWindowController()
@property (retain,readwrite) MOSDatabase * database;
@property (retain) OTXDisassemblyScanner * currentScanner;
@end




@implementation ClassMethodWindowController
@synthesize database = _database;
@synthesize pathToDatabase;
@synthesize	methodFilter;
@synthesize symbolFilter,searchContext;
@synthesize showMisses;
@synthesize progressAmount, progressTotal;
@synthesize currentScanner;
@synthesize currentSelection;
-(void)doubleClickMethod:(id)sender{
	[self openDisassemblyWindowForMethodID:[sender integerValue]];
}

-(id)init{
	self = [super initWithWindowNibName:[NSString stringWithString:myNibName]];
	if (self){
		[self addObserver:self forKeyPath:@"searchContext" options:0 context:nil];
		[self addObserver:self forKeyPath:@"showMisses" options:0 context:nil];
	}
	return self;
}
-(id)initWithDatabasePath:(NSString*)aPath{
	self = [self init];
	if (self){
		self.database = [[MOSDatabase alloc] initWithPath:aPath andDelegate:self];
	}
	return self;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	//if ([keyPath isEqualToString:@"searchContext"]){
		[self willChangeValueForKey:@"classes"];
		[self didChangeValueForKey:@"classes"];
	
}

-(void)dealloc{
	[self removeObserver:self forKeyPath:@"searchContext"];
	[self removeObserver:self forKeyPath:@"showMisses"];
	
	symbolFilter = nil;
	methodFilter = nil;
	currentScanner = nil;
	[super dealloc];
}


-(BOOL)validateMenuItem:(NSMenuItem *)menuItem{
	SEL action = [menuItem action];
	
	if (action==@selector(disassembleMachO:)) return YES;
	if (action==@selector(openDocument:)) return YES;

	return NO;
}

-(void)setFilterMethodPredicate:(id)dummyType{
	
}
-(NSPredicate *)filterMethodPredicate
{
	if (methodFilter && [methodFilter length]>0){
		NSPredicate * aPredicate = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@" ,@"rawInfo",methodFilter];
		return aPredicate;
	}
	return [NSPredicate predicateWithValue:YES];
}
-(NSString *)methodFilter
{
	return methodFilter;
}



-(void) setMethodFilter:(NSString *)aFilterString
{
	
	if (methodFilter != aFilterString){
		[self willChangeValueForKey:@"filterMethodPredicate"];//
		id oldString = methodFilter;
		methodFilter = [aFilterString copy];
		[oldString release];
		[self didChangeValueForKey:@"filterMethodPredicate"];//
	}

}

-(NSString *)symbolFilter
{
	return symbolFilter;
}

-(void) setSymbolFilter:(NSString*)aSymbol{
	if (aSymbol != self.symbolFilter){
				
		if ([[classesController selectedObjects] count]){
			self.currentSelection = [classesController selectedObjects];
		}	
		
		[self willChangeValueForKey:@"classes"];
		id oldString = self.symbolFilter;
		symbolFilter = [aSymbol copy];
		[oldString release];
		[self didChangeValueForKey:@"classes"];
		
		if ([self.currentSelection count]){
			NSArray * arrangedObjects =[classesController arrangedObjects];
			MOSClass* selection = [self.currentSelection objectAtIndex:0];
			for (MOSClass* anObject in arrangedObjects){
				if ([anObject.className isEqualToString:selection.className]){
					[classesController setSelectedObjects:[NSArray arrayWithObject:anObject]];
					break;
				}
			}
		}
	}
}

-(IBAction)cancelImport:(id)sender{
	self.currentScanner.cancelImport = YES;	
}

-(void)importBundleAtPath:(id)bundlePath{
	[NSApp beginSheet: progressSheet
	   modalForWindow: [self window]
		modalDelegate: self
	   didEndSelector: nil //didEndSheet:returnCode:contextInfo:
		  contextInfo: nil];		
	
	self.currentScanner = [[OTXDisassemblyScanner alloc] initWithDelegate:self bundle:bundlePath andDatabase:self.database];
	[NSThread detachNewThreadSelector:@selector(_backgroundImportBundle) toTarget:self.currentScanner withObject:nil];
	
}


-(void)openDisassemblyWindowForMethodID:(NSInteger)methodId{

	EGODatabaseResult * dbResult = [self.database executeQueryWithParameters:@"select * from Methods where methodID = ?",[NSNumber numberWithInteger:methodId],nil];
	if ([dbResult count]){
		for (EGODatabaseRow * row in dbResult){
			MOSMethod * method = [[MOSMethod alloc] initWithResultRow:row];
			method.delegate = self.database;
			DisassemblyWindowController * disWindowController = [[DisassemblyWindowController alloc] initWithMethod:method];
			//FIXME: The window controller should be dealt with properly and not just leaked
#pragma unused(disWindowController);
			
			[method release];
		}
	}
}



-(NSString *)progressLabel{
	return [NSString stringWithFormat:@"Processing line %ld of %ld",self.progressAmount,self.progressTotal];
}

-(void)updateProgressIndicatorWithCount:(NSDictionary*)status{
	[self willChangeValueForKey:@"progressLabel"];
	self.progressAmount = [[status objectForKey:@"current"] integerValue];
	self.progressTotal = [[status objectForKey:@"total"] integerValue];
	[self didChangeValueForKey:@"progressLabel"];
	
	// force an update of the classes property so the UI will update accordingly
	[self willChangeValueForKey:@"classes"];
	[self didChangeValueForKey:@"classes"];
}

-(void)importCompleteWithResult:(NSNumber *) result{
	[NSApp endSheet:progressSheet];
	[progressSheet orderOut:self];
	self.currentScanner = nil;
	
	// force an update of the classes property so the UI will update accordingly
	[self willChangeValueForKey:@"classes"];
	[self didChangeValueForKey:@"classes"];

}

-(NSArray*)classes{
	
	id result =  [self.database classes];
	
	if (!result) return [NSMutableArray array];
	return result;
	
}


@end


