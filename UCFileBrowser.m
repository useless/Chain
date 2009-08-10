//
//  MyDocument.m
//  Chain
//
//  Created by Christoph on 11.06.09.
//  Copyright Useless Coding 2009. All rights reserved.
//

#import "UCFileBrowser.h"
#import "UCPreferencesController.h"


@implementation UCFileBrowser

- (id)init
{
    if(self=[super init])
		{
		folderOperations = nil;
		}

    return self;
}

- (void)dealloc
{
	[folderOperations release];
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

- (UCFolderOperations *)folderOperations
{
	if(folderOperations==nil)
		{
		folderOperations = [[UCFolderOperations alloc] init];
		}

	return folderOperations;
}

#pragma mark File Operations

- (void)copy:(BOOL)copying confirmedFileTo:(NSString *)aFolder withName:(NSString *)newName
{
	if(newName==nil)
		{
		newName = [[[self fileURL] path] lastPathComponent];
		}

	NSString * suggestedName;
	if([UCFolderOperations canHaveFileNamed:newName inFolder:aFolder suggestedName:&suggestedName])
		{
		if(copying)
			{
			[self copyFileTo:aFolder withName:newName];
			}
		else
			{
			[self moveFileTo:aFolder withName:newName];
			}
		}
	else
		{
		NSAlert * alert = [[self folderOperations] conflictSheetForName:newName inFolder:aFolder withSuggestion:suggestedName];
		[alert beginSheetModalForWindow:[self windowForSheet] modalDelegate:self didEndSelector:@selector(conflictDidEnd:returnCode:contextInfo:) contextInfo:[[NSDictionary alloc] initWithObjectsAndKeys:
			newName, @"UCConflictName",
			aFolder, @"UCTargetFolder",
			copying?@"YES":@"NO", @"UCCopying",
		nil]];
		[[self folderOperations] activateSheet:alert];
		}
}

- (void)moveConfirmedFileTo:(NSString *)aFolder withName:(NSString *)newName
{
	[self copy:NO confirmedFileTo:aFolder withName:newName];
}

- (void)copyConfirmedFileTo:(NSString *)aFolder withName:(NSString *)newName
{
	[self copy:YES confirmedFileTo:aFolder withName:newName];
}

- (void)moveFileTo:(NSString *)aFolder withName:(NSString *)newName
{
	// TODO: perform actual file operations
	// delegate to UCFolderOperations
	// handle Errors here
	NSLog(@"%@ -=> %@ (%@).", [self fileURL], newName, aFolder);
}

- (void)copyFileTo:(NSString *)aFolder withName:(NSString *)newName
{
	NSLog(@"%@ +=> %@ (%@).", [self fileURL], newName, aFolder);
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
		NSOpenPanel * op = [UCFolderOperations folderChooserWithPrompt:NSLocalizedString(@"Move", @"Panel prompt for other Move target")];
		[op beginSheetForDirectory:nil file:nil modalForWindow:[self windowForSheet] modalDelegate:self didEndSelector:@selector(chooseDidEnd:returnCode:copying:) contextInfo:NO];
		}
	else
		{
		[self moveConfirmedFileTo:[UCPreferencesController folderPathForIndex:[sender tag]-1] withName:nil];
		}
}

- (IBAction)copyTo:(id)sender
{
	if([sender tag]==0)
		{
		NSOpenPanel * op = [UCFolderOperations folderChooserWithPrompt:NSLocalizedString(@"Copy", @"Panel prompt for other Copy target")];
		[op beginSheetForDirectory:nil file:nil modalForWindow:[self windowForSheet] modalDelegate:self didEndSelector:@selector(chooseDidEnd:returnCode:copying:) contextInfo:YES];
		}
	else
		{
		[self copyConfirmedFileTo:[UCPreferencesController folderPathForIndex:[sender tag]-1] withName:nil];
		}

}

- (IBAction)moveAgain:(id)sender
{
}

- (IBAction)moveToTrash:(id)sender
{
}

- (IBAction)rename:(id)sender
{
	NSAlert * alert = [[self folderOperations] renameSheetForFileURL:[self fileURL] withDisplayName:[self displayName]];
	[alert beginSheetModalForWindow:[self windowForSheet] modalDelegate:self didEndSelector:@selector(renameDidEnd:returnCode:contextInfo:) contextInfo:nil];
	[[self folderOperations] activateSheet:alert];
}

#pragma mark Sheet Handling

- (void)renameDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	[[alert window] orderOut:self];

	if(returnCode==NSAlertFirstButtonReturn) // Rename
		{
		[self moveConfirmedFileTo:fileList.folder withName:[[self folderOperations] sheetNameValue]];
		}
}

- (void)conflictDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(NSDictionary *)contextInfo
{
	[[alert window] orderOut:self];
	NSString * targetFolder = [[[contextInfo objectForKey:@"UCTargetFolder"] retain] autorelease];
	NSString * conflictName = [[[contextInfo objectForKey:@"UCConflictName"] retain] autorelease];
	BOOL copying = [[contextInfo objectForKey:@"UCCopying"] boolValue];
	[contextInfo release];
	
	if(returnCode==NSAlertFirstButtonReturn) // Copy/Move with new Name
		{
		[self copy:copying confirmedFileTo:targetFolder withName:[[self folderOperations] sheetNameValue]];
		}
	else if(returnCode==NSAlertThirdButtonReturn) // Copy/Move Replacing
		{
		if(copying)
			{
			[self copyFileTo:targetFolder withName:conflictName];
			}
		else
			{
			[self moveFileTo:targetFolder withName:conflictName];
			}
		}
}

- (void)chooseDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode copying:(BOOL)copying
{
	[panel orderOut:self];

	if(returnCode==NSOKButton)
		{
		[self copy:copying confirmedFileTo:[[panel filenames] objectAtIndex:0] withName:nil];
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
