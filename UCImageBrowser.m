//
//  UCImageBrowser.m
//  Chain
//
//  Created by Christoph on 11.06.2009.
//  Copyright 2009-2010 Useless Coding. All rights reserved.
//

#import "UCImageBrowser.h"
#import "UCImageBrowserWindow.h"


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

- (void) makeWindowControllers
{
	NSWindowController * mainController = [[UCImageBrowserWindow alloc] initWithWindowNibName:@"ImageBrowser"];
	[self addWindowController:mainController];
	[mainController release];
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
	NSImage * image = [[NSImage alloc] initWithContentsOfURL:[self fileURL]];
	if(image && [[image representations] count])
		{
		NSImageRep * rep = [[image representations] objectAtIndex:0];
		
		[image setScalesWhenResized:YES];
		[image setSize:NSMakeSize([rep pixelsWide], [rep pixelsHigh])];
		}
	[[self windowControllers] makeObjectsPerformSelector:@selector(setImage:) withObject:image];
	[image release];
}


@end
