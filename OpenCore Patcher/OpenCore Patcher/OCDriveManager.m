//
//  OCDriveManager.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/9/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "OCDriveManager.h"

void DADiskAttached(DADiskRef disk, void *context) {
    
    OCDriveInfo *inf = [[OCDriveInfo alloc] initWithDiskRef:disk];
    if (inf.physical) {
        [[[OCDriveManager sharedInstance] delegate] driveWasAttached:inf];
    }
}

void DADiskDetached(DADiskRef disk, void *context) {
    
    OCDriveInfo *inf = [[OCDriveInfo alloc] initWithDiskRef:disk];
    [[[OCDriveManager sharedInstance] delegate] driveWasDetached:inf];
}

@implementation OCDriveManager

+ (OCDriveManager *)sharedInstance {
    static OCDriveManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)startDASession {
    if (!session) {
        session = DASessionCreate(kCFAllocatorDefault);
    }
    DASessionSetDispatchQueue(session, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    DARegisterDiskAppearedCallback(session, kDADiskDescriptionMatchMediaWhole, DADiskAttached, nil);
    DARegisterDiskDisappearedCallback(session, kDADiskDescriptionMatchMediaWhole, DADiskDetached, nil);
}
-(void)endDASession {
    DASessionSetDispatchQueue(session, NULL);
    CFRelease(session);
    session = nil;
}

@end
