//
//  OCLoggingManager.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/18/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCLoggingManagerClient.h"

@protocol OCLoggingManagerDelegate <NSObject>

-(void)logDidUpdateWithText:(NSString *)text;

@end

@interface OCLoggingManager : NSObject <OCLoggingManagerClientDelegate>

@property (strong) id <OCLoggingManagerDelegate> delegate;
@property (nonatomic, strong) NSString *log;

+ (OCLoggingManager *)sharedInstance;
-(void)addLogEntry:(NSString *)entry;
-(void)resetLog;

@end
