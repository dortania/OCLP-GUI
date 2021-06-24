//
//  OCPatchHandler.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/16/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "OCPatchHandler.h"

@implementation OCPatchHandler

-(id)init {
    self = [super init];
    shouldKeepRunning = YES;
    DMOperationWait = NO;
    self.loggingClient = [[OCLoggingManagerClient alloc] init];
    return self;
}

-(void)startIPCService {
    if (setuid(0) != 0) {
        NSLog(@"Could not set UID");
    }
    connection = [[NSConnection alloc] init];
    [connection setRootObject:self];
    [connection registerName:@SERVER_ID];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    while (shouldKeepRunning && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

-(oneway void)terminateHelper {
    shouldKeepRunning = NO;
}

-(PatchHandlerResult)buildOpenCore {
    NSTask *OCPythonBin  = [[NSTask alloc] init];
    [OCPythonBin setLaunchPath:[self.resourcesPath stringByAppendingPathComponent:@MAIN_BINARY]];
    [OCPythonBin setArguments:[self.flagManager buildArgs]];
    [OCPythonBin setCurrentDirectoryPath:@OC_BUILD_PATH];
    [OCPythonBin setEnvironment:@{@"TERM": @"xterm", @"PATH":@"/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin", @"PYTHONIOENCODING": @"UTF-8"}];
    NSPipe *out = [NSPipe pipe];
    [OCPythonBin setStandardOutput:out];
    [OCPythonBin setStandardError:out];
    [self.loggingClient setOutputPipe:out];
    [OCPythonBin launch];
    [OCPythonBin waitUntilExit];
    NSInteger err = [OCPythonBin terminationStatus];
    if (err) {
        return PatchHandlerResultFailedOCBuild;
    }
    return PatchHandlerResultSuccess;
}

-(PatchHandlerResult)installOpenCoreToDrive:(OCDriveInfo *)drive {
    DMOperationWait = NO;
    NSFileManager *man = [NSFileManager defaultManager];
    if (![man fileExistsAtPath:@ESPMountPoint]) {
        [man createDirectoryAtPath:@ESPMountPoint withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [self.loggingClient addLogEntry:[NSString stringWithFormat:@"Mounting %@...", drive.esp.bsdName]];
    DMOperationWait = YES;
    [OCDriveManager sharedInstance].delegate = self;
    [[OCDriveManager sharedInstance] startDASession];
    [[OCDriveManager sharedInstance] mountDrive:drive.esp toPath:@ESPMountPoint];
    while(DMOperationWait) {
        sleep(0.5);
    }
    if (DMOperationReturn) {
        [[OCDriveManager sharedInstance] endDASession];
        return PatchHandlerResultFailedESPMount;
    }
    
    
    [self.loggingClient addLogEntry:@"Copying OpenCore Files..."];
    
    for (NSString *rootItem in [man contentsOfDirectoryAtPath:@OC_BUILD_PATH_OUT error:nil]) {
        BOOL isDirectory = NO;
        if ([man fileExistsAtPath:[@OC_BUILD_PATH_OUT stringByAppendingPathComponent:rootItem] isDirectory:&isDirectory]) {
            if (isDirectory) {
                if (![man fileExistsAtPath:[@ESPMountPoint stringByAppendingPathComponent:rootItem]]) {
                    [man createDirectoryAtPath:[@ESPMountPoint stringByAppendingPathComponent:rootItem] withIntermediateDirectories:YES attributes:nil error:nil];
                }
                for (NSString *item in [man contentsOfDirectoryAtPath:[@OC_BUILD_PATH_OUT stringByAppendingPathComponent:rootItem] error:nil]) {
                    if ([man fileExistsAtPath:[[@ESPMountPoint stringByAppendingPathComponent:rootItem] stringByAppendingPathComponent:item]]) {
                        [man removeItemAtPath:[[@ESPMountPoint stringByAppendingPathComponent:rootItem] stringByAppendingPathComponent:item] error:nil];
                    }
                    [man copyItemAtPath:[[@OC_BUILD_PATH_OUT stringByAppendingPathComponent:rootItem] stringByAppendingPathComponent:item] toPath:[[@ESPMountPoint stringByAppendingPathComponent:rootItem] stringByAppendingPathComponent:item] error:nil];
                }
            } else {
                if ([man fileExistsAtPath:[@ESPMountPoint stringByAppendingPathComponent:rootItem]]) {
                    [man removeItemAtPath:[@ESPMountPoint stringByAppendingPathComponent:rootItem] error:nil];
                }
                [man copyItemAtPath:[@OC_BUILD_PATH_OUT stringByAppendingPathComponent:rootItem] toPath:[@ESPMountPoint stringByAppendingPathComponent:rootItem] error:nil];
            }
        }
    }
    
    [self.loggingClient addLogEntry:[NSString stringWithFormat:@"Unmounting %@...", drive.esp.bsdName]];
    DMOperationWait = YES;
    [[OCDriveManager sharedInstance] unmountDrive:drive.esp];
    while(DMOperationWait) {
        sleep(0.5);
    }
    if (DMOperationReturn) {
        [[OCDriveManager sharedInstance] endDASession];
        return PatchHandlerResultFailedESPUnmount;
    }
    [[OCDriveManager sharedInstance] endDASession];
    [self.loggingClient addLogEntry:@"Done! Operation completed successfully."];
    return PatchHandlerResultSuccess;
}

-(PatchHandlerResult)patchSystemVolume {
    NSTask *OCPythonBin  = [[NSTask alloc] init];
    [OCPythonBin setLaunchPath:[self.resourcesPath stringByAppendingPathComponent:@MAIN_BINARY]];
    [OCPythonBin setArguments:[self.flagManager sysVolPatchArgs]];
    [OCPythonBin setCurrentDirectoryPath:@OC_BUILD_PATH];
    [OCPythonBin setEnvironment:@{@"TERM": @"xterm", @"PATH":@"/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin", @"PYTHONIOENCODING": @"UTF-8"}];
    NSPipe *out = [NSPipe pipe];
    [OCPythonBin setStandardOutput:out];
    [OCPythonBin setStandardError:out];
    [self.loggingClient setOutputPipe:out];
    [OCPythonBin launch];
    [OCPythonBin waitUntilExit];
    NSInteger err = [OCPythonBin terminationStatus];
    if (err) {
        return PatchHandlerResultFailedPatchSysVol;
    }
    [self.loggingClient addLogEntry:@"Done! Operation completed successfully."];
    return PatchHandlerResultSuccess;
}

#pragma mark Delegated Functions

-(void)drive:(OCDriveInfo *)drive wasMountedWithResult:(DMStatus)result {
    DMOperationWait = NO;
    DMOperationReturn = result;
}

-(void)drive:(OCDriveInfo *)drive wasUnmountedWithResult:(DMStatus)result {
    DMOperationWait = NO;
    DMOperationReturn = result;
}

@end
