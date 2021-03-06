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
    _optionalFlags = [NSArray arrayWithArray:flagObjects];
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

-(NSArray *)buildArgs {
    
    NSMutableArray *args = [[NSMutableArray alloc] init];
    [args addObject:@"--build"];
    [args addObject:@"--disk"];
    [args addObject:_targetDrive.bsdName];
    
    for (OCFlag *flag in self.optionalFlags) {
        if (flag.enabled) {
            [args addObject:flag.arg];
        }
    }
    if (![self.targetModel isEqualToString:self.machineModel]) {
        [args addObject:@"--model"];
        [args addObject:self.targetModel];
    }
    
    return args;
}
-(NSArray *)sysVolPatchArgs {
    return [NSArray arrayWithObjects:@"--patch_sys_vol", nil];
}
-(void)setTargetModel:(NSString *)targetModel {
    _targetModel = targetModel;
    for (OCFlag *f in _optionalFlags) {
        if ([f.defaultModels containsObject:targetModel]) {
            f.enabled = YES;
        } else {
            f.enabled = NO;
        }
    }
}
@end
