//
//  MyDocument.h
//  Chain
//
//  Created by Christoph on 11.06.09.
//  Copyright Useless Coding 2009. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "UCFileBrowser.h"

@interface UCImageBrowser : UCFileBrowser
{
	IBOutlet NSImageView * pictureView;
}

- (IBAction)invertImage:(id)sender;
- (IBAction)toggleAnimation:(id)sender;

@end
