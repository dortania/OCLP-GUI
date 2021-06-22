//
//  OCInstallationViewController.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/12/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "WindowContentViewController.h"
#import "MainMenuViewController.h"
#import "OCController.h"
#import "OCLoggingManager.h"
#import "OCErrorHandler.h"

@interface OCInstallationViewController : WindowContentViewController <OCLoggingManagerDelegate, OCControllerDelegate>

@property (strong) IBOutlet NSButton *quitButton;
@property (strong) IBOutlet NSButton *mainMenuButton;
@property (strong) IBOutlet NSTextView *logTextView;
@property (strong) IBOutlet NSProgressIndicator *progressIndicator;

- (IBAction)returnToMain:(id)sender;
- (IBAction)quitApp:(id)sender;

-(void)beginInstallationOnDrive:(OCDriveInfo *)drive;
-(void)beginPatchingSystemVolume;

@end
