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
    [[OCDriveManager sharedInstance] handleDriveAttached:inf];
}

void DADiskDetached(DADiskRef disk, void *context) {
    
    OCDriveInfo *inf = [[OCDriveInfo alloc] initWithDiskRef:disk];
    [[OCDriveManager sharedInstance] handleDriveDetached:inf];
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
    if (session) {
        DASessionSetDispatchQueue(session, NULL);
        CFRelease(session);
        session = nil;
    }
}
-(void)handleDriveAttached:(OCDriveInfo *)drive {
    NSString *ESPBSD = [NSString stringWithFormat:@"%@s%d", drive.bsdName, EXPECTED_ESP_NUM];
    DADiskRef ESP = DADiskCreateFromBSDName(kCFAllocatorDefault, session, [ESPBSD UTF8String]);
    NSDictionary *espInfo = (__bridge NSDictionary *)DADiskCopyDescription(ESP);
    if ([espInfo objectForKey:@"DAMediaName"]) {
        NSString *mediaName = [espInfo objectForKey:@"DAMediaName"];
        drive.hasESP = [mediaName isEqualToString:@"EFI System Partition"];
    }
    [self.delegate driveWasAttached:drive];
}
-(void)handleDriveDetached:(OCDriveInfo *)drive {
    [self.delegate driveWasDetached:drive];
}
-(OCDriveInfo *)getBootDrive {
    DADiskRef bootDisk = DADiskCreateFromBSDName(kCFAllocatorDefault, session, [[NSString stringWithFormat:@"%d", EXPECTED_BOOT_DISK_NUM] UTF8String]);
    return [[OCDriveInfo alloc] initWithDiskRef:bootDisk];
}
@end
