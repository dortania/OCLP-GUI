//
//  DriveSelectionCollectionView.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/11/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "DriveSelectionCollectionView.h"

@implementation DriveSelectionCollectionView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)setContent:(NSArray *)content {

    /* NSCollectionView "deselect all" workaround */
    [self setValue:[[NSMutableIndexSet alloc] init] forKey:@"_selectionIndexes"];
    
    [super setContent:content];
}


@end
