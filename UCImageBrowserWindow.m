//
//  UCImageBrowserWindow.m
//  Chain
//
//  Created by Christoph on 05.03.2010.
//  Copyright 2010 Useless Coding. All rights reserved.
//

#import "UCImageBrowserWindow.h"


@implementation UCImageBrowserWindow


- (void)setImage:(NSImage *)image
{
	[pictureView setImage:image];
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
	
	return YES;
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
