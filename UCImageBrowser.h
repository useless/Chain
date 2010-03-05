//
//  UCImageBrowser.h
//  Chain
//
//  Created by Christoph on 11.06.2009.
//  Copyright 2009-2010 Useless Coding. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "UCFileBrowser.h"

@interface UCImageBrowser : UCFileBrowser
{
	IBOutlet NSImageView * pictureView;
}

- (IBAction)invertImage:(id)sender;
- (IBAction)toggleAnimation:(id)sender;
- (IBAction)toggleSizeToFit:(id)sender;

@end
