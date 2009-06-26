//
//  UCFileList.h
//  Chain
//
//  Created by Christoph on 12.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface UCFileList : NSObject
{
	NSString * folder;
	NSArray * filterTypes;
	NSMutableArray * files;
}

- (id)initForFolder:(NSString *)aFolder withTypes:(NSArray *)theTypes;

@property(readonly) NSUInteger count;

@end
