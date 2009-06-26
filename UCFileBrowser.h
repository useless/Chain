//
//  MyDocument.h
//  Chain
//
//  Created by Christoph on 11.06.09.
//  Copyright __MyCompanyName__ 2009 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "UCFileList.h"

@interface UCFileBrowser : NSDocument
{
	IBOutlet NSView * renameView;
	IBOutlet NSTextField * renameField;
	UCFileList * fileList;
}

- (void)setCurrentFileURL:(NSURL *)fileURL;

- (NSString *)fileNameWithNameRange:(NSRange *)outRange;
- (NSString *)fileNameFromURL:(NSURL *)fileURL withNameRange:(NSRange *)outRange;

- (NSArray *)filterTypes;

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
- (void)chooseDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void  *)contextInfo;

- (void)replace:(id)sender;

@end
