//
//  UCPreferencesController.h
//  Chain
//
//  Created by Christoph on 11.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
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
- (IBAction)removeFolder:(id)sender;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;
- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard;
- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation;
- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation;
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification;

- (void)validateButton;

- (void)chooseDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void  *)contextInfo;


@end
