//
//  OCPatchHandler.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/16/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SERVER_ID "org.dortania.OpenCore-Patcher"

//Reserved for future error enumeration
typedef enum {
    HelperStatusSuccess = 0,
    HelperStatusErrorGeneral = 1
} HelperStatus;

@interface OCPatchHandler : NSObject {
    NSConnection *connection;
    BOOL shouldKeepRunning;
}

-(id)init;
-(void)startIPCService;
-(oneway void)terminateHelper;

@end
