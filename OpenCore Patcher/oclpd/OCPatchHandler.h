//
//  OCPatchHandler.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/16/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCDriveManager.h"
#import "OCLoggingManagerClient.h"
#import "OCFlagManager.h"

#define SERVER_ID "org.dortania.OpenCore-Patcher"
#define MAIN_BINARY "OCLP-CLI"
#define OC_BUILD_PATH "/private/tmp"
#define OC_BUILD_PATH_OUT "/private/tmp/Build-Folder/OpenCore-RELEASE"
#define ESPMountPoint "/private/tmp/esp"

typedef enum {
    PatchHandlerResultSuccess = 0,
    PatchHandlerResultFailedESPMount = 1,
    PatchHandlerResultFailedESPUnmount = 2,
    PatchHandlerResultFailedOCBuild = 3,
    PatchHandlerResultFailedPatchSysVol = 4
}PatchHandlerResult;

@interface OCPatchHandler : NSObject <OCDriveManagerDelegate> {
    NSConnection *connection;
    BOOL shouldKeepRunning;
    BOOL DMOperationWait;
    DMStatus DMOperationReturn;
}

@property (nonatomic, strong) OCFlagManager *flagManager;
@property (nonatomic, strong) OCLoggingManagerClient *loggingClient;
@property (nonatomic, strong) NSString *resourcesPath;

-(id)init;
-(void)startIPCService;
-(oneway void)terminateHelper;
-(PatchHandlerResult)buildOpenCore;
-(PatchHandlerResult)installOpenCoreToDrive:(OCDriveInfo *)drive;
-(PatchHandlerResult)patchSystemVolume;

@end
