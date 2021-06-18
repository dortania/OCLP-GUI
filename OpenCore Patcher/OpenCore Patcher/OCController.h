//
//  OCController.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/7/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STPrivilegedTask.h"
#import "OCPatchHandler.h"
#import "OCDriveInfo.h"

@interface OCController : NSObject

+ (OCController *)sharedInstance;
-(HelperStatus)startBuildAndInstallToDrive:(OCDriveInfo *)drive;

@end
