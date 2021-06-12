//
//  AppDelegate.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/7/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if ([[OCController sharedInstance] python3IsInstalled]) {
        if (!mw) {
            mw = [[MainWindow alloc] initWithWindowNibName:@"MainWindow"];
        }
        [mw showWindow:self];
    } else {
        [[OCErrorHandler sharedInstance] handleApplicationError:ApplicationErrorNoPython];
        [[NSApplication sharedApplication] terminate:nil];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
