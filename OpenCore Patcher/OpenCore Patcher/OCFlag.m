//
//  OCFlag.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/17/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "OCFlag.h"

@implementation OCFlag

-(id)init {
    self = [super init];
    _enabled = NO;
    return self;
}

-(id)initWithDict:(NSDictionary *)d {
    self = [self init];
    _arg = [d objectForKey:@kArg];
    _helpString = [d objectForKey:@kHelpString];
    _enabled = [[d objectForKey:@kDefaultState] boolValue];
    return self;
}

@end
