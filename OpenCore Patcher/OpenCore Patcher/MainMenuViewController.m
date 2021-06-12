//
//  MainMenuViewController.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/12/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)awakeFromNib {
    if (!driveSelectionView) {
        driveSelectionView = [[DriveSelectionViewController alloc] initWithNibName:@"DriveSelectionViewController" bundle:nil];
        driveSelectionView.delegate = self;
    }
    [self.driveSelectionViewPopover setContentViewController:driveSelectionView];
    [self.driveSelectionViewPopover setDelegate:driveSelectionView];
}

- (IBAction)startBuildAndInstall:(id)sender {
    [self.driveSelectionViewPopover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
}

#pragma mark Delegated Functions

-(void)viewChangedToWidth:(CGFloat)width {
    [self.driveSelectionViewPopover setContentSize:CGSizeMake(width, driveSelectionView.view.frame.size.height)];
}

-(void)beginInstallOnDrive:(OCDriveInfo *)drive {
    [self.delegate setWindowVisibleViewController:[[OCInstallationViewController alloc] initWithNibName:@"OCInstallationViewController" bundle:nil]];
}

@end
