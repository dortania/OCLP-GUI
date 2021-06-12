//
//  MainMenuViewController.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/12/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "WindowContentViewController.h"
#import "OCController.h"
#import "DriveSelectionViewController.h"
#import "OCInstallationViewController.h"

@interface MainMenuViewController : WindowContentViewController <DriveSelectionViewDelegate> {
    DriveSelectionViewController *driveSelectionView;
}

@property (strong) IBOutlet NSPopover *driveSelectionViewPopover;
- (IBAction)startBuildAndInstall:(id)sender;

@end
