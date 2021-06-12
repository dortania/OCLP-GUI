//
//  OCErrorHandler.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/7/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef enum {
    ApplicationErrorNoPython = 1
} ApplicationError;


@protocol OCErrorHandlerDelegate <NSObject>

@end



@interface OCErrorHandler : NSObject

@property (strong) id <OCErrorHandlerDelegate> delegate;

+ (OCErrorHandler *)sharedInstance;
-(void)handleApplicationError:(ApplicationError)err;


@end
