//
//  OCErrorHandler.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/7/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OCPatchHandler.h"


typedef enum {
    ApplicationErrorHelperLaunchFailed = 1
} ApplicationError;


@protocol OCErrorHandlerDelegate <NSObject>

-(void)displayAlertWithMessage:(NSString *)msg andInfo:(NSString *)info;

@end



@interface OCErrorHandler : NSObject

@property (strong) id <OCErrorHandlerDelegate> delegate;

+ (OCErrorHandler *)sharedInstance;
-(void)handleApplicationError:(ApplicationError)err;
-(void)handleHelperError:(PatchHandlerResult)result;


@end
