//
//  MyDocument.m
//  Chain
//
//  Created by Christoph on 11.06.09.
//  Copyright Useless Coding 2009. All rights reserved.
//

#import "UCFileBrowser.h"
#import "UCChainController.h"


@implementation UCFileBrowser

- (id)init
{
    if(self=[super init])
		{
		}

    return self;
}

- (void)dealloc
{
	[fileList release];
	[super dealloc];
}

#pragma mark -

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
//	Toolbar?!
}

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
{
	NSString * path = [absoluteURL path];
	
	fileList = [[UCFileList alloc] initForPath:path withTypes:[self filterTypes]];

	if(fileList==nil)
		{
		if(outError!=NULL)
			{
			*outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:nil];
			}
		return NO;
		}

	if([fileList currentFile]==nil)
		{
		if(outError!=NULL)
			{
			*outError = [NSError errorWithDomain:@"UCChainErrors" code:42 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
				NSLocalizedString(@"The folder contains no files of a suitable kind.", @"Unable to open folder reason"), NSLocalizedFailureReasonErrorKey,
				NSLocalizedString(@"Try opening a file of a suitable kind.", @"Unable to open folder suggestion"), NSLocalizedRecoverySuggestionErrorKey,
			nil]];
			}
		return NO;
		}
	else
		{
		[self setFileURL:[NSURL fileURLWithPath:[fileList currentFile]]];
		}

	return YES;
}

#pragma mark Document

- (NSArray *)filterTypes
{
	return [NSArray arrayWithObject:(NSString *)kUTTypeData];
}

- (void)setCurrentFile:(NSString *)filePath
{
	[self setFileURL:[NSURL fileURLWithPath:filePath]];
	[self currentFileDidChange];
}

- (void)currentFileDidChange
{
}

- (NSString *)fileNameWithNameRange:(NSRange *)outRange
{
	return [self fileNameFromURL:[self fileURL] withNameRange:outRange];
}

- (NSString *)fileNameFromURL:(NSURL *)fileURL withNameRange:(NSRange *)outRange
{
	NSString * fileName = [[fileURL path] lastPathComponent];
	if(outRange!=NULL)
		{
		*outRange = NSMakeRange(0, [[fileName stringByDeletingPathExtension] length]);
		}

	return fileName;
}

#pragma mark Actions

- (IBAction)gotoFirst:(id)sender
{
	[fileList setCurrentIndex:0];
	[self setCurrentFile:[fileList currentFile]];
}

- (IBAction)gotoPrevious:(id)sender
{
	NSUInteger prev = fileList.currentIndex-1;
	if(prev==-1)
		{
		[fileList setCurrentIndex:fileList.count-1];
		[self setCurrentFile:[fileList currentFile]];
		}
	else
		{
		[fileList setCurrentIndex:prev];
		[self setCurrentFile:[fileList currentFile]];
		}
}

- (IBAction)gotoNext:(id)sender
{
	NSUInteger next = fileList.currentIndex+1;
	if(next==fileList.count)
		{
		[fileList setCurrentIndex:0];
		[self setCurrentFile:[fileList currentFile]];
		}
	else
		{
		[fileList setCurrentIndex:next];
		[self setCurrentFile:[fileList currentFile]];
		}
}

- (IBAction)gotoLast:(id)sender
{
	[fileList setCurrentIndex:fileList.count-1];
	[self setCurrentFile:[fileList currentFile]];
}

- (IBAction)gotoIndex:(id)sender
{
}

#pragma mark -

- (IBAction)moveTo:(id)sender
{
	if([sender tag]==0)
		{
		NSOpenPanel * op = [UCChainController folderChooserWithPrompt:NSLocalizedString(@"Move", @"Panel prompt for other Move target")];
		[op beginSheetForDirectory:nil file:nil modalForWindow:[self windowForSheet] modalDelegate:self didEndSelector:@selector(chooseDidEnd:returnCode:contextInfo:) contextInfo:nil];
		}
}

