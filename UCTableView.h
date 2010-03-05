//
//  UCTableView.h
//  Chain
//
//  Created by Christoph on 13.06.2009.
//  Copyright 2009 Useless Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface UCTableView : NSTableView
{

}

- (IBAction)delete:(id)sender;

@end

@interface NSObject (UCTableViewDataSource)

- (void)tableView:(UCTableView *)aTableView deleteRowsWithIndexes:(NSIndexSet *)rowIndexes;

@end
