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
#import "FlagsViewController.h"

@interface MainMenuViewController : WindowContentViewController <DriveSelectionViewDelegate, FlagsViewDelegate> {
    DriveSelectionViewController *driveSelectionView;
    FlagsViewController *flagsView;
}

@property (strong) IBOutlet NSPopover *driveSelectionViewPopover;
@property (strong) IBOutlet NSPopover *flagsViewPopover;
@property (strong) IBOutlet NSTextField *versionField;

- (IBAction)startBuildAndInstall:(id)sender;
- (IBAction)startPatchSystemVolume:(id)sender;
- (IBAction)showFlagsView:(id)sender;

@end
