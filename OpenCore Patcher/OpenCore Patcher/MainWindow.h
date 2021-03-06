//
//  MainWindow.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/7/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainMenuViewController.h"
#import "OCInstallationViewController.h"
#import "OCErrorHandler.h"

@interface MainWindow : NSWindowController <WindowContentViewControllerDelegate, OCErrorHandlerDelegate> {
    WindowContentViewController *visibleViewController;
}





@end
