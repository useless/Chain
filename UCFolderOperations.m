//
//  UCFolderOperations.m
//  Chain
//
//  Created by Christoph on 10.08.2009.
//  Copyright 2009 Useless Coding. All rights reserved.
//

#import "UCFolderOperations.h"


@implementation UCFolderOperations

+ (NSOpenPanel *)folderChooserWithPrompt:(NSString *)prompt allowingMultiple:(BOOL)multiple;
{
	NSOpenPanel * op = [NSOpenPanel openPanel];
	[op setCanChooseFiles:NO];
	[op setCanChooseDirectories:YES];
	[op setAllowsMultipleSelection:multiple];
	[op setPrompt:prompt];
	
	return op;
}

+ (NSOpenPanel *)folderChooserWithPrompt:(NSString *)prompt
{
	return [self folderChooserWithPrompt:prompt allowingMultiple:NO];
}

+ (NSString *)fileNameFromURL:(NSURL *)fileURL withNameRange:(NSRange *)outRange
{
	return [self fileNameFromPath:[fileURL path] withNameRange:outRange];
}

+ (NSString *)fileNameFromPath:(NSString *)aPath withNameRange:(NSRange *)outRange
{
	NSString * fileName = [aPath lastPathComponent];
	if(outRange!=NULL)
		{
		*outRange = NSMakeRange(0, [[fileName stringByDeletingPathExtension] length]);
		}

	return fileName;
}

+ (BOOL)canHaveFileNamed:(NSString *)fileName inFolder:(NSString *)aFolder suggestedName:(NSString **)outName
{
	// FIXME: Doesn't reject illegal filenames
	if(![[NSFileManager defaultManager] fileExistsAtPath:[aFolder stringByAppendingPathComponent:fileName]])
		{
		return YES;
		}

	if(outName!=NULL)
		{
		// TODO: Find unused filename
		// Maybe by appending a number?
		*outName = [[[fileName stringByDeletingPathExtension] stringByAppendingString:@" *SUGGEST*"] stringByAppendingPathExtension:[fileName pathExtension]];
		}

	return NO;
}

#pragma mark -

- (id)init
{
	self = [super init];
	if(self!=nil)
		{
		[NSBundle loadNibNamed:@"FileOperations" owner:self];
		}
	return self;
}

- (void) dealloc
{
	[renameView release];
	
	[super dealloc];
}

#pragma mark -

- (NSAlert *)renameSheetForFileURL:(NSURL *)fileURL
{
	return [self renameSheetForFileURL:fileURL withDisplayName:[[NSFileManager defaultManager] displayNameAtPath:[fileURL path]]];
}

- (NSAlert *)renameSheetForFileURL:(NSURL *)fileURL withDisplayName:(NSString *)displayName
{
	NSAlert * alert = [[NSAlert alloc] init];

	[alert setMessageText:[NSString localizedStringWithFormat:NSLocalizedString(@"Rename '%@'", @"Title of renaming sheet"), displayName]];
	[alert setInformativeText:NSLocalizedString(@"Type the new name to use for this document.", @"Information for renaming")];
	[alert addButtonWithTitle:NSLocalizedString(@"Rename", @"Rename Button")];
	[alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel Button")];
	[alert setAccessoryView:renameView];
	
	[renameField setStringValue:[[self class] fileNameFromURL:fileURL withNameRange:&lastRange]];
	
	return [alert autorelease];
}

- (NSAlert *)conflictSheetForName:(NSString *)fileName inFolder:(NSString *)aFolder withSuggestion:(NSString *)suggestedName
{
	NSAlert * alert = [[NSAlert alloc] init];

	[alert setMessageText:[NSString stringWithFormat:NSLocalizedString(@"A file named '%@' already exists in %@.", @"Title of Conflict sheet"), fileName, [[NSFileManager defaultManager] displayNameAtPath:aFolder]]];
	[alert setInformativeText:NSLocalizedString(@"Do you want to replace the existing file or use a new name?", @"Information for conflict")];
	[alert addButtonWithTitle:NSLocalizedString(@"Use New Name", @"Resolve Conflict with new name Button")];
	[alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel Button")];
	[alert addButtonWithTitle:NSLocalizedString(@"Replace", @"Resolve Conflict by replacing Button")];
	[[[alert buttons] objectAtIndex:2] setKeyEquivalent:@"r"];
	[[[alert buttons] objectAtIndex:2] setKeyEquivalentModifierMask:NSCommandKeyMask];
	[alert setAlertStyle:NSCriticalAlertStyle];
	[alert setAccessoryView:renameView];

	[renameField setStringValue:[[self class] fileNameFromPath:suggestedName withNameRange:&lastRange]];

	return [alert autorelease];
}

- (void)activateSheet:(NSAlert *)alert
{
	[[alert window] makeFirstResponder:renameField];
	[[renameField currentEditor] setSelectedRange:lastRange];
}

- (NSString *)sheetNameValue
{
	return [renameField stringValue];
}

@end
