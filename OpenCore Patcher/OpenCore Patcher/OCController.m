//
//  OCController.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/7/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "OCController.h"



@implementation OCController

+ (OCController *)sharedInstance {
    static OCController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(id)init {
    self = [super init];
    return self;
}

-(BOOL)python3IsInstalled {
    return ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/local/bin/python3"]);
}

@end
