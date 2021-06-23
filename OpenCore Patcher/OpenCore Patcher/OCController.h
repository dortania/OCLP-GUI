//
//  OCController.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/7/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/sysctl.h>
#import "STPrivilegedTask.h"
#import "OCPatchHandler.h"
#import "OCDriveInfo.h"
#import "OCLoggingManager.h"
#import "nvram.h"

#define MacModelsPlist "macModels.plist"
#define kNVRAMMacModel "4D1FDA02-38C7-4A6A-9CC6-4BCCA8B30102:oem-product"

@protocol OCControllerDelegate <NSObject>

-(void)helperFailedLaunchWithError:(OSStatus)err;
-(void)helperFinishedProcessWithResult:(PatchHandlerResult)status;

@end

@interface OCController : NSObject

@property (strong) id <OCControllerDelegate> delegate;

+ (OCController *)sharedInstance;
-(void)startBuildAndInstallToDrive:(OCDriveInfo *)drive;
-(void)startSystemVolumePatching;
-(NSArray *)getMacModelsList;
-(NSString *)getMachineModel;

@end
