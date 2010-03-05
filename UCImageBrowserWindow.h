//
//  UCImageBrowserWindow.h
//  Chain
//
//  Created by Christoph on 05.03.2010.
//  Copyright 2010 Useless Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UCFileBrowserWindow.h"


@interface UCImageBrowserWindow : UCFileBrowserWindow
{
	IBOutlet NSImageView * pictureView;
}

- (void)setImage:(NSImage *)image;

- (IBAction)invertImage:(id)sender;
- (IBAction)toggleAnimation:(id)sender;
- (IBAction)toggleSizeToFit:(id)sender;

@end
