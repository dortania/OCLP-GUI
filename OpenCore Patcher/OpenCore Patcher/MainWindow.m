//
//  MainWindow.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/7/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "MainWindow.h"

@interface MainWindow ()

@end

@implementation MainWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    if (!visibleViewController) {
        visibleViewController = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
        visibleViewController.delegate = self;
    }
    
    [self.window.contentView addSubview:visibleViewController.view];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

#pragma mark Delegated Functions

-(void)setWindowVisibleViewController:(WindowContentViewController *)controller {
    [visibleViewController.view removeFromSuperview];
    //[self.window.contentView replaceSubview:visibleViewController.view with:controller.view];
    CGFloat windowTitleHeight = self.window.frame.size.height - visibleViewController.view.frame.size.height;
    NSRect frame = self.window.frame;
    frame.size.height = controller.view.frame.size.height + windowTitleHeight;
    frame.origin.y = frame.origin.y - (controller.view.frame.size.height - self.window.frame.size.height + windowTitleHeight);
    [self.window setFrame:frame display:YES animate:YES];
    [self.window.contentView addSubview:controller.view];
    visibleViewController = controller;
    visibleViewController.delegate = self;
}


@end
