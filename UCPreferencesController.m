//
//  UCPreferencesController.m
//  Chain
//
//  Created by Christoph on 11.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UCPreferencesController.h"
#import "UCChainController.h"


NSString *const UCPBTypeFolderIndexSets = @"com.useless.chain.folder.indexset";

@implementation UCPreferencesController

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
}

- (void)show
{
	if(window==nil)
		{ [NSBundle loadNibNamed:@"Preferences" owner:self]; }

	[self validateButton];

	[window center];
	[window makeKeyAndOrderFront:self];
}

- (void)updateUserDefaults
{
	[[NSUserDefaults standardUserDefaults] setObject:folders forKey:UCDefaultsFoldersKey];
	[[NSNotificationCenter defaultCenter] postNotificationName:UCDefaultsChangedNotification object:self];
}

#pragma mark Actions

- (IBAction)addFolder:(id)sender
{
	NSOpenPanel * op = [UCChainController folderChooserWithPrompt:NSLocalizedString(@"Add", @"Panel Prompt for new target folder") allowingMultiple:YES];
	[op beginSheetForDirectory:nil file:nil modalForWindow:window modalDelegate:self didEndSelector:@selector(chooseDidEnd:returnCode:contextInfo:) contextInfo:nil];
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
