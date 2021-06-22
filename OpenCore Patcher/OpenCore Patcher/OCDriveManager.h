//
//  OCDriveManager.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/9/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DiskArbitration/DiskArbitration.h>
#import "OCDriveInfo.h"

#define EXPECTED_BOOT_DISK_NUM 0

typedef enum {
    DMStatusSuccess = 0,
    DMStatusError = 1
}DMStatus;

@protocol OCDriveManagerDelegate <NSObject>
@optional
-(void)driveWasAttached:(OCDriveInfo *)drive;
-(void)driveWasDetached:(OCDriveInfo *)drive;
-(void)drive:(OCDriveInfo *)drive wasMountedWithResult:(DMStatus)result;
-(void)drive:(OCDriveInfo *)drive wasUnmountedWithResult:(DMStatus)result;
@end

@interface OCDriveManager : NSObject {
    DASessionRef session;
}

@property (strong) id <OCDriveManagerDelegate> delegate;

+ (OCDriveManager *)sharedInstance;
-(void)startDASession;
-(void)endDASession;
-(void)handleDriveAttached:(OCDriveInfo *)drive;
-(void)handleDriveDetached:(OCDriveInfo *)drive;
-(void)handleDrive:(OCDriveInfo *)drive mountedWithResult:(DMStatus)result;
-(void)handleDrive:(OCDriveInfo *)drive unmountedWithResult:(DMStatus)result;
-(void)mountDrive:(OCDriveInfo *)drive toPath:(NSString *)mntPath;
-(void)unmountDrive:(OCDriveInfo *)drive;

@end
