//
//  MyDocument.m
//  Chain
//
//  Created by Christoph on 11.06.09.
//  Copyright Useless Coding 2009. All rights reserved.
//

#import "UCImageBrowser.h"

@implementation UCImageBrowser

+ (NSArray *)writableTypes
{
	return [NSArray arrayWithObjects:@"UCExportPNG", @"UCExportJPEG", nil];
}

- (id)init
{
    if (self=[super init])
		{
		}

    return self;
}

- (void)dealloc
{
	[super dealloc];
}

#pragma mark -

- (NSString *)windowNibName
{
    return @"ImageBrowser";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
	[self currentFileDidChange];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
	NSLog(@"Speichern als %@.", typeName);
	return [NSData data];
}

- (NSArray *)filterTypes
{
	return [NSArray arrayWithObject:(NSString *)kUTTypeImage];
}

- (void)currentFileDidChange
{
	NSImage * image = [[NSImage alloc]  initWithContentsOfURL:[self fileURL]];
	if(image && [[image representations] count])
	{
		NSImageRep * rep = [[image representations] objectAtIndex:0];
		NSSize size = NSMakeSize([rep pixelsWide],[rep pixelsHigh]);
		
		[image setScalesWhenResized:YES];
		[image setSize:size];
	}
	[pictureView setImage:[image autorelease]];
}

#pragma mark Actions

- (void)invertImage:(id)sender
{
}

@end
