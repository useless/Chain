//
//  UCImageBrowser.m
//  Chain
//
//  Created by Christoph on 11.06.2009.
//  Copyright 2009-2010 Useless Coding. All rights reserved.
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
		
		[image setScalesWhenResized:YES];
		[image setSize:NSMakeSize([rep pixelsWide], [rep pixelsHigh])];
		}
	[pictureView setImage:[image autorelease]];
}

#pragma mark Actions

- (void)invertImage:(id)sender
{
}

- (IBAction)toggleAnimation:(id)sender;
{
	[pictureView setAnimates:![pictureView animates]];
}

- (IBAction)toggleSizeToFit:(id)sender;
{
	// FIXME: Add Scrolling
	[pictureView setImageScaling:([pictureView imageScaling]==NSImageScaleNone)?NSImageScaleProportionallyDown:NSImageScaleNone];
}

#pragma mark Validation

- (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem
{
	if([anItem action]==@selector(toggleAnimation:) && [(NSObject *)anItem isKindOfClass:[NSMenuItem class]])
		{
		[(NSMenuItem *)anItem setState:[pictureView animates]?NSOnState:NSOffState];
		}
	else if([anItem action]==@selector(toggleSizeToFit:) && [(NSObject *)anItem isKindOfClass:[NSMenuItem class]])
		{
		[(NSMenuItem *)anItem setState:([pictureView imageScaling]==NSImageScaleNone)?NSOffState:NSOnState];
		}
	
	return [super validateUserInterfaceItem:anItem];
}

#pragma mark Window Delegate

- (NSRect)windowWillUseStandardFrame:(NSWindow *)aWindow defaultFrame:(NSRect)defaultFrame
{
	NSRect currentFrame = [aWindow frame];
	CGFloat oldHeight=currentFrame.size.height;
 
	currentFrame.size.width = currentFrame.size.width-[pictureView frame].size.width+[[pictureView image] size].width;
	currentFrame.size.height = currentFrame.size.height-[pictureView frame].size.height+[[pictureView image] size].height;
	currentFrame.origin.y = currentFrame.origin.y+oldHeight - currentFrame.size.height;
	return currentFrame;
}


@end
