//
//  DriveSelectionItem.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/8/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "DriveSelectionItem.h"

@interface DriveSelectionItem ()

@end

@implementation DriveSelectionItem

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setRepresentedObject:(id)representedObject {
    [self.view setWantsLayer:YES];
    if (representedObject) {
        driveInfo = (OCDriveInfo *)representedObject;
        NSImage *img = [[NSBundle bundleWithPath:[driveInfo iconBundlePath]] imageForResource:[driveInfo iconName]];
        [self.driveSelectionImage setImage:img];
        [self.driveSelectionNameField setStringValue:[driveInfo name]];
    }
}

-(void)setSelected:(BOOL)selected {
    if (selected) {
        [self.selectionIndicatorBox setTransparent:NO];
    } else {
        [self.selectionIndicatorBox setTransparent:YES];
    }
    [super setSelected:selected];
}

@end
