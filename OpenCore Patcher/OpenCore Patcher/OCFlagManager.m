//
//  OCFlagManager.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/17/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "OCFlagManager.h"

@implementation OCFlagManager

-(id)init {
    self = [super init];
    NSArray *flagsProto = [[NSArray alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@OCFlagsPlist]];
    NSMutableArray *flagObjects = [[NSMutableArray alloc] init];
    for (NSDictionary *d in flagsProto) {
        [flagObjects addObject:[[OCFlag alloc] initWithDict:d]];
    }
    _flags = [NSArray arrayWithArray:flagObjects];
    return self;
}

+ (OCFlagManager *)sharedInstance {
    static OCFlagManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
