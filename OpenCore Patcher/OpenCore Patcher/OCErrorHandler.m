//
//  OCErrorHandler.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/7/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "OCErrorHandler.h"

@implementation OCErrorHandler

-(id)init {
    self = [super init];
    return self;
}

+ (OCErrorHandler *)sharedInstance {
    static OCErrorHandler *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)displayAlertWithMessage:(NSString *)msg inlcudingInfo:(NSString *)info {
    if (!self.delegate) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSCriticalAlertStyle];
        [alert setMessageText:msg];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
    } else {
        [self.delegate displayAlertWithMessage:msg andInfo:info];
    }
}

-(void)handleApplicationError:(ApplicationError)err {
    switch (err) {
        case ApplicationErrorHelperLaunchFailed:
            [self displayAlertWithMessage:NSLocalizedString(@"ERR_HELPER_MSG", nil) inlcudingInfo:NSLocalizedString(@"ERR_HELPER_INFO", nil)];
            break;
            
        default:
            [self displayAlertWithMessage:NSLocalizedString(@"ERR_UNKNOWN_MSG", nil) inlcudingInfo:NSLocalizedString(@"ERR_UNKNOWN_INFO", nil)];
            break;
    }
}

-(void)handleHelperError:(PatchHandlerResult)result {
    switch (result) {
        case PatchHandlerResultFailedESPMount:
            [self displayAlertWithMessage:NSLocalizedString(@"ERR_MOUNT_ESP_MSG", nil) inlcudingInfo:NSLocalizedString(@"ERR_MOUNT_ESP_INFO", nil)];
            break;
        case PatchHandlerResultFailedESPUnmount:
            [self displayAlertWithMessage:NSLocalizedString(@"ERR_UNMOUNT_ESP_MSG", nil) inlcudingInfo:NSLocalizedString(@"ERR_UNMOUNT_ESP_INFO", nil)];
            break;
        case PatchHandlerResultFailedOCBuild:
            [self displayAlertWithMessage:NSLocalizedString(@"ERR_OC_BUILD_FAIL_MSG", nil) inlcudingInfo:NSLocalizedString(@"ERR_OC_BUILD_FAIL_INFO", nil)];
            break;
        case PatchHandlerResultFailedPatchSysVol:
            [self displayAlertWithMessage:NSLocalizedString(@"ERR_OC_SYS_PATCH_FAIL_MSG", nil) inlcudingInfo:NSLocalizedString(@"ERR_OC_SYS_PATCH_FAIL_INFO", nil)];
            break;
        case PatchHandlerResultSuccess:
            break;
            
        default:
            [self displayAlertWithMessage:NSLocalizedString(@"ERR_UNKNOWN_MSG", nil) inlcudingInfo:NSLocalizedString(@"ERR_UNKNOWN_INFO", nil)];
            break;
    }
}

@end
