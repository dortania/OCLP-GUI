//
//  DriveSelectionViewController.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/8/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DriveSelectionCollectionView.h"
#import "OCDriveManager.h"
#import "DriveSelectionItem.h"

@protocol DriveSelectionViewDelegate <NSObject>

-(void)viewChangedToWidth:(CGFloat)width;
-(void)beginInstallOnDrive:(OCDriveInfo *)drive;

@end

@interface DriveSelectionViewController : NSViewController <NSPopoverDelegate, OCDriveManagerDelegate> {
    NSMutableArray *availableDrives;
}
@property (strong) id <DriveSelectionViewDelegate> delegate;

@property (strong) IBOutlet DriveSelectionCollectionView *driveSelectionCollectionView;
- (IBAction)beginInstallationToSelectedDrive:(id)sender;

@end
