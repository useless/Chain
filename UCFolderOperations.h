//
//  UCFolderOperations.h
//  Chain
//
//  Created by Christoph on 10.08.09.
//  Copyright Useless Coding 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface UCFolderOperations : NSObject
{
	IBOutlet NSView * renameView;
	IBOutlet NSTextField * renameField;

@private
	NSRange lastRange;
}

+ (NSOpenPanel *)folderChooserWithPrompt:(NSString *)prompt allowingMultiple:(BOOL)multiple;
+ (NSOpenPanel *)folderChooserWithPrompt:(NSString *)prompt;

+ (NSString *)fileNameFromURL:(NSURL *)fileURL withNameRange:(NSRange *)outRange;
+ (NSString *)fileNameFromPath:(NSString *)aPath withNameRange:(NSRange *)outRange;
+ (BOOL)canHaveFileNamed:(NSString *)fileName inFolder:(NSString *)aFolder suggestedName:(NSString **)outName;

- (NSAlert *)renameSheetForFileURL:(NSURL *)fileURL;
- (NSAlert *)renameSheetForFileURL:(NSURL *)fileURL withDisplayName:(NSString *)displayName;

- (NSAlert *)conflictSheetForName:(NSString *)fileName inFolder:(NSString *)aFolder withSuggestion:(NSString *)suggestedName;

- (void)activateSheet:(NSAlert *)alert;
- (NSString *)sheetNameValue;

@end
