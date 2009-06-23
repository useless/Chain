//
//  UCChainController.h
//  Chain
//
//  Created by Christoph on 11.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UCPreferencesController.h"
#import "UCInspector.h"

extern NSString *const UCDefaultsFoldersKey;
extern NSString *const UCDefaultsChangedNotification;

@interface UCChainController : NSObject
{
	IBOutlet NSMenu * moveMenu;
	IBOutlet NSMenu * copyMenu;
	UCInspector * inspector;
	UCPreferencesController * prefs;
	
@private
	
}

+ (NSOpenPanel *)folderChooserWithPrompt:(NSString *)prompt allowingMultiple:(BOOL)multiple;
+ (NSOpenPanel *)folderChooserWithPrompt:(NSString *)prompt;

- (void)defaultsDidChange:(id)notification;
- (void)rebuildFolderMenus;

@property(readonly) UCInspector * inspector;

- (IBAction)customizeFolders:(id)sender;
- (IBAction)showPreferences:(id)sender;

@end
