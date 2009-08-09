//
//  UCFileList.m
//  Chain
//
//  Created by Christoph on 12.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UCFileList.h"


@implementation UCFileList

- (id)initForPath:(NSString *)aPath withTypes:(NSArray *)theTypes
{
	if(self=[self init])
		{
		BOOL isFolder;

		if(![[NSFileManager defaultManager] fileExistsAtPath:aPath isDirectory:&isFolder])
			{
			[self release];
			return nil;
			}

		if(isFolder)
			{
			folder = [aPath copy];
			}
		else
			{
			folder = [[aPath stringByDeletingLastPathComponent] retain];
			}

		filterTypes = [theTypes retain];
		
		NSWorkspace * ws = [NSWorkspace sharedWorkspace];
		NSArray * allFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folder error:NULL];

		NSUInteger i,j;
		NSUInteger typeCount=[filterTypes count];
		NSUInteger fileCount=[allFiles count];
		files = [[NSMutableArray alloc] initWithCapacity:fileCount];
		currentIndex = NSNotFound;
		NSString *file, *fileType, *testType, *fullFile;

		for(i=0; i<fileCount; i++)
			{
			file = (NSString *)[allFiles objectAtIndex:i];
			fullFile = [folder stringByAppendingPathComponent:file];
			fileType = [ws typeOfFile:fullFile error:NULL];
			
			for(j=0; j<typeCount; j++)
				{
				testType = (NSString *)[filterTypes objectAtIndex:j];
				if([ws type:fileType conformsToType:testType])
					{
					[files addObject:file];
					if([fullFile isEqualToString:aPath])
						{
						currentIndex = [files count]-1;
						}
					break;
					}
				}
			}

		if(isFolder && [files count])
			{
			currentIndex = 0;
			}
		}
		
	return self;
}

- (void) dealloc
{
	[files release];
	[folder release];
	[filterTypes release];
	[super dealloc];
}

#pragma mark -

- (NSString *)currentFile
{
	if(currentIndex==NSNotFound)
		{
		return nil;
		}
	return [folder stringByAppendingPathComponent:[files objectAtIndex:currentIndex]];
}

- (NSUInteger)count
{
	return [files count];
}

@synthesize folder=folder;
@synthesize currentIndex=currentIndex;

@end
