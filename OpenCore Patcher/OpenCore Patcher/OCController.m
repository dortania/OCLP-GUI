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
    [OCFlagManager sharedInstance].targetModel = [self getMachineModel];
    [OCFlagManager sharedInstance].machineModel = [self getMachineModel];
    return self;
}

-(void)startBuildAndInstallToDrive:(OCDriveInfo *)drive {
    NSLog(@"Initializing OC Daemon");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STPrivilegedTask *t = [[STPrivilegedTask alloc] initWithLaunchPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"oclpd"]];
        OSStatus err = [t launch];
        if (err != errAuthorizationSuccess) {
            dispatch_async (dispatch_get_main_queue(), ^{
                [self.delegate helperFailedLaunchWithError:err];
            });
        }
        else {
            sleep(1);
            OCPatchHandler *ph = (OCPatchHandler *)[NSConnection rootProxyForConnectionWithRegisteredName:@SERVER_ID host:nil];
            ph.flagManager = [OCFlagManager sharedInstance];
            ph.resourcesPath = [[NSBundle mainBundle] resourcePath];
            ph.loggingClient.delegate = [OCLoggingManager sharedInstance];
            PatchHandlerResult res = [ph buildOpenCore];
            if (res) {
                [ph terminateHelper];
                dispatch_async (dispatch_get_main_queue(), ^{
                    [self.delegate helperFinishedProcessWithResult:res];
                });
            }
            res = [ph installOpenCoreToDrive:drive];
            
            [ph terminateHelper];
            NSLog(@"Done");
            
            dispatch_async (dispatch_get_main_queue(), ^{
                [self.delegate helperFinishedProcessWithResult:res];
            });
            
        }
    });
}
-(void)startSystemVolumePatching {
    NSLog(@"Initializing OC Daemon");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STPrivilegedTask *t = [[STPrivilegedTask alloc] initWithLaunchPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"oclpd"]];
        OSStatus err = [t launch];
        if (err != errAuthorizationSuccess) {
            dispatch_async (dispatch_get_main_queue(), ^{
                [self.delegate helperFailedLaunchWithError:err];
            });
        }
        else {
            sleep(1);
            OCPatchHandler *ph = (OCPatchHandler *)[NSConnection rootProxyForConnectionWithRegisteredName:@SERVER_ID host:nil];
            ph.flagManager = [OCFlagManager sharedInstance];
            ph.resourcesPath = [[NSBundle mainBundle] resourcePath];
            ph.loggingClient.delegate = [OCLoggingManager sharedInstance];
            PatchHandlerResult res = [ph patchSystemVolume];
            
            [ph terminateHelper];
            NSLog(@"Done");
            
            dispatch_async (dispatch_get_main_queue(), ^{
                [self.delegate helperFinishedProcessWithResult:res];
            });
            
        }
    });
}
-(NSArray *)getMacModelsList {
    return [[NSArray alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@MacModelsPlist]];
}
-(NSString *)getMachineModel {
    NSString *macModel=@"";
    size_t len=0;
    sysctlbyname("hw.model", nil, &len, nil, 0);
    if (len)
    {
        char *model = malloc(len*sizeof(char));
        sysctlbyname("hw.model", model, &len, nil, 0);
        macModel=[NSString stringWithFormat:@"%s", model];
        free(model);
    }
    return macModel;
}

@end
