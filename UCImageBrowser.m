//
//  MyDocument.m
//  Chain
//
//  Created by Christoph on 11.06.09.
//  Copyright __MyCompanyName__ 2009 . All rights reserved.
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
//	[pictureView setImage:[[[NSImage alloc] initWithContentsOfURL:[self fileURL]] autorelease]];
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

#pragma mark Actions

- (void)invertImage:(id)sender
{
}

@end
