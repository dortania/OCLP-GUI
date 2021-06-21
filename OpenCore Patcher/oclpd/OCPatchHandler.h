//
//  OCPatchHandler.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/16/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCDriveInfo.h"
#import "OCLoggingManagerClient.h"
#import "OCFlagManager.h"

#define SERVER_ID "org.dortania.OpenCore-Patcher"
#define MAIN_BINARY "OCLP-CLI"
#define OC_BUILD_PATH "/private/var/tmp"
#define OC_BUILD_PATH_OUT "/private/var/tmp/Build-Folder"


@interface OCPatchHandler : NSObject {
    NSConnection *connection;
    BOOL shouldKeepRunning;
}

@property (nonatomic, strong) OCFlagManager *flagManager;
@property (nonatomic, strong) OCLoggingManagerClient *loggingClient;
@property (nonatomic, strong) NSString *resourcesPath;

-(id)init;
-(void)startIPCService;
-(oneway void)terminateHelper;
-(NSInteger)buildOpenCoreAtPath:(NSString *)buildPath;
-(NSInteger)installOpenCoreAtPath:(NSString *)buildPath toDrive:(OCDriveInfo *)drive;

@end
