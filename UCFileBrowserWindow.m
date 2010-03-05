//
//  UCFileBrowserWindow.m
//  Chain
//
//  Created by Christoph on 05.03.2010.
//  Copyright 2010 Useless Coding. All rights reserved.
//

#import "UCFileBrowserWindow.h"
#import "UCFileBrowser.h"


@implementation UCFileBrowserWindow

- (void)windowDidLoad
{
	[(NSDocument *)[self document] windowControllerDidLoadNib:self];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
	UCFileBrowser * doc = (UCFileBrowser *)[self document];
	return [NSString stringWithFormat:@"%@ (%d/%d)", displayName, [doc currentFileIndex]+1, [doc fileCount]];
}

@end
