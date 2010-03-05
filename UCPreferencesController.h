//
//  UCPreferencesController.h
//  Chain
//
//  Created by Christoph on 11.06.2009.
//  Copyright 2009 Useless Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const UCPBTypeFolderIndexSets;

@interface UCPreferencesController : NSObject
{
	IBOutlet NSWindow * window;
	IBOutlet NSTableView * foldersTable;
	IBOutlet NSButton * addButton;
	IBOutlet NSButton * removeButton;
	IBOutlet NSView * prefGeneral;
	IBOutlet NSView * prefFolders;

@private
	NSMutableArray * folders;
	NSString * activePane;
}

+ (NSString *)folderPathForIndex:(NSUInteger)index;

- (void)show;
- (void)showAndCenter:(BOOL)centering;
- (void)showFolders;
- (void)updateUserDefaults;

- (IBAction)addFolder:(id)sender;
- (IBAction)switchPane:(id)sender;

- (void)setPane:(NSView *)pane;
- (void)setPaneWithIdentifier:(NSString *)identifier;
- (NSView *)paneForIdentifier:(NSString *)identifier;
- (NSRect)frameForPane:(NSView *)pane;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;
- (void)tableView:(NSTableView *)aTableView deleteRowsWithIndexes:(NSIndexSet *)rowIndexes;
- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard;
- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id<NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation;
- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id<NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation;
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification;

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar;
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar;
- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar;
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag;

- (void)validateButton;

- (void)chooseDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void  *)contextInfo;


@end
