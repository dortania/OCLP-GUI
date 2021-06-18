//
//  OCController.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/7/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "OCController.h"



@implementation OCController

+ (OCController *)sharedInstance {
    static OCController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(id)init {
    self = [super init];
    return self;
}

-(HelperStatus)startBuildAndInstallToDrive:(OCDriveInfo *)drive {
    NSLog(@"Initializing Patch Handler");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STPrivilegedTask *t = [[STPrivilegedTask alloc] initWithLaunchPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"oclpd"]];
        OSStatus err = [t launch];
        if (err != errAuthorizationSuccess) {
            dispatch_async (dispatch_get_main_queue(), ^{
                //[self.delegate helperFailedLaunchWithError:err];
            });
        }
        else {
            sleep(1);
            OCPatchHandler *ph = (OCPatchHandler *)[NSConnection rootProxyForConnectionWithRegisteredName:@SERVER_ID host:nil];
            //ph.delegate = self;
            //[ph setPatcherFlagsObject:[PatcherFlags sharedInstance]];
            
            //[[CatalinaPatcherLoggingManager sharedInstance] resetLog];
            //int ret = [ph createPatchedInstallerAppAtPath:targetPatchedAppPath usingResources:[[NSBundle mainBundle] resourcePath] fromBaseApp:installerAppPath];
            [ph terminateHelper];
            NSLog(@"Done");
        }
    });
    return HelperStatusSuccess;
}

@end