- (IBAction)copyTo:(id)sender
{
	if([sender tag]==0)
		{
		NSOpenPanel * op = [UCChainController folderChooserWithPrompt:NSLocalizedString(@"Copy", @"Panel prompt for other Copy target")];
		[op beginSheetForDirectory:nil file:nil modalForWindow:[self windowForSheet] modalDelegate:self didEndSelector:@selector(chooseDidEnd:returnCode:contextInfo:) contextInfo:nil];
		}
}

- (IBAction)moveAgain:(id)sender
{
}

#pragma mark -

- (IBAction)moveToTrash:(id)sender
{
}

- (IBAction)rename:(id)sender
{
	NSAlert * alert = [[NSAlert alloc] init];

	[alert setMessageText:[NSString localizedStringWithFormat:NSLocalizedString(@"Rename \u201c%@\u201d", @"Title of renaming sheet"), [self displayName]]];
	[alert setInformativeText:NSLocalizedString(@"Type the new name to use for this document.", @"Information for renaming")];
	[alert addButtonWithTitle:@"Rename"];
	[alert addButtonWithTitle:@"Cancel"];
	[alert setAccessoryView:renameView];
	NSRange nameRange;
	
	[renameField setStringValue:[self fileNameWithNameRange:&nameRange]];

	[alert beginSheetModalForWindow:[self windowForSheet] modalDelegate:self didEndSelector:@selector(renameDidEnd:returnCode:contextInfo:) contextInfo:nil];
	[[alert window] makeFirstResponder:renameField];
	[[renameField currentEditor] setSelectedRange:nameRange];
}

- (void)replace:(id)sender
{
	NSAlert * alert = [[NSAlert alloc] init];

	[alert setMessageText:@"Conflict!"];
	[alert setInformativeText:@"Type the new name for “...” or replace."];
	[alert addButtonWithTitle:@"Use New Name"];
	[alert addButtonWithTitle:@"Cancel"];
	[alert addButtonWithTitle:@"Replace"];
	[[[alert buttons] objectAtIndex:2] setKeyEquivalent:@"r"];
	[[[alert buttons] objectAtIndex:2] setKeyEquivalentModifierMask:NSCommandKeyMask];
	[alert setAlertStyle:NSCriticalAlertStyle];
	[alert setAccessoryView:renameView];
//	[alert setAlertStyle:NSAl
	[renameField setStringValue:[self displayName]];

	[alert beginSheetModalForWindow:[self windowForSheet] modalDelegate:self didEndSelector:@selector(renameDidEnd:returnCode:contextInfo:) contextInfo:nil];
	[[alert window] makeFirstResponder:renameField];
	[[renameField currentEditor] setSelectedRange:NSMakeRange(0, 3)];
}

#pragma mark -

- (void)renameDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo;
{
	[[alert window] orderOut:self];
	[alert release];
	
	// Context-Info sollte Verschiebe/Kopierinformationen enthalten
	
	if(returnCode==NSAlertFirstButtonReturn) // (Verschieben) und Umbenennen
		{
		NSLog(@"Umbennen in „%@“", [renameField stringValue]);
		[self replace:self];
		}
	else if(returnCode==NSAlertThirdButtonReturn) // Verschieben und Ersetzen
		{
		NSLog(@"Ersetzen.");
		}
	else
		{
		NSLog(@"NICHT Umbennen.");
		}
}

- (void)chooseDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void  *)contextInfo
{
	[panel orderOut:self];
	if(returnCode==NSOKButton)
		{
		NSLog(@"Move/Copy there: %@.", [[panel filenames] objectAtIndex:0]);
	
		[self replace:self];
		}
}

#pragma mark Validation

- (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem
{
	if([anItem action]==@selector(gotoLast:))
		{
		return fileList.currentIndex!=fileList.count-1;
		}
	else if([anItem action]==@selector(gotoFirst:))
		{
		return fileList.currentIndex!=0;
		}
	
	return YES;
}


@end
