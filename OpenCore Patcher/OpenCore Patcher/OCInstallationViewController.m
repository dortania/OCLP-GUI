//
//  OCInstallationViewController.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/12/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "OCInstallationViewController.h"

@interface OCInstallationViewController ()

@end

@implementation OCInstallationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)awakeFromNib {
    [OCLoggingManager sharedInstance].delegate = self;
    [OCController sharedInstance].delegate = self;
    [self.logTextView setFont:[NSFont fontWithName:@"Courier" size:12]];
}

-(void)disableUI {
    [self.progressIndicator setHidden:NO];
    [self.progressIndicator startAnimation:self];
    [self.quitButton setEnabled:NO];
    [self.mainMenuButton setEnabled:NO];
}

-(void)enableUI {
    [self.progressIndicator setHidden:YES];
    [self.progressIndicator stopAnimation:self];
    [self.quitButton setEnabled:YES];
    [self.mainMenuButton setEnabled:YES];
}

- (IBAction)returnToMain:(id)sender {
    [self.delegate setWindowVisibleViewController:[[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil]];
}

- (IBAction)quitApp:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}

-(void)beginInstallationOnDrive:(OCDriveInfo *)drive {
    [self disableUI];
    [[OCController sharedInstance] startBuildAndInstallToDrive:drive];
    [[OCLoggingManager sharedInstance] resetLog];
    [self.logTextView setString:[OCLoggingManager sharedInstance].log];
}

-(void)beginPatchingSystemVolume {
    [self disableUI];
    [[OCController sharedInstance] startSystemVolumePatching];
    [[OCLoggingManager sharedInstance] resetLog];
    [self.logTextView setString:[OCLoggingManager sharedInstance].log];
}

#pragma mark Delegated Functions

-(void)helperFailedLaunchWithError:(OSStatus)err {
    switch (err) {
        case errAuthorizationCanceled:
            [self enableUI];
            [self returnToMain:self];
            break;
            
        default:
            [[OCErrorHandler sharedInstance] handleApplicationError:ApplicationErrorHelperLaunchFailed];
            break;
    }
}

-(void)helperFinishedProcessWithResult:(PatchHandlerResult)status {
    [[OCErrorHandler sharedInstance] handleHelperError:status];
    [self enableUI];
}

-(void)logDidUpdateWithText:(NSString *)text {
    [self.logTextView setString:text];
    [self.logTextView scrollToEndOfDocument:self];
}

@end
