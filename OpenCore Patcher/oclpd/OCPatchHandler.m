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

@end
