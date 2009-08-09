//
//  UCFileList.h
//  Chain
//
//  Created by Christoph on 12.06.09.
//  Copyright Useless Coding 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface UCFileList : NSObject
{
	NSString * folder;
	NSArray * filterTypes;
	NSMutableArray * files;
	NSUInteger currentIndex;
}

- (id)initForPath:(NSString *)aFolder withTypes:(NSArray *)theTypes;

- (NSString *)currentFile;

@property NSUInteger currentIndex;
@property(readonly) NSUInteger count;
@property(readonly) NSString * folder;

@end
