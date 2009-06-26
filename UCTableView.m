//
//  UCTableView.m
//  Chain
//
//  Created by Robert on 13.06.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UCTableView.h"


@implementation UCTableView

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