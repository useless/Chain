//
//  UCPreferencesController.h
//  Chain
//
//  Created by Christoph on 11.06.09.
//  Copyright Useless Coding 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const UCPBTypeFolderIndexSets;

@interface UCPreferencesController : NSObject
{
	IBOutlet NSWindow * window;
	IBOutlet NSTableView * foldersTable;
	IBOutlet NSButton * addButton;
	IBOutlet NSButton * removeButton;

@private
	NSMutableArray * folders;
}

- (void)show;
- (void)updateUserDefaults;

- (IBAction)addFolder:(id)sender;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;
- (void)tableView:(NSTableView *)aTableView deleteRowsWithIndexes:(NSIndexSet *)rowIndexes;
- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard;
- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation;
- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation;
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification;

- (void)validateButton;

- (void)chooseDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void  *)contextInfo;


@end
