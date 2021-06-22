//
//  DriveSelectionViewController.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/8/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "DriveSelectionViewController.h"

@interface DriveSelectionViewController ()

@end

@implementation DriveSelectionViewController


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    availableDrives = [[NSMutableArray alloc] init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)awakeFromNib {
    [OCDriveManager sharedInstance].delegate = self;
    DriveSelectionItem *itm = [[DriveSelectionItem alloc] initWithNibName:@"DriveSelectionItem" bundle:nil];
    [self.driveSelectionCollectionView setItemPrototype:itm];
}

-(void)adaptViewSize {
    if (availableDrives.count > 2 && availableDrives.count < 6) {
        CGFloat width = [self.driveSelectionCollectionView itemPrototype].view.frame.size.width * availableDrives.count;
        if (width > [[NSScreen mainScreen] frame].size.width) {
            width = [[NSScreen mainScreen] frame].size.width - 100;
        }
        [self.delegate DriveSelectionViewChangedToWidth:width];
    }
}

#pragma mark Delegated Functions


- (void)popoverDidShow:(NSNotification *)notification {
    [availableDrives removeAllObjects];
    [[OCDriveManager sharedInstance] startDASession];
}
-(void)popoverDidClose:(NSNotification *)notification {
    [[OCDriveManager sharedInstance] endDASession];
}

-(void)driveWasAttached:(OCDriveInfo *)drive {
    if (drive.physical && drive.esp) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [availableDrives addObject:drive];
            [self.driveSelectionCollectionView setContent:availableDrives];
            [self adaptViewSize];
            
        });
    }
}

-(void)driveWasDetached:(OCDriveInfo *)drive {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [availableDrives removeObject:drive];
        [self.driveSelectionCollectionView setContent:availableDrives];
        [self adaptViewSize];
    });
}

- (IBAction)beginInstallationToSelectedDrive:(id)sender {
    if ([self.driveSelectionCollectionView selectionIndexes].count > 0) {
        [self.delegate beginInstallOnDrive:[availableDrives objectAtIndex:[[self.driveSelectionCollectionView selectionIndexes] firstIndex]]];
    }
}
@end
