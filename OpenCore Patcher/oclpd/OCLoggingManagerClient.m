//
//  OCLoggingManagerClient.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/20/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "OCLoggingManagerClient.h"

@implementation OCLoggingManagerClient

+ (OCLoggingManagerClient *)sharedInstance {
    static OCLoggingManagerClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
-(void)setOutputPipe:(NSPipe *)pipe
{
    NSPipe *out = pipe;
    NSFileHandle *fh = [out fileHandleForReading];
    [fh waitForDataInBackgroundAndNotify];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedInfo:) name:NSFileHandleDataAvailableNotification object:fh];
}

- (void)receivedInfo:(NSNotification *)notification
{
    NSFileHandle *fh = [notification object];
    NSData *data = [fh availableData];
    if (data.length > 0)
    {
        [fh waitForDataInBackgroundAndNotify];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self.delegate logDidUpdateWithText:str];
    }
}

-(void)addLogEntry:(NSString *)text {
    [self.delegate logDidUpdateWithText:[NSString stringWithFormat:@"%@\n", text]];
}

@end
