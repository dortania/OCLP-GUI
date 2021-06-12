//
//  WindowContentViewController.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/12/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol WindowContentViewControllerDelegate;


@interface WindowContentViewController : NSViewController

@property (strong) id <WindowContentViewControllerDelegate> delegate;

@end


@protocol WindowContentViewControllerDelegate <NSObject>

-(void)setWindowVisibleViewController:(WindowContentViewController *)controller;

@end
