//
//  OCLoggingManager.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/18/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "OCLoggingManager.h"

@implementation OCLoggingManager

-(id)init {
    self = [super init];
    self.log = @"";
    return self;
}
+ (OCLoggingManager *)sharedInstance {
    static OCLoggingManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
-(void)addLogEntry:(NSString *)entry {
    self.log = [self.log stringByAppendingString:[NSString stringWithFormat:@"\n\n%@\n\n", entry]];
    [self.delegate logDidUpdateWithText:self.log];
}
-(void)resetLog {
    self.log = @"";
    [self.delegate logDidUpdateWithText:self.log];
}

#pragma mark Delegated Functions

-(void)logDidUpdateWithText:(NSString *)text {
    self.log = [self.log stringByAppendingString:text];
    [self.delegate logDidUpdateWithText:self.log];
}

@end
