//
//  UCTableView.m
//  Chain
//
//  Created by Christoph on 13.06.2009.
//  Copyright 2009 Useless Coding. All rights reserved.
//

#import "UCTableView.h"


@implementation UCTableView

- (void)keyDown:(NSEvent *)theEvent
{
	if([[theEvent charactersIgnoringModifiers] length])
		{
		unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];

		if(key==NSDeleteFunctionKey || key==NSDeleteCharacter || key==NSDeleteCharFunctionKey)
			{
			[self doCommandBySelector:@selector(delete:)];
			return;
			}
		}
	[super keyDown:theEvent];
}

- (IBAction)delete:(id)sender
{
	id ds = [self dataSource];
	if([self selectedRow]!=-1 && [ds respondsToSelector:@selector(tableView:deleteRowsWithIndexes:)])
		{
		[ds tableView:self deleteRowsWithIndexes:[self selectedRowIndexes]];
		[self deselectAll:self];
		[self reloadData];
		}
}

- (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem
{
	if([anItem action]==@selector(delete:))
		{
		return [self selectedRow]!=-1;
		}
	return [super validateUserInterfaceItem:anItem];
}


@end

@implementation NSObject (UCTableViewDataSource)

- (void)tableView:(UCTableView *)aTableView deleteRowsWithIndexes:(NSIndexSet *)rowIndexes
{
}

@end
