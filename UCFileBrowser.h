//
//  UCFileBrowser.h
//  Chain
//
//  Created by Christoph on 11.06.2009.
//  Copyright 2009-2010 Useless Coding. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "UCFileList.h"
#import "UCFolderOperations.h"


@interface UCFileBrowser : NSDocument
{
	UCFolderOperations * folderOperations;
	UCFileList * fileList;
}

- (void)setCurrentFile:(NSString *)filePath;
- (void)currentFileDidChange;

- (NSArray *)filterTypes;

- (UCFolderOperations *)folderOperations;
- (void)copy:(BOOL)copying confirmedFileTo:(NSString *)aFolder withName:(NSString *)newName;
- (void)moveConfirmedFileTo:(NSString *)aFolder withName:(NSString *)newName;
- (void)copyConfirmedFileTo:(NSString *)aFolder withName:(NSString *)newName;

- (void)moveFileTo:(NSString *)aFolder withName:(NSString *)newName;
- (void)copyFileTo:(NSString *)aFolder withName:(NSString *)newName;

- (IBAction)gotoFirst:(id)sender;
- (IBAction)gotoPrevious:(id)sender;
- (IBAction)gotoNext:(id)sender;
- (IBAction)gotoLast:(id)sender;
- (IBAction)gotoIndex:(id)sender;

- (IBAction)moveTo:(id)sender;
- (IBAction)copyTo:(id)sender;
- (IBAction)moveAgain:(id)sender;
- (IBAction)moveToTrash:(id)sender;
- (IBAction)rename:(id)sender;

- (void)renameDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo;
- (void)conflictDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(NSDictionary *)contextInfo;
- (void)chooseDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode copying:(BOOL)copying;

@end
