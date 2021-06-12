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

-(void)handleApplicationError:(ApplicationError)err {
    NSString *info, *msg;
    switch (err) {
        case ApplicationErrorNoPython:
            info = [[NSBundle mainBundle] localizedStringForKey:@"ERR_PYTHON3_INFO" value:nil table:nil];
            msg = [[NSBundle mainBundle] localizedStringForKey:@"ERR_PYTHON3_MSG" value:nil table:nil];
            
    }
    if (!self.delegate) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setAlertStyle:NSCriticalAlertStyle];
        [alert setMessageText:msg];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
    }
}


@end
