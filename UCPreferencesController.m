//
//  UCPreferencesController.m
//  Chain
//
//  Created by Christoph on 11.06.09.
//  Copyright Useless Coding 2009. All rights reserved.
//

#import "UCPreferencesController.h"
#import "UCChainController.h"
#import "UCFolderOperations.h"


NSString *const UCPBTypeFolderIndexSets = @"de.sigma-server.useless.chain.folder.indexset";

@implementation UCPreferencesController

+ (NSString *)folderPathForIndex:(NSUInteger)index
{
	NSArray * theFolders = [[NSUserDefaults standardUserDefaults] objectForKey:UCDefaultsFoldersKey];
	return [theFolders objectAtIndex:index];
}

#pragma mark -

- (id) init
{
	if(self=[super init])
		{
		folders = [[[NSUserDefaults standardUserDefaults] objectForKey:UCDefaultsFoldersKey] mutableCopy];
		}
	return self;
}


- (void)dealloc
{
	[folders release];
	[super dealloc];
}

#pragma mark -

- (void)awakeFromNib
{
	[foldersTable registerForDraggedTypes:[NSArray arrayWithObjects:UCPBTypeFolderIndexSets, NSFilenamesPboardType, nil]];
	[foldersTable setDraggingSourceOperationMask:NSDragOperationMove forLocal:YES];
	[foldersTable setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];

	NSToolbar * toolbar = [[NSToolbar alloc] initWithIdentifier:@"UCPreferences"];
	[toolbar setDelegate:self];
	[toolbar setSelectedItemIdentifier:@"UCGeneralItem"];
	[window setToolbar:toolbar];
	[toolbar release];
}

- (void)show
{
	if(window==nil)
		{ [NSBundle loadNibNamed:@"Preferences" owner:self]; }

	[self validateButton];

	[window center];
	[window makeKeyAndOrderFront:self];
}

- (void)showFolders
{
	[self show];
	[[window toolbar] setSelectedItemIdentifier:@"UCFolderItem"];
	[panes selectTabViewItemWithIdentifier:@"UCFolderItem"];
}

- (void)updateUserDefaults
{
	[[NSUserDefaults standardUserDefaults] setObject:folders forKey:UCDefaultsFoldersKey];
	[[NSNotificationCenter defaultCenter] postNotificationName:UCDefaultsChangedNotification object:self];
}

#pragma mark Actions

- (IBAction)addFolder:(id)sender
{
	NSOpenPanel * op = [UCFolderOperations folderChooserWithPrompt:NSLocalizedString(@"Add", @"Panel Prompt for new target folder") allowingMultiple:YES];
	[op beginSheetForDirectory:nil file:nil modalForWindow:window modalDelegate:self didEndSelector:@selector(chooseDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)switchPane:(id)sender
{
	[panes selectTabViewItemWithIdentifier:[sender itemIdentifier]];
}

#pragma mark Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [folders count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	if([[aTableColumn identifier] isEqualToString:@"UCIcon"])
		{
		NSImage * icon = [[NSWorkspace sharedWorkspace] iconForFile:[folders objectAtIndex:rowIndex]];
		[icon setSize:NSMakeSize(16, 16)];
		return icon;
		}
	else if([[aTableColumn identifier] isEqualToString:@"UCIndex"])
		{
		if(rowIndex<9)
			{
			return [NSString stringWithFormat:@"\u2318%d", rowIndex+1];
			}
		else
			{
			return nil;
			}
		}
	
	return [[NSFileManager defaultManager] displayNameAtPath:[folders objectAtIndex:rowIndex]];
}

- (void)tableView:(NSTableView *)aTableView deleteRowsWithIndexes:(NSIndexSet *)rowIndexes
{
	[folders removeObjectsAtIndexes:[foldersTable selectedRowIndexes]];
	[self updateUserDefaults];
}

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard
{
	[pboard declareTypes:[NSArray arrayWithObjects:UCPBTypeFolderIndexSets, nil] owner:self];
	[pboard setData:[NSKeyedArchiver archivedDataWithRootObject:rowIndexes] forType:UCPBTypeFolderIndexSets];

	return YES;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation
{
	if(aTableView==[info draggingSource] && operation==NSTableViewDropAbove)
		{ return NSDragOperationMove; }
	else if(operation==NSTableViewDropAbove)
		{ return NSDragOperationCopy; }
	return NSDragOperationNone;
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
	NSPasteboard * pb = [info draggingPasteboard];
	NSString * bestType;
	NSIndexSet * rows;
	bestType = [pb availableTypeFromArray:[NSArray arrayWithObjects:UCPBTypeFolderIndexSets, NSFilenamesPboardType, nil]];
	
	if([bestType isEqualToString:UCPBTypeFolderIndexSets])
		{
		NSIndexSet * set = [NSKeyedUnarchiver unarchiveObjectWithData:[pb dataForType:bestType]];

		NSArray * items = [folders objectsAtIndexes:set];
		[folders removeObjectsAtIndexes:set];
		row -= [set countOfIndexesInRange:NSMakeRange(0, row)];
	
		rows = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row, [set count])];
		[folders insertObjects:items atIndexes:rows];
		}
	else if([bestType isEqualToString:NSFilenamesPboardType])
		{
		NSArray * files = [pb propertyListForType:bestType];
		NSUInteger count = [files count];
		NSMutableArray * goodFiles = [NSMutableArray arrayWithCapacity:count];
		
		NSFileManager * fm = [NSFileManager defaultManager];
		NSString * folder;
		NSUInteger i;
		BOOL isFolder;
		for(i=0; i<count; i++)
			{
			folder = (NSString *)[files objectAtIndex:i];
			if([fm fileExistsAtPath:folder isDirectory:&isFolder])
				{
				if(isFolder)
					{ [goodFiles addObject:folder]; }
				}
			}
		
		rows = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row, [goodFiles count])];
		[folders insertObjects:goodFiles atIndexes:rows];
		}
	else
		{
		return NO;
		}

	[aTableView reloadData];
	[aTableView selectRowIndexes:rows byExtendingSelection:NO];
	[self updateUserDefaults];
	return YES;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	[self validateButton];
}

#pragma mark Toolbar

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
	return [NSArray arrayWithObjects:@"UCGeneralItem", @"UCFolderItem", nil];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
	return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar
{
	return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
	NSToolbarItem * item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
	if([itemIdentifier isEqualToString:@"UCGeneralItem"])
		{
		[item setImage:[NSImage imageNamed:NSImageNamePreferencesGeneral]];
		[item setLabel:NSLocalizedString(@"General", @"General Toolbar Label")];
		}
	else if([itemIdentifier isEqualToString:@"UCFolderItem"])
		{
		[item setImage:[NSImage imageNamed:NSImageNameFolderSmart]];
		[item setLabel:NSLocalizedString(@"Folders", @"Folders Toolbar Label")];
		}
	[item setTarget:self];
	[item setAction:@selector(switchPane:)];
	return [item autorelease];
}

#pragma mark Validation

- (void)validateButton
{
	[removeButton setEnabled:[foldersTable selectedRow]!=-1];
}

#pragma mark -

- (void)chooseDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void  *)contextInfo
{
	[panel orderOut:self];

	if(returnCode==NSOKButton)
		{
		[folders addObjectsFromArray:[panel filenames]];
		[foldersTable reloadData];
		[self updateUserDefaults];
		}
}


@end
