//
//  UCFileList.m
//  Chain
//
//  Created by Christoph on 12.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UCFileList.h"


@implementation UCFileList

- (id)initForFolder:(NSString *)aFolder withTypes:(NSArray *)theTypes
{
	if(self=[self init])
		{
		folder = [aFolder retain];
		filterTypes = [theTypes retain];
		
		BOOL isFolder;
		NSWorkspace * ws = [NSWorkspace sharedWorkspace];
		
		NSArray * allFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folder error:NULL];

		NSUInteger i,j;
		NSUInteger typeCount=[filterTypes count];
		NSUInteger fileCount=[allFiles count];
		files = [[NSMutableArray alloc] initWithCapacity:fileCount];
		NSString *file, *fileType, *testType;

		for(i=0; i<fileCount; i++)
			{
			file = (NSString *)[allFiles objectAtIndex:i];
			fileType = [ws typeOfFile:[folder stringByAppendingPathComponent:file] error:NULL];
			
			for(j=0; j<typeCount; j++)
				{
				testType = (NSString *)[filterTypes objectAtIndex:j];
				if([ws type:fileType conformsToType:testType])
					{
					[files addObject:file];
					break;
					}
				}
			
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

- (NSUInteger)count
{
	return [files count];
}

@end
