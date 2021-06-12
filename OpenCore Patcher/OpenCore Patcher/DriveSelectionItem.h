//
//  DriveSelectionItem.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/8/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OCDriveInfo.h"

@interface DriveSelectionItem : NSCollectionViewItem {
    OCDriveInfo *driveInfo;
}

@property (strong) IBOutlet NSBox *selectionIndicatorBox;
-(void)setRepresentedObject:(id)representedObject;
@property (strong) IBOutlet NSImageView *driveSelectionImage;
@property (strong) IBOutlet NSTextField *driveSelectionNameField;

@end
