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

void DADiskMounted(DADiskRef disk, DADissenterRef dissenter, void *context) {
    DMStatus status = DMStatusSuccess;
    if (dissenter) {
        status = DMStatusError;
    }
    OCDriveInfo *inf = [[OCDriveInfo alloc] initWithDiskRef:disk];
    [[OCDriveManager sharedInstance] handleDrive:inf mountedWithResult:status];
}

void DADiskUnmounted(DADiskRef disk, DADissenterRef dissenter, void *context) {
    DMStatus status = DMStatusSuccess;
    if (dissenter) {
        status = DMStatusError;
    }
    OCDriveInfo *inf = [[OCDriveInfo alloc] initWithDiskRef:disk];
    [[OCDriveManager sharedInstance] handleDrive:inf unmountedWithResult:status];
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
-(OCDriveInfo *)getESPForDrive:(OCDriveInfo *)drive {
    NSString *ESPBSD = [NSString stringWithFormat:@"%@s%d", drive.bsdName, EXPECTED_ESP_NUM];
    DADiskRef ESP = DADiskCreateFromBSDName(kCFAllocatorDefault, session, [ESPBSD UTF8String]);
    NSDictionary *espInfo = (__bridge NSDictionary *)DADiskCopyDescription(ESP);
    if ([espInfo objectForKey:@"DAMediaName"]) {
        NSString *mediaName = [espInfo objectForKey:@"DAMediaName"];
        if ([mediaName isEqualToString:@"EFI System Partition"]) {
            return [[OCDriveInfo alloc]
                         initWithDiskRef:ESP];
        }
    }
    return nil;
}
-(void)handleDriveAttached:(OCDriveInfo *)drive {
    drive.esp = [self getESPForDrive:drive];
    if ([self.delegate respondsToSelector:@selector(driveWasAttached:)]) {
        [self.delegate driveWasAttached:drive];
    }
}
-(void)handleDriveDetached:(OCDriveInfo *)drive {
    if ([self.delegate respondsToSelector:@selector(driveWasDetached:)]) {
        [self.delegate driveWasDetached:drive];
    }
}
-(void)handleDrive:(OCDriveInfo *)drive mountedWithResult:(DMStatus)result {
    if ([self.delegate respondsToSelector:@selector(drive:wasMountedWithResult:)]) {
        [self.delegate drive:drive wasMountedWithResult:result];
    }
}
-(void)handleDrive:(OCDriveInfo *)drive unmountedWithResult:(DMStatus)result {
    if ([self.delegate respondsToSelector:@selector(drive:wasUnmountedWithResult:)]) {
        [self.delegate drive:drive wasUnmountedWithResult:result];
    }
}
-(void)mountDrive:(OCDriveInfo *)drive toPath:(NSString *)mntPath {
    DADiskRef disk = DADiskCreateFromBSDName(kCFAllocatorDefault, session, [drive.bsdName UTF8String]);
    CFStringRef args[2];
    args[0] = CFSTR("nobrowse");
    args[1] = nil;
    DADiskMountWithArguments(disk, (__bridge CFURLRef)([NSURL URLWithString:mntPath]), kDADiskMountOptionDefault, DADiskMounted, nil, args);
}
-(void)unmountDrive:(OCDriveInfo *)drive {
    DADiskRef disk = DADiskCreateFromBSDName(kCFAllocatorDefault, session, [drive.bsdName UTF8String]);
    DADiskUnmount(disk, kDADiskUnmountOptionDefault, DADiskUnmounted, nil);
}
@end
