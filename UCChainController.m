//
//  UCChainController.m
//  Chain
//
//  Created by Christoph on 11.06.09.
//  Copyright Useless Coding 2009. All rights reserved.
//

#import "UCChainController.h"


NSString *const UCDefaultsFoldersKey = @"UCFolders";
NSString *const UCDefaultsChangedNotification = @"UCDefaultsChanged";

@implementation UCChainController

@synthesize inspector;

+ (NSOpenPanel *)folderChooserWithPrompt:(NSString *)prompt allowingMultiple:(BOOL)multiple;
{
	NSOpenPanel * op = [NSOpenPanel openPanel];
	[op setCanChooseFiles:NO];
	[op setCanChooseDirectories:YES];
	[op setAllowsMultipleSelection:multiple];
	[op setPrompt:prompt];
	
	return op;
}

+ (NSOpenPanel *)folderChooserWithPrompt:(NSString *)prompt
{
	return [self folderChooserWithPrompt:prompt allowingMultiple:NO];
}

#pragma mark -

- (id)init
{
    if (self=[super init])
		{
		NSArray * folders = [NSArray arrayWithObjects:NSHomeDirectory(), [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"], [NSHomeDirectory() stringByAppendingPathComponent:@"Pictures"], nil];
		NSDictionary * factoryDefaults = [NSDictionary dictionaryWithObjectsAndKeys:folders, UCDefaultsFoldersKey, nil];
		
		inspector = nil;
		prefs = nil;
		
		[[NSUserDefaults standardUserDefaults] registerDefaults:factoryDefaults];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultsDidChange:) name:UCDefaultsChangedNotification object:nil];
		}

    return self;
}

- (void) dealloc
{
	[inspector release];
	[prefs release];
	[super dealloc];
}

#pragma mark -

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)awakeFromNib
{
	[self rebuildFolderMenus];
}

- (void)defaultsDidChange:(id)notification
{
	[self rebuildFolderMenus];
}

- (void)rebuildFolderMenus
{
	NSFileManager * fm = [NSFileManager defaultManager];
	NSWorkspace * ws = [NSWorkspace sharedWorkspace];
	NSArray * folders = [[NSUserDefaults standardUserDefaults] objectForKey:UCDefaultsFoldersKey];
	NSMenuItem * moveItem;
	NSMenuItem * copyItem;
	NSString * folder;
	NSString * folderName;
	NSImage * folderIcon;
	BOOL isFolder;

	[moveMenu setMenuChangedMessagesEnabled:NO];
	[copyMenu setMenuChangedMessagesEnabled:NO];
	
	NSUInteger i;
	for(i=1; i<10; i++)
		{
		moveItem = [moveMenu itemWithTag:i];
		copyItem = [copyMenu itemWithTag:i];
		
		if(i<[folders count]+1)
			{
			folder = (NSString *)[folders objectAtIndex:i-1];
			if([fm fileExistsAtPath:folder isDirectory:&isFolder] && isFolder)
				{
				folderName = [fm displayNameAtPath:folder];
				[moveItem setTitle:folderName];
				[copyItem setTitle:folderName];
				
				folderIcon = [ws iconForFile:folder];
				[folderIcon setSize:NSMakeSize(16, 16)];
				[moveItem setImage:folderIcon];
				[copyItem setImage:folderIcon];
				
				[moveItem setHidden:NO];
				[copyItem setHidden:NO];
				continue;
				}
			}

		[moveItem setTitle:@"--"];
		[copyItem setTitle:@"--"];
		[moveItem setImage:nil];
		[copyItem setImage:nil];
		[moveItem setHidden:YES];
		[copyItem setHidden:YES];
		}
	
	[moveMenu setMenuChangedMessagesEnabled:YES];
	[copyMenu setMenuChangedMessagesEnabled:YES];
}

#pragma mark Actions

- (IBAction)customizeFolders:(id)sender
{
	[self showPreferences:sender];
}

- (IBAction)showPreferences:(id)sender
{
	if(prefs==nil)
		{ prefs = [[UCPreferencesController alloc] init]; }
	[prefs show];
}

@end
