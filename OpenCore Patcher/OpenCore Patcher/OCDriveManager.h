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

@protocol OCDriveManagerDelegate <NSObject>

-(void)driveWasAttached:(OCDriveInfo *)drive;
-(void)driveWasDetached:(OCDriveInfo *)drive;

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

@end
