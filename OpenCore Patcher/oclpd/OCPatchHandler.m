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
    self.loggingClient = [[OCLoggingManagerClient alloc] init];
    return self;
}

-(void)startIPCService {
    connection = [[NSConnection alloc] init];
    [connection setRootObject:self];
    [connection registerName:@SERVER_ID];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    while (shouldKeepRunning && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

-(oneway void)terminateHelper {
    shouldKeepRunning = NO;
}

-(NSInteger)buildOpenCoreAtPath:(NSString *)buildPath {
    NSTask *OCPythonBin  = [[NSTask alloc] init];
    [OCPythonBin setLaunchPath:[self.resourcesPath stringByAppendingPathComponent:@MAIN_BINARY]];
    [OCPythonBin setArguments:[self.flagManager buildArgs]];
    [OCPythonBin setCurrentDirectoryPath:@OC_BUILD_PATH];
    [OCPythonBin setEnvironment:@{@"TERM": @"xterm", @"PATH":@"/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin"}];
    NSPipe *out = [NSPipe pipe];
    [OCPythonBin setStandardOutput:out];
    [OCPythonBin setStandardError:out];
    [self.loggingClient setOutputPipe:out];
    [OCPythonBin launch];
    [OCPythonBin waitUntilExit];
    NSInteger err = [OCPythonBin terminationStatus];
    
    return err;
}

-(NSInteger)installOpenCoreAtPath:(NSString *)buildPath toDrive:(OCDriveInfo *)drive {
    return 0;
}

@end
